#!/bin/bash

# Backup the current configuration file
current_date_time=$(date +"%Y_%m_%d-%H-%M-%S")
mkdir -p ./nginx/bak
cp /etc/nginx/conf.d/default.conf "./nginx/bak/default.conf_${current_date_time}.bak"

# Update the configuration file
cp ./nginx/default.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx