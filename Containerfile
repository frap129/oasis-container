FROM debian:latest as builder

# Setup build environment
WORKDIR /build
RUN apt update && apt install -y \
        gcc \
        bison \
        curl \
        git \
        ninja-build \
        lua5.2 \
        pax \
        libwayland-dev \
        libpng-dev \
        nasm \ 
        xz-utils && \
    curl -O http://musl.cc/x86_64-linux-musl-cross.tgz && \
    zcat x86_64-linux-musl-cross.tgz | pax -r && \
    git config --global user.name "oasis-builder" && \
    git config --global user.email "oasis-builder@email" && \
    mkdir root

# Setup Oasis src and root dir
WORKDIR /build
RUN git clone -c 'core.sharedRepository=group' https://github.com/oasislinux/oasis.git src/oasis && \
    cd /build/root && \
    git init --template /build/src/oasis/template && \
    cd /build/src/oasis
COPY config.lua /build/src/oasis/config.lua

# Build Oasis
WORKDIR /build/src/oasis
RUN export PATH=$PATH:/build/x86_64-linux-musl-cross/bin && \
    SET=all lua setup.lua && ninja commit

# Copy completed build into new root
WORKDIR /build/root
RUN git pull /build/src/oasis/out/root.git master && \
    /build/root/libexec/applyperms

# Add files from default rootfs template
WORKDIR /build/root
RUN cd /tmp && curl -LO https://github.com/oasislinux/etc/archive/master.tar.gz && \
    cd /build/root && zcat /tmp/master.tar.gz | pax -r -s ',^etc-[^/]*,etc,' && \
    ./libexec/applyperms -d etc && \
    rm etc/.perms

# Copy the built root into a new container
FROM scratch as oasis

COPY --from=builder /build/root /

