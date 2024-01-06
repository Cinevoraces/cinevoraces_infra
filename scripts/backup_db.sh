#!/bin/bash

function backup_db {
    today=`date +%Y-%m-%d.%H:%M:%S`
    path_to_infra=/home/ubuntu/cinevoraces_infra
    path_to_backup="${path_to_infra}/backup/backup_${today}"
    source "${path_to_infra}/cinevoraces/data/.env"

    # Create backup
    mkdir $path_to_backup
    docker exec postgres pg_dump -U ${POSTGRES_USER} -F c ${POSTGRES_DB} -v -Z 9  > "${path_to_backup}/database_backup_${today}"
    docker cp api:/api/public "${path_to_backup}/public" 
    tar -cvf "${path_to_backup}.tar" $path_to_backup
    rm -rf $path_to_backup
    echo "Backup completed => "${path_to_backup}.tar""

    # Delete oldest backup if more than 10 backups saved
    backup_count=$(ls | wc -l)
    if [ $backup_count -lt 11 ]
        then
            echo 'Less than 10 backups saved, keeping previous backups.'
        else
            echo '10 backups already saved, deleting oldest'
            rm "$(ls -t | tail -1)"
    fi
}

function restore_db {
    path_to_infra=/home/ubuntu/cinevoraces_infra
    backup_folder="${path_to_infra}/backup"
    source "${path_to_infra}/cinevoraces/data/.env"

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
                    tar -xvf "${backup_folder}/${backup_file}" -C $backup_folder
                    
                    # Stop main containers during file replacement
                    sudo docker stop api
                    sudo docker stop app

                    # Update docker volumes
                    sudo docker exec api rm -rf public
                    sudo docker cp "${backup_folder}/${backup_file%.*}/public" api:/api/public
                    sudo docker exec postgres pg_restore -c --no-owner -v -U ${POSTGRES_USER} -d ${POSTGRES_DB} "${backup_folder}/${backup_file%.*}/database_${backup_file%.*}"
                    sudo docker start api
                    sudo docker start app

                    # Cleanup folder
                    rm -rf "${backup_folder}/${backup_file%.*}"

                    echo "Database restored."
                    return 0
                fi
                ;;
        esac
    done
}