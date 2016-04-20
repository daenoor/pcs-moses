FROM ubuntu:14.04

MAINTAINER Andrey Yaroshenko <da3n00r@gmail.com>
MAINTAINER Alex Panshin <deadyaga@gmail.com>

# Prepare system
RUN apt-get update && apt-get install -y \
    unzip \
    build-essential \
    g++ \
    autotools-dev \
    automake \
    libtool \
    wget \
    git \
    subversion \
    libboost-all-dev\
    zlib1g-dev \
    liblzma-dev \
    libbz2-dev \
    python-dev \
    libgoogle-perftools-dev \
    libxmlrpc-core-c3-dev \
    libxmlrpc-c++8-dev \
    cmake


# Moses itself
RUN mkdir -p /home/moses
WORKDIR /home/moses
ENV IRSTLM /home/moses/irstlm

COPY build.sh /home/moses/build.sh
RUN  sh ./build.sh
