#!/bin/sh

youtube-dl -f 137 "$1" --output "137.mp4"
youtube-dl -f 140 "$1" --output "140.m4a"
ffmpeg -i 137.mp4 -i 140.m4a -c:v copy -c:a aac -strict experimental output137.mp4
rm 137.mp4
rm 140.m4a
