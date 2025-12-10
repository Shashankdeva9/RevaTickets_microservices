#!/bin/bash

# EC2 Setup Script for Rev-Tickets All-in-One Deployment

echo "Setting up EC2 instance for Rev-Tickets..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Java and Maven
sudo apt install openjdk-17-jdk maven git -y

# Install Node.js (for frontend build)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Create application directory
sudo mkdir -p /opt/revtickets
sudo chown ubuntu:ubuntu /opt/revtickets

echo "EC2 setup complete!"
echo "Please reboot the instance and then run the deployment script."