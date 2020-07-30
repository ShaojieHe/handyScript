#!/usr/bin/env bash
trap 'rm -f "SERVER_JSON"' EXIT
checkUpdate(){
    local returnValue
    local v1=($(echo "$1" | tr '.' ' '))
    local v2=($(echo "$2" | tr '.' ' '))
    local len="$([ "${#v1[*]}" -gt "${#v2[*]}" ] && echo "${#v1[*]}" || echo "${#v2[*]}")"
    for ((i=0; i<len; i++))
    do
        [[ "${v1[i]:-0}" > "${v2[i]:-0}" ]] && { returnValue=1; break;}
        [[ "${v1[i]:-0}" < "${v2[i]:-0}" ]] && { returnValue=2; break;}
    done
    if [[ ${returnValue} == 1 ]];then
        UPDATE="可更新"
    elif [[ ${returnValue} == 2 ]];then
        UPDATE="由于不在线未知"
    else
        UPDATE="不需更新"
    fi
}

checkOnline(){
    ps -aux | grep [t]s3 > /dev/null
    if [[ $? == 0 ]]; then 
        FLAG_ONLINE=1
        FLAG_UPDATEABLE=0
        ONLINE="在线"
    else
        FLAG_ONLINE=0
        FLAG_UPDATEABLE=1
        ONLINE="不在线"
    fi
}

getLatestStableVersion() {   
    TS3_SERVER_VERSION="";
    TS3_SERVER_VERSION=$(cat SERVER_JSON | jq ".linux .$(uname -m) .version" | tr -d '"')
}

getSystemArch(){
    ARCH=$(uname -m)
    case $ARCH in 
        x86_64)
            ARCH='amd64'
        ;;
        x86)
            ARCH='x86'
        ;;
        *)
            'echo 系统架构不支持('
            exit 0
    esac
}

getInstalledVersion(){
(
    cat <<- VERSION
        spawn telnet "localhost" "10011"
        expect "Welcome to the TeamSpeak 3 ServerQuery"
        send "version\r"
        expect "error id="
        send "quit\r"
			VERSION
) | expect 2> /dev/null | grep -Eo "version=[0-9\.?]+" | cut -d "=" -f2
}

getLatestStableDownloadLink(){
    getLatestStableVersion
    getSystemArch
    DOWNLOAD_URL="https://files.teamspeak-services.com/releases/server/${TS3_SERVER_VERSION}/teamspeak3-server_linux_${ARCH}-${TS3_SERVER_VERSION}.tar.bz2"
    wget -t1 -T5 --spider -q "$DOWNLOAD_URL"
    if [[ $? == 0 ]]; then 
        FLAG_CANDOWNLOAD='1'
    else
        FLAG_CANDOWNLOAD='0'
    fi
}

checkCRC(){
    #参数1 服务器端包位置(string)
    echo ${1}
    if [ ! -f "${1}" ];then echo 未发现文件 正在返回菜单; menu;fi 
    CRC=$(cat SERVER_JSON | jq ".linux .$(uname -m) .checksum" | tr -d '"')
    toCheck=$(sha256sum ${1} | awk '{print $1}')
    if [[ $CRC == $toCheck ]]; then 
        echo "CRC匹配"
        FLAG_UPDATEABLE=1
    elif [[ $CRC != $toCheck ]]; then
        echo "CRC不匹配 请重新下载"
        FLAG_UPDATEABLE=0
    fi
}

downloadStableServer(){
    if [[ $FLAG_CANDOWNLOAD == 0 ]] ;then
        echo "不能自动下载 请手动下载该URL"
        echo ${DOWNLOAD_URL}
    elif [[ ${FLAG_CANDOWNLOAD} == 1 ]] ;then
        wget ${DOWNLOAD_URL}
    fi
}

searchInstalledRoot(){
    DIR_ROOT="$(pwd)/$(find ./  -name ts3server_startscript.sh 2>/dev/null | sed 's/ts3server_startscript.sh//')"
    if [[ $? == 0 ]]; then FLAG_FIND=1; fi
}

beforeStartup(){
    #提前获取JSON
    SERVER_JSON=$(mktemp)
    wget -t1 -T5 --spider -q 'https://www.teamspeak.com/versions/server.json'
    if [[ $? != 0 ]]; then echo '无法连接更新服务器'; exit 1 ;fi
    curl -s 'https://www.teamspeak.com/versions/server.json' > SERVER_JSON
    #检查基础依赖
    which jq curl wget tar uname tr cat awk grep sed telnet expect> /dev/null 2>&1
    if [[ $? != 0 ]];then echo '缺少依赖' ;exit 1;fi
    USER=$(id -un)
    if [[ $UID == 0 ]]; then echo '不可用Root账户运行'; exit 0 ;fi
    checkOnline
    getLatestStableVersion
    TS3_INSTALLED_SERVER_VERSION=$(getInstalledVersion)
    checkUpdate $TS3_SERVER_VERSION ${TS3_INSTALLED_SERVER_VERSION:-'9.9.9'}
    getLatestStableDownloadLink
    searchInstalledRoot
}

installPKG(){
    searchInstalledRoot
    if [[ ${FLAG_FIND:-0} == 0 ]];then
        echo 没有找到安装文件夹
        echo 请检查安装位置
        menu
    fi
    if [ ! -f "teamspeak3-server_linux_${ARCH}-${TS3_SERVER_VERSION}.tar.bz2" ]; then
        echo 未找到更新文件
        echo 请把更新文件放在该文件夹下并命名为
        echo "teamspeak3-server_linux_${ARCH}-${TS3_SERVER_VERSION}.tar.bz2"
        menu
    fi
    if [[ $FLAG_ONLINE == 1 ]];then 
        echo 服务器还在运行 请关闭后在进行更新
        echo 正在返回菜单
        menu
    fi
    checkCRC "./teamspeak3-server_linux_${ARCH}-${TS3_SERVER_VERSION}.tar.bz2"
    if [[ $FLAG_UPDATEABLE == 0 ]]; then
        echo 未满足全部更新条件 正在返回菜单
    fi
    tar -C "${DIR_ROOT}/../" -axvf "./teamspeak3-server_linux_${ARCH}-${TS3_SERVER_VERSION}.tar.bz2"
    echo "更新完成~"
}

if [ -t 0 ]; then 
    clear
fi

echo "正在准备中..."
beforeStartup
clear

menu(){
echo
echo 服务器状态 $ONLINE
echo 最新稳定版版本号为 \*$TS3_SERVER_VERSION\*
echo 已安装版本号为 \*${TS3_INSTALLED_SERVER_VERSION:-'由于不在线而不能检测'}\*
echo 需要更新吗? $UPDATE
echo

echo 菜单
echo "1) 下载最新版进行更新"
echo "2) 获取手动下载URL"
echo "3) 直接开始更新"
echo "4) 以systemctl方式启动/停止ts进程"
echo "5/*) 退出"
echo
read -p '请输入你的选择  ' choose
echo
case $choose in
    1) 
        echo wait
    ;;
    2) 
        getLatestStableDownloadLink
        echo "可下载 版本号为${TS3_SERVER_VERSION}的服务端"
        echo "${DOWNLOAD_URL}"
        menu
    ;;
    3)
        installPKG
        menu
    ;;
    4)
        echo wait
    ;;
    5|*)
        exit 0
    ;;
esac

}
menu
