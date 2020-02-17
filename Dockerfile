FROM ubuntu:19.10

ARG kernel=./kernel
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    KERNEL_SOURCE=/kernel/

RUN apt-get update \
    && apt-get -y install debhelper cmake libllvm9 llvm-9-dev libclang-9-dev \
       libelf-dev bison flex libedit-dev clang-format-9 python python-netaddr \
       python-pyroute2 luajit libluajit-5.1-dev arping iperf netperf ethtool \
       devscripts zlib1g-dev libfl-dev \
       pkg-config libssl-dev \
       curl \
       git \
       clang \
       musl musl-tools musl-dev \
       capnproto \
       yum yum-utils \
    && apt-get clean -y

RUN curl https://sh.rustup.rs -sSf > rustup.sh \
    && sh rustup.sh -y \
          --default-toolchain stable \
          --no-modify-path \
    && rustup target add x86_64-unknown-linux-musl \
    && rustup toolchain add nightly \
    && rustup --version \
    && cargo --version \
    && rustc --version \
    && ln -s /usr/bin/llc-9 /usr/bin/llc \
    && cargo install bindgen

COPY ${kernel} /kernel
COPY yum/ /etc/yum/
WORKDIR /build
