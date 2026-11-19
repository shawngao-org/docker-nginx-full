# nginx-full

<p>
  <img src="https://img.shields.io/badge/nginx-1.31.9-green.svg?style=for-the-badge">
  <a href="https://hub.docker.com/repository/docker/zetohkr/nginx-full">
    <img src="https://img.shields.io/docker/stars/zetohkr/nginx-full.svg?style=for-the-badge">
  </a>
  <a href="https://hub.docker.com/repository/docker/zetohkr/nginx-full">
    <img src="https://img.shields.io/docker/pulls/zetohkr/nginx-full.svg?style=for-the-badge">
  </a>
</p>

> This project is an unofficial fork of NginxProxyManager/docker-nginx-full, in which OpenResty has been replaced with Nginx.
> However, it has not been thoroughly tested and is not recommended for use in a production environment.

> Below is the readme file written by the original author.

This is a base image for use in other images. See Dockerfile for build steps.

The following images are built:

**latest**
- Nginx

**certbot**
- Certbot
- Python3 and pip

**acmesh** _(used in Nginx Proxy Manager v3)_
- Acme.sh

**certbot-node** _(used in Nginx Proxy Manager v2)_
- Certbot
- Python3 and pip
- Nodejs

**acmesh-golang** _(development for Nginx Proxy Manager v3)_
- Acme.sh
- Golang

The following architectures are supported for all images:

- amd64
- arm64

### Usage:

```
FROM zetohkr/nginx-full:latest

...
```

#### Acme.sh Example

```
docker run \
  -v /path/to/local/acme-data:/data/.acme.sh \
  zetohkr/nginx-full:acmesh \
  acme.sh -h
```

### Building locally

```
./scripts/bake.sh --load

# to save time, only build for your architecture:
./scripts/bake.sh --load --set '*.platform=linux/amd64'
```
