#!/bin/bash

START_TIME=$(date +%s)

# Import server functions
/home/ubuntu/cinevoraces_infra/scripts/on_boot.sh

# Set cron jobs
(crontab -l 2>/dev/null; echo "@reboot /home/ubuntu/cinevoraces_infra/scripts/on_boot.sh"; echo "00 3 * * * backup_db") | crontab -

# Install Dependencies
sudo apt update
sudo apt install -y ca-certificates curl gnupg nginx fail2ban
sudo snap install --classic certbot
echo "y" | sudo ufw enable

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's repository to Apt sources
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER

# Firewall config
ssh_port=52255
echo "Define SSH port (default is $ssh_port):"
read input_ssh_port
if [ -n "$input_ssh_port" ]; then
    ssh_port=$input_ssh_port
fi

sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow $ssh_port/tcp

# Add Docker firewall rules to UFW
sudo wget -O /usr/local/bin/ufw-docker \
  https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
sudo chmod +x /usr/local/bin/ufw-docker
yes | sudo ufw-docker install
sudo systemctl restart ufw

sudo sed -i "s/ListenStream=22/ListenStream=$ssh_port/g" /lib/systemd/system/ssh.socket
sudo sed -i "s/#Port 22/Port $ssh_port/g" /etc/ssh/sshd_config

sudo systemctl start nginx
sudo systemctl enable fail2ban
sudo systemctl daemon-reload 
sudo systemctl restart ssh.service

# Download cinevoraces from public source
git clone https://github.com/Cinevoraces/cinevoraces.git

# Set .env files
if [ ! -f ./cinevoraces/app/.env.local ]; then
    echo "Set App .env.local file (Frontend)"
    echo "Press any key to continue..."
    read -n 1 -s -r
    touch ./cinevoraces/app/.env.local
    nano ./cinevoraces/app/.env.local
else
    echo ".env.local already exists."
fi

if [ ! -f ./cinevoraces/api/.env ]; then
    echo "Set Api .env file (Backend)"
    echo "Press any key to continue..."
    read -n 1 -s -r
    touch ./cinevoraces/api/.env
    nano ./cinevoraces/api/.env
else
    echo ".env already exists."
fi

if [ ! -f ./cinevoraces/data/.env ]; then
    echo "Set Postgres .env file (Backend)"
    echo "Press any key to continue..."
    read -n 1 -s -r
    touch ./cinevoraces/data/.env
    nano ./cinevoraces/data/.env
else
    echo ".env already exists."
fi

# Build and run docker images
sudo docker compose build
sudo docker compose up -d

# Initial nginx configuration (needed for certbot)
sudo rm -rf /etc/nginx/sites-enabled/default
sudo cp ./nginx/initial.conf /etc/nginx/conf.d/default.conf

# Certbot certificate generation
if [ ! -L /usr/bin/certbot ]; then
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi
sudo certbot --nginx --non-interactive --agree-tos --email cinevoraces@gmail.com --domains safaridigital.fr,www.safaridigital.fr

# Final nginx configuration
sudo cp ./nginx/default.conf /etc/nginx/conf.d/default.conf

END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))
echo "###########################################"
echo "Server initialization completed."
echo "Build time: $BUILD_TIME seconds"
echo "###########################################"