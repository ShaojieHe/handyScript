#!/bin/bash
Depth=1
type inotifywait > /dev/null || exit 1
if [[ -e ./FileList.txt ]]; then
{
    rm -f ./FileList.txt
    echo Deleted old File list
}
fi

create(){
find . -maxdepth "${Depth}" -type f -not -path '*/\.*' | sed 's/^\.\///g' | sort > FileList.txt
echo FileList Updated
}
create
for ((;;))
{
    inotifywait -rq --format '%Xe %w%f' -e modify,create,delete,attrib,move --exclude "FileList.txt" ./
    rm -f ./FileList.exe
    create
}
