FROM ubuntu:14.04

MAINTAINER Andrey Yaroshenko <da3n00r@gmail.com>

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

RUN wget -O /home/moses/RELEASE-3.0.zip https://github.com/moses-smt/mosesdecoder/archive/RELEASE-3.0.zip
RUN unzip RELEASE-3.0.zip 
RUN rm RELEASE-3.0.zip
RUN mv mosesdecoder-RELEASE-3.0 mosesdecoder-src

# mgizapp
RUN git clone https://github.com/moses-smt/mgiza.git
WORKDIR /home/moses/mgiza/mgizapp
RUN cmake .
RUN make
RUN make install

WORKDIR /home/moses
RUN mkdir train-tools
RUN cp mgiza/mgizapp/bin/* train-tools
RUN cp mgiza/mgizapp/scripts/merge_alignment.py train-tools

#CMPH
RUN wget -O cmph-2.0.tar.gz "http://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz?r=&ts=1426574097&use_mirror=cznic"
RUN tar zxvf cmph-2.0.tar.gz
WORKDIR /home/moses/cmph-2.0
RUN ./configure
RUN make
RUN make install
WORKDIR /home/moses

#IRSTLM
RUN wget -O irstlm-5.80.08.tgz "http://downloads.sourceforge.net/project/irstlm/irstlm/irstlm-5.80/irstlm-5.80.08.tgz?r=&ts=1342430877&use_mirror=kent"
RUN tar zxvf irstlm-5.80.08.tgz
WORKDIR /home/moses/irstlm-5.80.08/trunk
RUN /bin/bash -c "source regenerate-makefiles.sh"
RUN ./configure -prefix=/home/moses/irstlm
RUN make
RUN make install

# Build moses
ENV IRSTLM /home/moses/irstlm
WORKDIR /home/moses/mosesdecoder-src

RUN ./bjam -a --with-irstlm=/home/moses/irstlm --serial --with-xmlrpc-c=/usr/ --with-cmph=/home/moses/cmph-2.0 \
    --prefix=/home/moses/mosesdecoder --install-scripts debug-symbols=off


WORKDIR /home/moses