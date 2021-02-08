#!/bin/bash

if [ $# != 1 ]; then
echo "Usage: $0 [nts-nginx installation path]"
echo " e.g.: $0 ~/nginx-nts/local/nginx"
exit 1;
fi

PREFIX_PATH=$1
mkdir -p $PREFIX_PATH

./configure --prefix=$PREFIX_PATH --with-nts --with-debug
make
make install
