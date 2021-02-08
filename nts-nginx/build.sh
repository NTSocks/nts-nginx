#!/bin/bash

./configure --prefix=/home/ntb-server2/nginx-nts/local/nginx --with-nts --with-debug
make
make install
