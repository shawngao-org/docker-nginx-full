#############
# Nginx Builder
#############

FROM debian:trixie-slim AS nginxbuilder

ARG NGINX_VERSION

ENV NGINX_VERSION=${NGINX_VERSION}

RUN apt-get update \
	&& apt-get install -y \
	build-essential \
	ca-certificates \
	libncurses-dev \
	libpcre2-dev \
	libreadline-dev \
	libssl-dev \
	openssl unzip \
	wget \
	zlib1g-dev \
	git \
	libmaxminddb-dev \
	dos2unix

# Nginx build
COPY ./docker/scripts/build-nginx.sh /tmp/build-nginx.sh
RUN /tmp/build-nginx.sh

#############
# Final Image
#############

FROM debian:trixie-slim AS final
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TARGETPLATFORM
RUN echo "Base: debian:trixie-slim, ${TARGETPLATFORM:-linux/amd64}" > /built-for-arch

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	apache2-utils \
	ca-certificates \
	curl \
	figlet \
	jq \
	libncurses6 \
	libpcre2-8-0 \
	libreadline8 \
	openssl \
	perl \
	tzdata \
	unzip \
	zlib1g \
	gettext \
	wget \
	xz-utils \
	libmaxminddb-dev \
	moreutils \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/* /var/log/* /tmp/* /var/lib/dpkg/status-old

COPY ./docker/files/.bashrc /root/.bashrc

# Copy Nginx build from first image
COPY --from=nginxbuilder /tmp/nginx /tmp/nginx
COPY ./docker/scripts/install-nginx.sh /tmp/install-nginx.sh

ARG NGINX_VERSION
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
	NGINX_VERSION=${NGINX_VERSION}

# Install Nginx, then clean up file system
RUN apt-get update \
	&& apt-get install -y ca-certificates make \
	&& /tmp/install-nginx.sh \
	&& apt-get remove -y wget gettext \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/* /var/log/* /tmp/* /var/lib/dpkg/status-old

LABEL org.label-schema.schema-version="1.0" \
	org.label-schema.license="MIT" \
	org.label-schema.name="nginx-full" \
	org.label-schema.description="A base image for use by Nginx Proxy Manager" \
	org.label-schema.url="https://github.com/nginxproxymanager/docker-nginx-full" \
	org.label-schema.vcs-url="https://github.com/nginxproxymanager/docker-nginx-full.git" \
	org.label-schema.cmd="docker run --rm -ti nginxproxymanager/nginx-full:latest"
