#!/bin/bash

echo "Installing Dependencies..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg

echo "Installing Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Adding Docker's repository to Apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker and Nginx..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin nginx

echo "Installing certbot..."
sudo snap install --classic certbot

echo "Enabling/Starting services..."
echo "y" | sudo ufw enable
sudo systemctl start nginx

echo "Allowing OpenSSH, Nginx HTTP and Nginx HTTPS through UFW..."
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

echo "Downloading cinevoraces..."
git clone https://github.com/Cinevoraces/cinevoraces.git

echo "Building cinevoraces..."
docker compose build
docker compose up -d

echo "Copiying initial nginx configuration..."
sudo rm -rf /etc/nginx/sites-enabled/default
sudo cp ./nginx/initial.conf /etc/nginx/conf.d/default.conf

echo "Installing certificates..."
if [ ! -L /usr/bin/certbot ]; then
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi
sudo certbot --nginx --non-interactive --agree-tos --email cinevoraces@gmail.com --domains cinevoraces.fr,www.cinevoraces.fr

echo "Updating nginx configuration..."
sudo cp ./nginx/default.conf /etc/nginx/conf.d/default.conf
