#!/usr/bin/env bash
yum install wget
wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/ssr.sh
wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/tcp.sh
wget -N --no-check-certificate https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar axvf LATEST.tar.gz
yum update
