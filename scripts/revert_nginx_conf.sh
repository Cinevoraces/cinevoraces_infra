#!/bin/bash

# Get a list of backup files
backup_files=$(ls ./nginx/bak)

# Check if there are any backup files
if [ -z "$backup_files" ]; then
    echo "No backup files found."
    exit 1
fi

# Print the backup files and prompt the user to select one
echo "Please select a backup file to restore:"
select backup_file in $backup_files Cancel; do
    case $backup_file in
        Cancel )
            echo "Operation cancelled."
            exit 0
            ;;
        * )
            if [ -n "$backup_file" ]; then
                # Restore the selected backup file
                cp "./nginx/bak/$backup_file" /etc/nginx/conf.d/default.conf
                sudo systemctl restart nginx
                echo "Configuration restored and Nginx restarted."
                exit 0
            fi
            ;;
    esac
done