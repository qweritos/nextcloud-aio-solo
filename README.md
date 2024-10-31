# Nextcloud AIO Solo

Fully functional Nextcloud AIO which is running in single container.

Pre-requirements:

* Since AIO doesn't support local installation, you need a load ballancer with domain name attached with valid SSL cert. It should bypass all HTTP requests to `http://<docker-server-external-endpoint>:11000`

### Setup

```bash
git clone https://github.com/qweritos/nextcloud-aio-solo.git && cd nextcloud-aio-solo

docker build -t registry.andrey.wtf/nextcloud-aio-solo:latest

# create directory for persistent datas
mkdir data

docker run -d --name nextcloud-aio-solo \
              --privileged \
              -p 8080:8080 \
              -p 11000:11000 \
              -v $(pwd)/docker-data:/var/lib/docker
              -v $(pwd)/data:/data
        registry.andrey.wtf/nextcloud-aio-solo:latest
```

* Wait for [Nextcloud AIO](https://localhost:8080) to be up & running, it might take a couple minutes
* Make sure that your domain has valid SSL cert and points to port 11000
* Open [https://localhost:8080](https://localhost:8080) and follow the ordinary AIO installation steps


## WIP!

TODO:

- [ ] CI
- [ ] Docs
- [ ] Helm chart
- [ ] Try to get rid of systemd and privileged mode
