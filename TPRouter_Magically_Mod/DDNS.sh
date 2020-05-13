#!/bin/sh
SSO_KEY=''
DOMAIN_NAME=''
v4SUBDOMAIN_NAME=''
v6SUBDOMAIN_NAME=''

getip(){
case "$1" in
    -4)
        IP=`curl -4s ip.sb`
        ;;
    -6)
        IP=`curl -6s ip.sb`
        ;;
esac
}

postDomain(){
DATA=$1
TYPE=$2
#sry but I have no better idea :(
curl --insecure -X PUT "https://api.godaddy.com/v1/domains/${DOMAIN_NAME}/records/${TYPE}/${SUBDOMAIN_NAME}" -H "Authorization: sso-key $SSO_KEY" -H "Content-Type: application/json" -d "[ { \"data\": \"${DATA}\", \"ttl\": 600, \"type\": \"A\" }]"
}


case "$1" in
    -4)
        SUBDOMAIN_NAME="${v4SUBDOMAIN_NAME}"
        TYPE="A"
        ;;
    -6)
        SUBDOMAIN_NAME="${v6SUBDOMAIN_NAME}"
        TYPE="AAAA"
        ;;
    *)
        echo '-4 to DDNSv4 | -6 to DDNSv6'
        exit 1
        ;;
esac
    
getip "$1"
postDomain "$IP" "$TYPE"
echo "Domain updated on" `date` \| Type is "$TYPE" \| Pointing to "$IP" >> /root/domainLogs
