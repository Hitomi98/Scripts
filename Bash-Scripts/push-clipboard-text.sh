#!/bin/bash

# This script will push your current clipboard text, 
# Useful to bind to a global shortcut in i3, KDE, XFCE, or other DE

# DEPENDENCIES:
	# curl
	# sudo apt-get install curl

# BEFORE RUNNING, set the variable 'pbtoken' to your pushbullet access token
	# You can create a pushbullet access token by accessing your pushbullet account settings
	# Pushbullet > Settings > Account > Create Access Token

pbtoken='o.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
curl -u $pbtoken: https://api.pushbullet.com/v2/pushes -d type=note -d body="$(xsel -ob)"

echo --DONE