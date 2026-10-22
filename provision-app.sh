#!/bin/bash

#stop the sript  if a command fails
set -e

repo_url="https://github.com/thantzintun232/tictactoe.git"
deploy_dir="$HOME/tictactoe-github"

sudo apt-get update
sudo apt-get install -y curl ca-certificates unzip git	#install basic tools

curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh 	#download the node.js 20
sudo bash nodesource_setup.sh 
sudo apt-get install -y nodejs 

# If the repository exists, update it
if [ -d "$deploy_dir/.git" ]; then
    cd "$deploy_dir"
    git pull --ff-only
else
    # Otherwise, download it
    git clone "$repo_url" "$deploy_dir"
fi

cd "$deploy_dir/app"

npm ci --ignore-scripts

# Install PM2 globally
sudo npm install -g pm2

# Remove the old PM2 entry if it exists
if pm2 describe tictactoe > /dev/null 2>&1; then
    pm2 delete tictactoe
fi

# Start the app from the current folder
pm2 start npm --name tictactoe -- start

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

# Load the new configuration
sudo systemctl restart nginx
