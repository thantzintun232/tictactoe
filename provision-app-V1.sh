#!/bin/bash

#stop the sript  if a command fails
set -e

repo_url="https://github.com/thantzintun232/tictactoe.git"

deploy_dir="/home/ubuntu/tictactoe-github"

sudo apt-get update
sudo apt-get install -y curl ca-certificates unzip git	#install basic tools

curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh 	#download the node.js 20
sudo bash nodesource_setup.sh 
sudo apt-get install -y nodejs 

# Download or update the app as ubuntu
if [ -d "$deploy_dir/.git" ]; then
    sudo -u ubuntu git -C "$deploy_dir" pull --ff-only #-C tells Git which folder to work in
else
    sudo -u ubuntu git clone "$repo_url" "$deploy_dir"
fi

cd "$deploy_dir/app"

# Install app dependencies as ubuntu
sudo -H -u ubuntu npm ci --ignore-scripts # -H sets the home dir / -u ubuntu runs as ubuntu

# Install PM2 globally
sudo npm install -g pm2

# Remove the existing app entry if it exists
if sudo -H -u ubuntu pm2 describe tictactoe > /dev/null 2>&1; then
    sudo -H -u ubuntu pm2 delete tictactoe
fi

# Start the app as ubuntu
sudo -H -u ubuntu pm2 start npm --name tictactoe -- start

# Configure PM2 to start after a reboot
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu

# Save ubuntu's app list for reboot recovery
sudo -H -u ubuntu pm2 save

# Install Nginx
sudo apt-get install -y nginx

# Forward port 80 requests to the app on port 3000
sudo tee /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    location / {
        proxy_pass http://localhost:3000;
    }
}
EOF

# Check the Nginx configuration
sudo nginx -t

# Start Nginx automatically when the server boots
sudo systemctl enable nginx

# Load the new configuration
sudo systemctl restart nginx
