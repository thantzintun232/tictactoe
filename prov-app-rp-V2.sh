#!/bin/bash

echo update the sources list...
sudo apt-get update -y
echo Done!

echo upgrade any packages available...
sudo apt-get upgrade -y
echo Done!

echo install nginx...
sudo apt-get install nginx -y
echo Done!

echo setup nginx reverse proxy...
sudo apt install sed
# $ and / characters must be escaped by putting a backslash before them
sudo sed -i "s/try_files \$uri \$uri\/ =404;/proxy_pass http:\/\/localhost:3000\/;/" /etc/nginx/sites-available/default
# restart nginx to get reverse proxy working
sudo systemctl restart nginx
echo Done!

#echo install git...
#sudo apt-get install git -y
#echo Done!

echo install nodejs v20...
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
echo install nodejs - Done!

echo check node js version
node -v
echo Done!

# decide on mode to use to start app
# use ONE of the following options

# OPTION 1
# DO NOT set any STATEFUL_MODE environment variable AND
# DO NOT set any MONGODB_URI environment variable
#echo using Mode: Client-local stateful...
#echo "  Not setting environment variables STATEFUL_MODE or MONGODB_URI for this mode"
#echo Done!

# OPTION 2
#echo using Mode: Server-side stateful...
#echo "  Setting environment variable STATEFUL_MODE=server..."
#export STATEFUL_MODE=server
#echo Done!

# OPTION 3 (only use if have a Mongo DB to connect to)
#echo using Mode: Persistent with Mongo DB...
#echo "Setting environment variable MONGODB_URI..."
# if coming through externally with Azure, be careful security group allows mongo db
# if coming through internally or externally with AWS, be careful security group allows mongo db
#export MONGODB_URI=mongodb://172.31.19.159:27017/tictactoe
#echo Done!

echo clone repo with app folder into folder called 'repo'...
git clone https://github.com/LSF970/tech613-tictactoe-app.git repo
echo Done!

echo cd into app folder...
cd repo
cd app
echo Done!

echo npm install - must be after db vm is finished provisioning...
# will try to seed the scoreboard, but will only work with OPTION 3 (persistent with Mongo DB) when it will directly seed the database
# because usually the app would not be running yet with OPTION 2 which relies on a running app instance
npm install
echo Done!

# uncomment if need to clear and seed database manually
# with OPTION 1 (client-local stateful), the app cannot be seeded (scoreboard is stored locally in the client)
# with OPTION 2, the app must be running to seed the database
# with OPTION 3, the database must be running and accessible to seed the database
#echo "Clearing and seeding database..."
#node seeds/seed.js
#echo "Done!"

# ways to start the app:
# 1. directly:

# start the app (could also use 'npm start')
#node index.js

# 2. start in background using EITHER forever or pm2

# using forever
# install forever
#sudo npm install forever -g
# kill previous app background processes
#forever stopall
# start the app in the background with forever
#forever start index.js

# using pm2
echo install pm2...
sudo npm install pm2 -g
echo Done!

# pm2 kill
pm2 kill
echo Done!

echo start the app in the background with pm2...
pm2 start index.js --name tic
echo Done!