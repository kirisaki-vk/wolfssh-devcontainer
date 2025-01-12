FROM alpine:latest

# Updates the base image and installs all required tools to build WolfSSH and WolfSSL
# It also installs python and pip for Python script developpement
RUN apk update && \
    apk add --virtual build-essentials build-base gcc gdb autoconf automake libtool git py3-pip

RUN mkdir -p /workspace

# Downloads and extract WolfSSL source code from github releases
# You can specify the WolfSSL version by modifying the WOLFSSL_VERSION value
ENV WOLFSSL_VERSION=5.7.6-stable 
RUN wget https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${WOLFSSL_VERSION}.zip -O /workspace/wolfssl.zip && \
    unzip /workspace/wolfssl.zip -d /workspace && mv /workspace/wolfssl-${WOLFSSL_VERSION} /workspace/wolfssl && rm /workspace/wolfssl.zip

# Building and installing WolfSSL
WORKDIR /workspace/wolfssl
RUN ./autogen.sh && \
    ./configure --enable-wolfssh && \
    make -j4 && \
    make install

# Cleanup stuffs
WORKDIR /
RUN rm -rf /workspace