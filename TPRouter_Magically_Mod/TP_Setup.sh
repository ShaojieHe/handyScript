#FOR WAR-1200L
echo 'Begin xD'

#(optional)
#passwd -l root

mkdir /tmp/userconfig/root
mkdir /tmp/userconfig/root/ipk
if [ ! -f /tmp/userconfig/root/ipk/curl_7.38.0-1_ar71xx.ipk ]; then
    wget -P /tmp/userconfig/root/ipk/ 'http://archive.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/base/curl_7.38.0-1_ar71xx.ipk'
fi

if [ ! -f /tmp/userconfig/root/ipk/libcurl_7.38.0-1_ar71xx.ipk ]; then 
    wget -P /tmp/userconfig/root/ipk/ 'http://archive.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/base/libcurl_7.38.0-1_ar71xx.ipk'
fi

if [ ! -f /tmp/userconfig/root/ipk/libpolarssl_1.3.9-2_ar71xx.ipk ]; then
    wget -P /tmp/userconfig/root/ipk/ 'http://archive.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/base/libpolarssl_1.3.9-2_ar71xx.ipk'
fi

mkdir /root/ipk
cp -r /tmp/userconfig/root/ipk/ /root
opkg install /root/ipk/*.ipk

cat /etc/opkg.conf | sed '/src\/gz/d' > /root/opkg.conf.new
echo "src/gz packages http://archive.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/packages" >> /root/opkg.conf.new
echo "src/gz base http://archive.openwrt.org/barrier_breaker/14.07/ar71xx/generic/packages/base" >> /root/opkg.conf.new
mv /etc/opkg.conf /etc/opkg.conf.old
cp /root/opkg.conf.new /etc/opkg.conf

opkg update
opkg install screen

cp /tmp/userconfig/root/DDNS.sh /root/DDNS.sh
sh /root/DDNS.sh

echo "*/3 * * * * /bin/sh /root/DDNS.sh" | crontab -
/usr/sbin/crond -b -c /etc/crontabs -l 8
