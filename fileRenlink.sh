#!/usr/bin/env bash
#Change "realinkedfile" to any thing you like
Srcdir=""
Desdir=""/relinkedfile
echo $Desdir
trap "rm -f "${Desdir}"/new_*" EXIT
type inotifywait > /dev/null || exit 1

if [[ ${1} != "-y" ]]; then exit 1 ;fi

if [[ ! -d "${Desdir}" ]]; then mkdir "$Desdir"; fi

inotifywait -mq --format '%Xe %w%f' -e modify,create,delete,attrib,move --exclude "fileRenlink.sh" ${Srcdir} | while read file
do
    file_operations=$(echo "$file" | awk '{print $1}')
    file_name=$(echo "$file" | awk '{print $2}')
    file_name=${file_name##*\/}
    if [[ ${file_operations} == "CREATE" ]]; then
    {
        echo $old
        rm -f "${Desdir}"/"${old}"
        echo Linked new file
        ln -f "${Srcdir}"/"${file_name}" "${Desdir}"/"new_${file_name}" > /dev/null 2>&1
        unset old
        old=new_${file_name}
    }
    fi
    if [[ ${file_operations} == "DELETE" ]]; then
    {
        echo Trying delete linked file
        rm -f "${Desdir}"/"new_${file_name}"
    }
    fi
done
