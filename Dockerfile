FROM ubuntu:22.04

# Set environment variables for proxy, locale, and non-interactive installation
ARG http_proxy=""
ARG https_proxy=""
ENV http_proxy=${http_proxy} \
    https_proxy=${https_proxy} \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install locales, set UTF-8 encoding, install dependencies, cleanup
RUN apt-get update --fix-missing \
    && apt-get install -y curl locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get install -y sudo jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y make git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION=1.22.5
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
        amd64) GOARCH='amd64' ;; \
        arm64) GOARCH='arm64' ;; \
        *)     echo >&2 "unsupported architecture: ${ARCH}"; exit 1 ;; \
    esac; \
# Download and verify the Go tarball
curl -fsSL -o go.tgz "https://go.dev/dl/go${GOLANG_VERSION}.linux-${GOARCH}.tar.gz"; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; 
# Copy the perfspect binary to the container
COPY ./perfspect /usr/bin/perfspect
RUN mkdir -p /output
WORKDIR /output
