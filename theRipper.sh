#!/bin/bash
type lynx > /dev/null || exit 1
#set depth
depth=2
#conf lynx
cmd="lynx --listonly --nonumbers --dump --auth xxx:xxx -unique_urls "
#conf url
url="$1"

if [ -z $1 ]; then
    echo Usage: $0 \'URL here\'
    exit 1
fi

urldecode() {
    local urls
    urls=${1//\\/\\\\}
    urls=${urls//+/ }
    printf %b "${urls//'%'/\\x}"
}

init_url=$(urldecode ${url})
echo Now Running at $init_url
echo At ${depth} Depth

isdir() {
countdir=0
countfile=0
while read line ; 
do    
    #如果读入的是./行 则接下来所有文件夹/文件都在该下
    if [[ "${line: 0 : 2}" == './' ]]; then
    targetDir=$line
    else
        if [[ "${line: -1}" == '/' ]]; then
            echo "$line" >> dirURL
            (( countdir++ ))
        else
            #intend for aria2c (-d 指定文件夹) 你可以用xargs(parallel)直接构建完整的aria2下载指令
            echo "-d "\"${targetDir:-./}\"" "\"${line}\""" >> bashedURL
            echo "$line" >> fileURL
            (( countfile++ ))
        fi
    fi
done < "$1"
echo this pass got $countdir dirURL
echo this pass got $countfile fileURL
echo
}

i=0
rm -f fileURL dirURL inputURL bashedURL
$cmd "$url" | sed -e '1d' > ./inputURL

while :
do {
    isdir "./inputURL"
    rm -f ./inputURL
    if [ ! -f ./dirURL ]; then echo Already got all files,Exiting!; exit 0 ;fi
    (( i < depth )) || break
    while read line; do
        echo '------- Processing URL  --------'
        urldecode "${line}"
        echo
        echo '------- --------------- --------'
        #现在远程文件夹的具体位置
        echo $(urldecode ${line//${url}/./}) >> ./inputURL
        #输出实际上的内容
        ${cmd} "${line}" | sed '1d' | grep ${url} >> ./inputURL
    done < ./dirURL
    echo $i 'Pass'
    rm -f ./dirURL
    (( i++ ))
}; done
