variable "DOCKER_IMAGE" {
	default = "zetohkr/nginx-full"
}
variable "BASE_TAG" {
	default = "latest"
}
variable "TAG_PREFIX" {
	default = ""
}
variable "NGINX_VERSION" {
	default = "1.31.9"
}
variable "NODE_MAJOR" {
	default = "26"
}

group "default" {
	targets = ["base", "acmesh", "acmesh-golang", "certbot", "certbot-node"]
}

target "common" {
	platforms = ["linux/amd64", "linux/arm64"]
}

target "base" {
	inherits = ["common"]
	dockerfile = "docker/Dockerfile"
	args = {
		NGINX_VERSION = "${NGINX_VERSION}"
	}
	tags = ["${DOCKER_IMAGE}:${BASE_TAG}"]
}

target "acmesh" {
	inherits = ["common"]
	dockerfile = "docker/Dockerfile.acmesh"
	contexts = {
		base = "target:base"
	}
	tags = ["${DOCKER_IMAGE}:${TAG_PREFIX}acmesh"]
}

target "acmesh-golang" {
	inherits = ["common"]
	dockerfile = "docker/Dockerfile.acmesh-golang"
	contexts = {
		acmesh = "target:acmesh"
	}
	tags = ["${DOCKER_IMAGE}:${TAG_PREFIX}acmesh-golang"]
}

target "certbot" {
	inherits = ["common"]
	dockerfile = "docker/Dockerfile.certbot"
	contexts = {
		base = "target:base"
	}
	tags = ["${DOCKER_IMAGE}:${TAG_PREFIX}certbot"]
}

target "certbot-node" {
	inherits = ["common"]
	dockerfile = "docker/Dockerfile.certbot-node"
	contexts = {
		certbot = "target:certbot"
	}
	args = {
		NODE_MAJOR = "${NODE_MAJOR}"
	}
	tags = ["${DOCKER_IMAGE}:${TAG_PREFIX}certbot-node"]
}
