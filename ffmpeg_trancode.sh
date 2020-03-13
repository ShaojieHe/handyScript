#!/bin/bash

#ffmpeg -init_hw_device vaapi=foo:/dev/dri/renderD128 -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device foo -i input.mp4 -filter_hw_device foo -vf 'format=nv12|vaapi,hwupload' -c:v h264_vaapi output.mp4
for file in *.mkv;  
    do ffmpeg -init_hw_device vaapi=foo:/dev/dri/renderD128 -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device foo -i "$file" -filter_hw_device foo -vf 'format=nv12|vaapi,hwupload' -c:v h264_vaapi "${file%.mkv}".mp4; 
done
