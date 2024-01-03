#!/bin/bash

if [ ! -f ./.env ]; then
  echo ".env file does not exist. Add an .env file to the root of cinevoraces_infra."
  echo "Stopping execution."
  exit 1
fi

echo "###########################################"
echo "Installing Dependencies..."
echo "###########################################"
sudo apt update
sudo apt install -y ca-certificates curl gnupg

echo "###########################################"
echo "Installing Docker's official GPG key..."
echo "###########################################"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "###########################################"
echo "Adding Docker's repository to Apt sources..."
echo "###########################################"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "###########################################"
echo "Installing Docker and Nginx..."
echo "###########################################"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin nginx

echo "###########################################"
echo "Installing certbot..."
echo "###########################################"
sudo snap install --classic certbot

echo "###########################################"
echo "Enabling/Starting services..."
echo "###########################################"
echo "y" | sudo ufw enable
sudo systemctl start nginx

echo "###########################################"
echo "Allowing OpenSSH, Nginx HTTP and Nginx HTTPS through UFW..."
echo "###########################################"
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

echo "###########################################"
echo "Downloading cinevoraces..."
echo "###########################################"
git clone https://github.com/Cinevoraces/cinevoraces.git

echo "###########################################"
echo "Building cinevoraces..."
echo "###########################################"
sudo docker compose build
sudo docker compose up -d

echo "###########################################"
echo "Copiying initial nginx configuration..."
echo "###########################################"
sudo rm -rf /etc/nginx/sites-enabled/default
sudo cp ./nginx/initial.conf /etc/nginx/conf.d/default.conf

echo "###########################################"
echo "Installing certificates..."
echo "###########################################"
if [ ! -L /usr/bin/certbot ]; then
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi
sudo certbot --nginx --non-interactive --agree-tos --email cinevoraces@gmail.com --domains cinevoraces.fr,www.cinevoraces.fr

echo "###########################################"
echo "Updating nginx configuration..."
echo "###########################################"
sudo cp ./nginx/default.conf /etc/nginx/conf.d/default.conf
