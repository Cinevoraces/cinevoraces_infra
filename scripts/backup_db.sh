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
