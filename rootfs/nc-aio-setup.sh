#!/bin/bash
set -e

NC_PRIMARY_CONTAINER_NAME="nextcloud-aio-nextcloud"

# launch master container if it not exists yet
[ ! "$(docker ps -a | grep nextcloud-aio-mastercontainer)" ] && docker run -d --init --sig-proxy=false \
           --name nextcloud-aio-mastercontainer \
           --restart always \
           --publish 8080:8080 \
           --env APACHE_PORT=11000 \
           --env APACHE_IP_BINDING=0.0.0.0 \
           --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
           --volume /var/run/docker.sock:/var/run/docker.sock:ro \
           --add-host=host.docker.internal:0.0.0.0 \
       nextcloud/all-in-one:latest

# WORKAROUND: fix issue where the MTU of default gateway is less than that of the container network.
# otherwise, containers might have issues with outgoing connections to the internet.
while [ "$(docker inspect -f '{{.State.Running}}' $NC_PRIMARY_CONTAINER_NAME 2>/dev/null)" != "true" ]; do
    sleep 1
done

iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS  --clamp-mss-to-pmtu
