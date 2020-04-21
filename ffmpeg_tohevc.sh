#!/bin/bash
name=mp4
rate=10M
#ffmpeg -init_hw_device vaapi=amd:/dev/dri/renderD129  -hwaccel vaapi -hwaccel_device amd -hwaccel_output_format vaapi -i testlarge.mp4 -filter_hw_device amd -vf 'format=p010|vaapi,hwupload' -c:v hevc_vaapi -bf 0 -qp 1 -b:v 5M -c:a copy -c:s  mov_text output.mp4
for file in *."${name}"; do
    ffmpeg -init_hw_device vaapi=device:/dev/dri/renderD129  -hwaccel vaapi -hwaccel_device device -hwaccel_output_format vaapi -i "${file}" -filter_hw_device device -vf 'format=p010|vaapi,hwupload' -c:v hevc_vaapi -bf 0 -c:a copy -c:s mov_text "output.mp4"
    if [[ $? != 0 ]]; then exit 1 ; fi
    rm -f "${file}"
    if [[ $? != 0 ]]; then exit 1 ; fi
    mv output.mp4 "${file%${name}}mp4"
done
