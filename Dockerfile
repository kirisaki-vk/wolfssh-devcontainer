FROM ubuntu:latest

# Updates the base image and installs all required tools to build WolfSSH and WolfSSL
# It also installs python and pip for Python script developpement
RUN apt update && apt upgrade && \
    apt install -y build-essential gdb wget unzip autoconf libtool

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

RUN ldconfig

ENV WOLFSSH_VERSION=1.4.6-stable
RUN wget https://github.com/wolfSSL/wolfssh/archive/refs/tags/v${WOLFSSH_VERSION}.zip -O /workspace/wolfssh.zip && \
    unzip /workspace/wolfssh.zip -d /workspace && mv /workspace/wolfssh-${WOLFSSH_VERSION} /workspace/wolfssh && rm /workspace/wolfssh.zip

# Bulding aand installing WolfSSH
WORKDIR /workspace/wolfssh
RUN ./autogen.sh && \
    ./configure --enable-sftp CFLAGS="-fsanitize=address -g -O0" && \
    make -j4

EXPOSE 22222
CMD [ "/workspace/wolfssh/examples/echoserver/echoserver", "-f" ]
