#!/usr/bin/env bash
Srcdir=""
Desdir=""/relinkedfile
echo $Desdir
#trap 'rm -f "${Desdir}"/"${file_name}"' EXIT
type inotifywait > /dev/null || exit 1

if [[ ${1} != "-y" ]]; then exit 1 ;fi

if [[ ! -d "${Desdir}" ]]; then mkdir "$Desdir"; fi

    inotifywait -rmq --format '%Xe %w%f' -e modify,create,delete,attrib,move --exclude "FileList.txt" ${Srcdir} | while read file
    do
    file_operations=$(echo "$file" | awk '{print $1}')
    file_name=$(echo "$file" | awk '{print $2}')
    file_name=${file_name##*\/}
    if [[ ${file_operations} == "CREATE" ]]; then
    {
        echo Linked new file
        ln -f "${Srcdir}"/"${file_name}" "${Desdir}"/"${file_name}"
    }
    fi
    if [[ ${file_operations} == "DELETE" ]]; then
    {
        echo Trying delete linked file
        rm -f "${Desdir}"/"${file_name}"
    }
    fi
    done
