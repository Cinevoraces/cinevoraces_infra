#!/bin/bash

function nginx_conf_update {
    backup_folder=/home/ubuntu/cinevoraces_infra/nginx/bak
    config_file=/home/ubuntu/cinevoraces_infra/nginx/default.conf

    # Backup the current configuration file
    current_date_time=$(date +"%Y_%m_%d-%H-%M-%S")
    mkdir -p $backup_folder
    sudo cp /etc/nginx/conf.d/default.conf "${backup_folder}/default.conf_${current_date_time}.bak"

    # Update the configuration file
    sudo cp $config_file /etc/nginx/conf.d/default.conf

    sudo systemctl restart nginx
    sudo systemctl status nginx.service

    echo "Nginx config updated"
}