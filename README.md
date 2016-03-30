# AlarmDecoder Webapp Dockerfile

This is a Dockerfile for the [AlarmDecoder Webapp](https://github.com/nutechsoftware/alarmdecoder-webapp) project. It is built by following the build instructions in that project's README, with a few tweaks to adapt to the Docker environment.

## Run Container

The container is available pre-built on [Docker Hub](https://hub.docker.com/r/codekitchen/alarmdecoder-webapp/).

```bash
docker run --rm -p 8000:8000 --device=<device_id> codekitchen/alarmdecoder-webapp
```

The container will need access to the AlarmDecoder hardware, replace
`<device_id>` with the correct USB device, e.g. `--device=/dev/ttyUSB0`.

You can then access AlarmDecoder at `http://<host_ip>:8000`.

## Complete Setup

This container exposes the gunicorn workers directly, it's recommended that set
up an nginx reverse proxy in front of the app.

You'll also likely want to created a named or mounted volume to persist the
configuration and logging, which lives at `/opt/alarmdecoder-webapp/instance`.

A complete docker-compose configuration might look something like:

```yaml
proxy:
  image: jwilder/nginx-proxy
  ports:
    - 80:80
    - 443:443
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock:ro
    - my-certs:/etc/nginx/certs

alarmdecoder:
  image: codekitchen/alarmdecoder-webapp
  environment:
    VIRTUAL_HOST: alarm.example.com
  devices:
    - /dev/ttyUSB0
  volumes:
    - alarmdecoder:/opt/alarmdecoder-webapp/instance
```
