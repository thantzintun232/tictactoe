#!/bin/bash
set -e

echo "Updating packages..."
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "Installing required tools..."
sudo apt-get install -y curl gnupg

echo "Adding MongoDB signing key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg --batch --yes \
    -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor

echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update -y

echo "Installing MongoDB 7.0.22..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mongodb-org=7.0.22 \
    mongodb-org-database=7.0.22 \
    mongodb-org-server=7.0.22 \
    mongodb-mongosh \
    mongodb-org-shell=7.0.22 \
    mongodb-org-mongos=7.0.22 \
    mongodb-org-tools=7.0.22 \
    mongodb-org-database-tools-extra=7.0.22

echo "Configuring network access..."
sudo sed -i \
    's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' \
    /etc/mongod.conf

echo "Enabling automatic startup..."
sudo systemctl enable mongod

echo "Starting MongoDB with the updated configuration..."
sudo systemctl restart mongod

echo "Checking service status..."
sudo systemctl status mongod
