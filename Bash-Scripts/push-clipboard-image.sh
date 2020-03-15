#!/bin/bash

# This script will push your current clipboard image/file, 
# Useful to bind to a global shortcut in i3, KDE, XFCE, or other DE

# DEPENDENCIES:
	# curl
	# xclip
	# jq
	# sudo apt-get install curl xclip jq

# BEFORE RUNNING, set the variable 'pbtoken' to your pushbullet access token
	# You can create a pushbullet access token by accessing your pushbullet account settings
	# Pushbullet > Settings > Account > Create Access Token

# Step 0: Set Token
pbtoken='o.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

# Step 1: Initialize Filename Variables
filename=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1) # Random File Name
extension=".jpg"

# Step 2: Dump Clipboard Contents Into '/tmp' With The Name 'clipboard_contents.png'
xclip -selection clipboard -t image/png -o > /tmp/clipboard_contents.png

# Step 3: Request URLs For Upload And File
response=$(curl --header 'Access-Token: '$pbtoken'' \
     --header 'Content-Type: application/json' \
     --data-binary '{"file_name":"'$filename$extension'","file_type":"image/jpeg"}' \
     --request POST \
     https://api.pushbullet.com/v2/upload-request)

# Step 4: Set Variable Names Using JSON Parser (jq)
fileurl=$(echo "$response" | jq -r '.file_url') # This Is Where The Image Will Be Uploaded To
uploadurl=$(echo "$response" | jq -r '.upload_url') # Upload To This URL

# Step 5: Upload The File
curl -i -X POST $uploadurl \
  -F file=@/tmp/clipboard_contents.png

# Step 6: Create Data-Binary String
urlbuild1='{"file_name":"'
urlbuild2=$filename$extension
urlbuild3='","file_type":"image/jpeg","file_url":"'
urlbuild4=$fileurl
urlbuild5='","file_type":"image/jpeg","type":"file"}'
finalbin=$urlbuild1$urlbuild2$urlbuild3$urlbuild4$urlbuild5

# Step 7: Push
curl --header 'Access-Token: '$pbtoken'' \
     --header 'Content-Type: application/json' \
     --data-binary  $finalbin \
     --request POST \
     https://api.pushbullet.com/v2/pushes

echo --DONE--
