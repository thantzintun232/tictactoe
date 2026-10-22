#!/bin/bash

#stop the sript  if a command fails
set -e

#location of the uploaded zip file
zip_file="$HOME/nodejs20-sparta-tictactoe-v1.zip"

#folder of the  script directory
deploy_dir="$HOME/tictactoe-deloyment"

sudo apt-get update	#refresh the package list
sudo apt-get install -y curl ca-certificates unzip	#install basic tools

curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh 	#download the node.js 20
sudo bash nodesource_setup.sh 
sudo apt-get install -y nodejs #install nodejs

mkdir -p "$deploy_dir"  #create a deployment folder
unzip -o "$zip_file" -d "$deploy_dir"	#extract the zip into deployment folder

# Enter the app folder
cd "$deploy_dir/app"

# Install PM2 globally
sudo npm install -g pm2

# Restart the existing app, or start it for the first time
if pm2 describe tictactoe > /dev/null 2>&1; then
    pm2 restart tictactoe
else
    pm2 start npm --name tictactoe -- start
fi
