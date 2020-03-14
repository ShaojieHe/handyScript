#!/bin/bash

#ffmpeg -init_hw_device vaapi=foo:/dev/dri/renderD128 -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device foo -i input.mp4 -filter_hw_device foo -vf 'format=nv12|vaapi,hwupload' -c:v h264_vaapi output.mp4
for file in *.mkv;  do 
    ffmpeg -init_hw_device vaapi=foo:/dev/dri/renderD128 -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device foo -i "$file" -filter_hw_device foo -vf 'format=nv12|vaapi,hwupload' -c:v h264_vaapi -c:s mov_text output.mp4;
    if [[ $? != 0 ]]; then exit 1 ; fi
    rm -f "$file"
    ffmpeg -i output.mp4 -vf subtitles=output.mp4 -preset ultrafast -tune animation -crf 24 -c:a copy  "${file%.mkv}.mp4"
    if [[ $? != 0 ]]; then exit 1 ; fi
    rm -f output.mp4
done
