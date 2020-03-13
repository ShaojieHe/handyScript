#!/bin/bash
dir="/home/ftpuser/extra_disk/.aria2/"
cd $dir
sed '/bt-tracker/d' aria2.conf >> aria2.conf.new
echo -n "bt-tracker=" >> aria2.conf.new
curl "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt" | sed ":a;N;s/\n/,/g;ta" | sed 's/,,/,/g' | sed 's/','*$//g' >> aria2.conf.new
mv aria2.conf aria2.conf.$(date -I).old
mv aria2.conf.new aria2.conf

