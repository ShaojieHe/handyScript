#!/usr/bin/env bash
yum install wget -y
wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/ssr.sh
wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/tcp.sh
wget -N --no-check-certificate https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar axvf LATEST.tar.gz
yum update -y
yum install openssh-server iptables-services
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 1919 -j ACCEPT
iptables -A INPUT -p tcp --dport 2048 -j ACCEPT
iptables -A INPUT -p tcp -j DROP
