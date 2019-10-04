#!/usr/bin/env bash
first_time() {
    yum install wget -y
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/ssr.sh && chmod +x ssr.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/tcp.sh && chmod +x tcp.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/v2ray.sh && chmod +x v2ray.sh
    wget -N --no-check-certificate https://raw.githubusercontent.com/ShaojieHe/handyScript/master/reboot.sh && chmod +x reboot.sh
    mv reboot.sh .reboot.sh

    read -p "****do you want install ssr auto reboot?**** y/N" choice
    if [[ -z $choice || $choice != "y" || $choice != "Y" ]]; then
        echo "0 */2 * * * /bin/bash /root/.reboot.sh" >>./cron
        crontab cron
        rm -f cron
    fi

    unset choice

    yum install openssh-server -y

    cat /etc/selinux/config | sed 's/SELINUX=enforcing/SELINUX=disabled/g' >/etc/selinux/config.new
    mv /etc/selinux/config /etc/selinux/config.old
    mv /etc/selinux/config.new /etc/selinux/config

    read -p "***auto change ssh port to 2048?*** y/N" choice
    if [[ -z $choice || $choice != "y" || $choice != "Y" ]]; then
        cat /etc/ssh/sshd_config | sed 's/#Port 22/Port 2048/g' >/etc/ssh/sshd_config.new
        mv /etc/ssh/sshd_config /etc/sshd/ssh_config.old
        mv /etc/ssh/sshd_config.new /etc/ssh/sshd_config
        systemctl reload sshd
    fi

    wget -N --no-check-certificate https://download.libsodium.org/libsodium/releases/LATEST.tar.gz

    tar axvf LATEST.tar.gz

    yum install iptables-services -y
    iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
    iptables -A OUTPUT -j ACCEPT
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --dport 21 -j ACCEPT
    iptables -A INPUT -p tcp --dport 20 -j ACCEPT
    iptables -A INPUT -p tcp --dport 1919 -j ACCEPT
    iptables -A INPUT -p tcp --dport 2048 -j ACCEPT
    iptables -A INPUT -p tcp --dport 30000:40000 -j ACCEPT
    iptables -A INPUT -p udp --dport 30000:40000 -j ACCEPT
    iptables -P INPUT DROP

    systemctl disable --now firewalld
    systemctl enable iptables.service
    service iptables save
    yum -y groupinstall "Development Tools"
    cd ./libsodium-stable
    ./configure
    make && make install
}

if [[ -z $1]]; then
echo "first_time to install"
echo "grub_check to set boot up kernel"
echo "grub_set to set boot up kernel"
fi

