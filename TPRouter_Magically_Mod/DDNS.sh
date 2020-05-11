#!/bin/sh
SSO_KEY=''
DOMAIN_NAME=''
SUBDOMAIN_NAME=''

getip(){
IP=`curl -s ip.sb`
}

postDomain(){
DATA=$1
#sry but I have no better idea :(
curl --insecure -X PUT "https://api.godaddy.com/v1/domains/${DOMAIN_NAME}/records/A/${SUBDOMAIN_NAME}" -H "Authorization: sso-key $SSO_KEY" -H "Content-Type: application/json" -d "[ { \"data\": \"${DATA}\", \"ttl\": 600, \"type\": \"A\" }]"
}

getip
echo Now Pointing to $IP
postDomain "$IP"
