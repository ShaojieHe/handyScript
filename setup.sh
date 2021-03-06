#!/usr/bin/env bash
first_time() {
    yum clear all
    yum makecache all
    yum install wget -y
    #wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/ssr.sh && chmod +x ssr.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/tcp.sh && chmod +x tcp.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/v2ray.sh && chmod +x v2ray.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/kernel.sh && chmod +x kernel.sh
    wget -N --no-check-certificate https://install.direct/go.sh && chmod +x go.sh
    yum install openssh-server -y

    cp /etc/selinux/config /etc/selinux/config.old
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    

    read -p "***auto change ssh port to 2048?*** y/N" choice
    if [[ -z $choice || $choice != "y" || $choice != "Y" ]]; then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
        sed -i 's/#Port 22/Port 2048/g' /etc/ssh/sshd_config
    fi

    #wget -N --no-check-certificate https://download.libsodium.org/libsodium/releases/LATEST.tar.gz

    #tar axvf LATEST.tar.gz

    systemctl disable --now firewalld
    systemctl enable iptables.service
    yum -y groupinstall "Development Tools"
    #cd ./libsodium-stable || exit
    #./configure
    #make && make install
    systemctl reload sshd
    yum -y install epel-release
    yum -y install yum-utils
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
    yum --enablerepo=elrepo-kernel makecache -y
    yum-config-manager --enable elrepo-kernel -y
}
first_time

yum install iptables iptables-services -y

wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/iptables.save
    
iptables-restore < iptables.save

iptables-save > /etc/sysconfig/iptables

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

timedatectl set-ntp true

wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py

chmod +x speedtest-cli

yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm

yum -y install yum-utils

yum --enablerepo=elrepo-kernel makecache -y

yum-config-manager --enable elrepo-kernel -y

yum install -y zsh

wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh

sh install.sh --unattended

rm -f install.sh

curl https://mimosa-pudica.net/src/incr-0.2.zsh > ~/.oh-my-zsh/custom/incr-02.zsh

sed -i -e 's/ZSH_THEME\=\"robbyrussell\"/ZSH_THEME\=\"ys\"/g' -e 's/\(git\)/sudo git extract z/' ~/.zshrc

echo 'source ~/.oh-my-zsh/custom/incr*.zsh' >> ~/.zshrc

yum install -y mosh

yum install -y lrzsz

yum install -y haveged

haveged

systemctl enable haveged --now
