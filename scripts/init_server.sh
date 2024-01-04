#!/bin/bash

START_TIME=$(date +%s)

# Import server functions
crontab -e
@reboot /home/ubuntu/cinevoraces_infra/scripts/on_boot.sh
./scripts/on_boot.sh

# Install Dependencies
sudo apt update
sudo apt install -y ca-certificates curl gnupg nginx fail2ban
sudo snap install --classic certbot
./scripts/install_docker.sh

# Firewall config
echo "Define SSH port:"
read ssh_port

echo "y" | sudo ufw enable
sudo ufw allow 'OpenSSH'
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow $ssh_port/tcp

sudo sed -i 's/ListenStream=22/ListenStream=$ssh_port/g' /lib/systemd/system/ssh.socket

sudo systemctl start nginx
sudo systemctl enable fail2ban
sudo systemctl daemon-reload 
sudo systemctl restart ssh.service
sudo systemctl restart ufw

# Install cinevoraces
./scripts/install_cinevoraces.sh

# Initial nginx configuration (needed for certbot)
sudo rm -rf /etc/nginx/sites-enabled/default
sudo cp ./nginx/initial.conf /etc/nginx/conf.d/default.conf

# Certbot certificate generation
if [ ! -L /usr/bin/certbot ]; then
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi
sudo certbot --nginx --non-interactive --agree-tos --email cinevoraces@gmail.com --domains cinevoraces.fr,www.cinevoraces.fr

# Final nginx configuration
sudo cp ./nginx/default.conf /etc/nginx/conf.d/default.conf

END_TIME=$(date +%s)
BUILD_TIME=$((END_TIME - START_TIME))
echo "###########################################"
echo "Server initialization completed."
echo "Build time: $BUILD_TIME seconds"
echo "###########################################"