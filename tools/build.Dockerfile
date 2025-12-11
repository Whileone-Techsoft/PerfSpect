# Copyright (C) 2021-2025 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

# builds tools used by the project
# build output binaries will be in workdir/bin
# build output oss_source* will be in workdir
# build image (from project root directory):
#   $ docker build -f tools/build.Dockerfile --tag perfspect-tools:$TAG ./tools

FROM ubuntu:22.04 AS builder
# Define default values for proxy environment variables
ARG http_proxy=""
ARG https_proxy=""
ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV LANG=en_US.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ARG GO_VERSION=1.25.4 
#RUN apt-get update --fix-missing && \
#    apt-get install -y --no-install-recommends software-properties-common
#RUN apt-get update --fix-missing && \
#    apt-get install --no-install-recommends -y \
#    apt-utils locales wget curl git netcat-openbsd jq zip unzip
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get update -o Acquire::CompressionTypes::Order::=gz \
                   -o Acquire::http::No-Cache=True \
                   -o Acquire::BrokenProxy=true \
                   -o Acquire::Retries=5 \
                   -o Acquire::http::Pipeline-Depth=0 \
                   --fix-missing && \
    apt-get install -y --no-install-recommends \
        software-properties-common apt-utils locales wget curl git \
        netcat-openbsd jq zip unzip || true && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
RUN for i in {1..5}; do \
        apt-get update && \
        apt-get install -y build-essential flex bison docbook-to-man libmnl-dev && \
        break; \
        echo "Retrying core build tools installation in 5 seconds... ($i/5)" && sleep 5; \
    done
#RUN locale-gen en_US.UTF-8 &&  echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales && \
    mkdir -p /usr/share/i18n/charmaps /usr/share/i18n/locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    /usr/sbin/locale-gen || true && \
    echo "LANG=en_US.UTF-8" > /etc/default/locale && \
    export LANG=en_US.UTF-8
RUN for i in {1..5}; do \
        add-apt-repository ppa:git-core/ppa -y && break; \
        echo "Retrying in 5 seconds... ($i/5)" && sleep 5; \
    done
RUN for i in {1..5}; do \
        apt-get update && apt-get install --fix-missing --fix-broken -y \
        git autotools-dev automake gcc gawk zlib1g-dev libtool libaio-dev libaio1 \
        pandoc pkgconf libcap-dev libreadline-dev default-jre default-jdk cmake gettext libssl-dev \
        gcc-riscv64-linux-gnu g++-riscv64-linux-gnu binutils-riscv64-linux-gnu cpp-riscv64-linux-gnu \
        upx \
        && break; \
        echo "Retrying in 5 seconds... ($i/5)" && sleep 5; \
    done
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-riscv64
# need golang to build go tools
#RUN rm -rf /usr/local/go && wget -qO- https://go.dev/dl/go${GO_VERSION}.linux-riscv64.tar.gz | tar -C /usr/local -xz
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /usr/local/go && \
    wget -qO- https://go.dev/dl/go${GO_VERSION}.linux-riscv64.tar.gz | tar -C /usr/local -xz
ENV PATH="${PATH}:/usr/local/go/bin"
# need up-to-date zlib (used by stress-ng static build) to fix security vulnerabilities
#RUN git clone https://github.com/madler/zlib.git \
#&& cd zlib \
#&& ./configure \
#&& make install
# build zlib for aarch64
#RUN git clone https://github.com/madler/zlib.git zlib-aarch64 \
#&& cd zlib-aarch64 \
#&& CHOST=aarch64-linux-gnu ./configure --archs="" --static \
#& make \
#&& cp libz.a /usr/lib/aarch64-linux-gnu/

#RUN cp /usr/local/lib/libz.a /usr/lib/x86_64-linux-gnu/libz.a
# Build third-party components
RUN mkdir workdir
ADD . /workdir
WORKDIR /workdir
# Ensure make is actually installed before running it
RUN for i in 1 2 3 4 5; do \
    apt-get update --fix-missing && apt-get install -y \
    build-essential git automake autoconf libtool pkg-config cmake && break || \
    (echo "Retrying make install... ($i/5)" && sleep 10); \
done
RUN apt-get update --fix-missing && apt-get install -y make build-essential
RUN which make
RUN make tools-riscv64
RUN make oss-source

FROM ubuntu:24.04 AS perf-builder
# Define default values for proxy environment variables
ARG http_proxy=""
ARG https_proxy=""
ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV LANG=en_US.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
RUN for i in 1 2 3 4 5; do \
    rm -rf /var/lib/apt/lists/* && apt-get clean && \
    apt-get update --fix-missing && \
    apt-get -o Acquire::CompressionTypes::Order::=gz install -y --no-install-recommends \
        apt-utils locales wget curl git netcat-openbsd software-properties-common jq zip unzip && break || \
    (echo "APT failed, retrying ($i/5)..." && sleep 15); \
done
RUN locale-gen en_US.UTF-8 &&  echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN for i in {1..5}; do \
        add-apt-repository ppa:git-core/ppa -y && break; \
        echo "Retrying in 5 seconds... ($i/5)" && sleep 5; \
    done

# Use relatively small ulimit. This is due to pycompile, see: https://github.com/MaastrichtUniversity/docker-dev/commit/97ab4fd04534f73c023371b07e188918b73ac9d0
# This works around python-pkg-resources taking a extremely long time to install
RUN ulimit -n 4096 && for i in {1..5}; do \
        apt-get update && apt-get install -y \
        automake autotools-dev binutils-dev bison build-essential clang cmake debuginfod \
        default-jdk default-jre docbook-utils flex gawk git libaio-dev libaio1 \
        libbabeltrace-dev libbpf-dev libc6 libcap-dev libdw-dev libdwarf-dev libelf-dev \
        libiberty-dev liblzma-dev libnuma-dev libperl-dev libpfm4-dev libreadline-dev \
        libslang2-dev libssl-dev libtool libtraceevent-dev libunwind-dev libzstd-dev \
        libzstd1 llvm-14 pandoc pkgconf python-setuptools python2-dev python3 python3-dev \
        python3-pip systemtap-sdt-dev zlib1g-dev libbz2-dev libcapstone-dev libtracefs-dev \
        gcc-riscv64-linux-gnu g++-riscv64-linux-gnu binutils-riscv64-linux-gnu cpp-riscv64-linux-gnu \
        upx \
        && break; \
        echo "Retrying in 5 seconds... ($i/5)" && sleep 5; \
    done

# libdwfl will dlopen libdebuginfod at runtime, may cause segment fault in static build, disable it. ref: https://github.com/vgteam/vg/pull/3600
RUN for i in 1 2 3 4 5; do \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get update -o Acquire::CompressionTypes::Order::=gz \
                   -o Acquire::By-Hash=yes \
                   -o Acquire::Retries=5 \
                   --fix-missing && \
    apt-get install -y --no-install-recommends \
        build-essential gcc g++ make wget \
        bzip2 lbzip2 zlib1g zlib1g-dev m4 \
	pkg-config libtraceevent-dev \
	flex bison && break || \
    (echo "APT failed on attempt $i, retrying in 10s..." && sleep 10); \
done
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gcc \
        g++ \
        make \
        wget \
        bzip2 \
        zlib1g \
        zlib1g-dev \
        m4 \
        pkg-config \
        libtraceevent-dev \
        flex \
        bison
RUN wget https://sourceware.org/elfutils/ftp/0.190/elfutils-0.190.tar.bz2 && \
    tar -xjf elfutils-0.190.tar.bz2 && \
    cd elfutils-0.190 && \
    ./configure --disable-debuginfod --disable-libdebuginfod && \
    make -j && make install && \
    cd .. && rm -rf elfutils-0.190 elfutils-0.190.tar.bz2

# build zlib for riscv64
#RUN git clone https://github.com/madler/zlib.git zlib-riscv64 \
#&& cd zlib-riscv64 \
#&& CHOST=riscv64-linux-gnu ./configure --archs="" --static \
#&& make \
#&& cp libz.a /usr/lib/riscv64-linux-gnu/

# build libelf for riscv64
RUN wget https://sourceware.org/elfutils/ftp/0.186/elfutils-0.186.tar.bz2 \
&& tar -xf elfutils-0.186.tar.bz2 \
&& cd elfutils-0.186 \
&& ./configure --host=riscv64-linux-gnu --disable-debuginfod --disable-libdebuginfod \
&& make \
&& cp libelf/libelf.a /usr/lib/riscv64-linux-gnu/

# build libpfm4 for riscv64
RUN git clone https://git.code.sf.net/p/perfmon2/libpfm4 libpfm4-riscv64 \
&& cd libpfm4-riscv64 \
&& git checkout v4.11.1 \
&& sed -i 's/^ARCH :=/ARCH ?=/' config.mk \
&& ARCH=riscv64 CC=riscv64-linux-gnu-gcc make \
&& cp lib/libpfm.a /usr/lib/riscv64-linux-gnu/

ENV PATH="${PATH}:/usr/lib/llvm-14/bin"
RUN mkdir workdir
ADD . /workdir
WORKDIR /workdir
RUN git clone --depth=1 https://github.com/torvalds/linux.git linux_perf
RUN echo 'Acquire::http::No-Cache "true";' >> /etc/apt/apt.conf.d/no-cache \
 && echo 'Acquire::http::Pipeline-Depth "0";' >> /etc/apt/apt.conf.d/no-cache \
 && echo 'Acquire::By-Hash "yes";' >> /etc/apt/apt.conf.d/no-cache \
 && echo 'Acquire::Retries "10";' >> /etc/apt/apt.conf.d/no-cache
RUN rm -rf /var/lib/apt/lists/* \
 && apt-get clean \
 && apt-get update --fix-missing \
 && apt-get install -y --no-install-recommends \
        python3 python3-dev \
        flex bison \
        libelf-dev libdw-dev libaudit-dev \
        libssl-dev zlib1g-dev pkg-config \
        build-essential \
        libcap-dev libunwind-dev libnuma-dev \
        libslang2-dev libzstd-dev \
        libbfd-dev binutils-dev \
        libbabeltrace-dev libbabeltrace1 \
        libiberty-dev libtraceevent-dev \
        systemtap-sdt-dev \
 && rm -rf /var/lib/apt/lists/*
ENV PYTHON=python3
# Remove all -Werror occurrences from perf + libbpf
RUN cd /workdir/linux_perf/tools && \
    find perf lib bpf -type f \( -name "Makefile*" -o -name "*.mk" \) -print0 | \
    xargs -0 sed -i 's/-Werror//g; s/WERROR=1/WERROR=0/g'

RUN cd /workdir/linux_perf/tools/perf && make V=1 -j1 NO_WERROR=1 WERROR=0 CFLAGS="-O2" \
    FEATURE_DWARF=1 FEATURE_BPF=1 FEATURE_LIBBPF_DYNAMIC=0 perf
RUN mkdir -p /workdir/bin && \
    cp /workdir/linux_perf/tools/perf/perf /workdir/bin/

#RUN cd /workdir/linux_perf/tools/perf && make NO_WERROR=1 WERROR=0 processwatch

#RUN make perf
#RUN make processwatch

FROM scratch AS output
COPY --from=builder workdir/bin /bin
COPY --from=builder workdir/oss_source* /
COPY --from=perf-builder workdir/bin/ /bin
