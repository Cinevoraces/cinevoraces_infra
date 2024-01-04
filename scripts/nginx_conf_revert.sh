#!/bin/bash

function nginx_conf_revert {
    backup_folder=/home/ubuntu/cinevoraces_infra/nginx/bak

    # Get a list of backup files
    backup_files=$(ls $backup_folder)

    # Check if there are any backup files
    if [ -z "$backup_files" ]; then
        echo "No backup files found."
        return 1
    fi

    # Print the backup files and prompt the user to select one
    echo "Please select a backup file to restore:"
    select backup_file in $backup_files Cancel; do
        case $backup_file in
            Cancel )
                echo "Operation cancelled."
                return 0
                ;;
            * )
                if [ -n "$backup_file" ]; then
                    # Restore the selected backup file
                    sudo cp "$backup_folder/$backup_file" /etc/nginx/conf.d/default.conf
                    sudo systemctl restart nginx
                    sudo systemctl status nginx.service
                    
                    echo "Configuration restored and Nginx restarted."
                    return 0
                fi
                ;;
        esac
    done
}