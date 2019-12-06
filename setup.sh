#!/usr/bin/env bash
first_time() {
    yum install wget -y
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/ssr.sh && chmod +x ssr.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/tcp.sh && chmod +x tcp.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/v2ray.sh && chmod +x v2ray.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/kernel.sh && chmod +x kernel.sh

    yum install openssh-server -y

    cp /etc/selinux/config /etc/selinux/config.old
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    

    read -p "***auto change ssh port to 2048?*** y/N" choice
    if [[ -z $choice || $choice != "y" || $choice != "Y" ]]; then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
        sed -i 's/#Port 22/Port 2048/g' /etc/ssh/sshd_config
    fi

    wget -N --no-check-certificate https://download.libsodium.org/libsodium/releases/LATEST.tar.gz

    tar axvf LATEST.tar.gz

    yum install iptables iptables-services -y
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/iptables.save
    
    iptables-restore < iptables.save
    rm -f iptables.save
    
    systemctl disable --now firewalld
    systemctl enable iptables.service
    service iptables save
    yum -y groupinstall "Development Tools"
    cd ./libsodium-stable || exit
    ./configure
    make && make install
    systemctl reload sshd
}
first_time

