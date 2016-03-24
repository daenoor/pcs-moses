#!/bin/bash

# Moses itself
wget -O /home/moses/RELEASE-3.0.zip https://github.com/moses-smt/mosesdecoder/archive/RELEASE-3.0.zip
unzip RELEASE-3.0.zip 
rm RELEASE-3.0.zip
mv mosesdecoder-RELEASE-3.0 mosesdecoder-src

# mgizapp
git clone https://github.com/moses-smt/mgiza.git
cd /home/moses/mgiza/mgizapp
cmake .
make
make install

cd /home/moses
mkdir train-tools
cp mgiza/mgizapp/bin/* train-tools
cp mgiza/mgizapp/scripts/merge_alignment.py train-tools

#CMPH
wget -O cmph-2.0.tar.gz "http://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz?r=&ts=1426574097&use_mirror=cznic"
tar zxvf cmph-2.0.tar.gz
cd /home/moses/cmph-2.0
./configure
make
make install
cd /home/moses

#IRSTLM
wget -O irstlm-5.80.08.tgz "http://downloads.sourceforge.net/project/irstlm/irstlm/irstlm-5.80/irstlm-5.80.08.tgz?r=&ts=1342430877&use_mirror=kent"
tar zxvf irstlm-5.80.08.tgz
cd /home/moses/irstlm-5.80.08/trunk
/bin/bash -c "source regenerate-makefiles.sh"
./configure -prefix=/home/moses/irstlm
make
make install

# Build moses
IRSTLM="/home/moses/irstlm"
cd /home/moses/mosesdecoder-src

./bjam -a --with-irstlm=/home/moses/irstlm --serial --with-xmlrpc-c=/usr/ --with-cmph=/home/moses/cmph-2.0 \
    --prefix=/home/moses/mosesdecoder --install-scripts debug-symbols=off

cd /home/moses

# Cleaning up
rm -fr mosesdecoder-src irstlm-5.80.08