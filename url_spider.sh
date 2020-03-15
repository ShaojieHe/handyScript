#!/bin/bash
type lynx || exit 1
#set depth
depth=2
#conf lynx
cmd="lynx --listonly --nonumbers --dump -unique_urls "
#conf url
url=''
isdir() {
countdir=0
countfile=0
while read line ; 
do    
    if [[ "${line: -1}" == '/' ]]; then
        echo "$line" >> dirURL
        (( countdir++ ))
    else
        echo "$line" >> fileURL
        (( countfile++ ))
    fi
done < "$1"
echo this pass got $countdir dirURL
echo this pass got $countfile fileURL
}
i=0
rm -f fileURL dirURL inputURL
$cmd "$url" | sed -e '1d' > ./inputURL
while /bin/true
do {
    isdir "./inputURL"
    rm -f ./inputURL
    (( i < depth )) || break
    while read line; do
        echo '------- processing line --------'
        echo "${line}"
        echo '------- --------------- --------'
        ${cmd} "${line}" | sed '1d' >> ./inputURL
    done < ./dirURL
    echo $i 'pass'
    rm -f ./dirURL
    (( i++ ))
}; done
