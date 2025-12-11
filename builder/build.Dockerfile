# Copyright (C) 2021-2025 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

# image contains perfspect release package build environment
# build image:
#   $ docker build --build-arg TAG=v1 -f builder/build.Dockerfile --tag perfspect-builder:v1 .
# build perfspect:
#   $ docker run --rm -v "$PWD":/localrepo -w /localrepo perfspect-builder:v1 make dist

ARG REGISTRY=
ARG PREFIX=
ARG TAG=
# STAGE 1 - image contains pre-built tools components, rebuild the image to rebuild the tools components
FROM ${REGISTRY}${PREFIX}perfspect-tools:${TAG} AS tools
# STAGE 2 - RISC-V Go build environment
FROM alpine:3.20

RUN apk add --no-cache \
    bash git wget tar build-base jq make ca-certificates

RUN wget https://go.dev/dl/go1.24.0.linux-riscv64.tar.gz && \
    tar -C /usr/local -xzf go1.24.0.linux-riscv64.tar.gz && \
    rm go1.24.0.linux-riscv64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN mkdir /prebuilt
RUN mkdir /prebuilt/tools

COPY --from=tools /bin/ /prebuilt/tools
COPY --from=tools /oss_source.tgz /prebuilt/
COPY --from=tools /oss_source.tgz.md5 /prebuilt/

RUN git config --global --add safe.directory /localrepo





# STAGE 2 - image contains perfspect's Go components build environment
#FROM golang:1.24-bullseye
# copy the tools binaries and source from the previous stage
#RUN mkdir /prebuilt
#RUN mkdir /prebuilt/tools
#COPY --from=tools /bin/ /prebuilt/tools
#COPY --from=tools /oss_source.tgz /prebuilt/
#COPY --from=tools /oss_source.tgz.md5 /prebuilt/
#RUN apt-get update && apt-get install -y git jq make
# allow git to operate in the mounted repository regardless of the user
#RUN git config --global --add safe.directory /localrepo
# install jq as it is used in the Makefile to create the manifest
#RUN apk add --no-cache jq
