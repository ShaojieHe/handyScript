#!/bin/bash
cmd="lynx -auth *:* --listonly --nonumbers --dump -unique_urls"
baseURL="add_yours"
rm -f url url2
url2=$($cmd "${baseURL}" | sed '1d')
while read line; do 
     url3=$($cmd ${line} | sed '1d' )
     echo $url3 >> url
done <<< ${url2}

sed -i 's/ /\n/g' ./url 

while read line; do
    url3=$($cmd ${line} | sed '1d')
    echo $url3 >> url2
done < ./url

sed -i 's/ /\n/g' ./url2 

cat url2 | grep .jpg  >> url3
