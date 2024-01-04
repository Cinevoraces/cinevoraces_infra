#!/bin/bash

source ./cinevoraces/data/.env
today=`date +%Y-%m-%d.%H:%M:%S`

cd ./backups 
mkdir backup_$today \
docker exec postgres pg_dump -U ${POSTGRES_USER} -F c ${POSTGRES_DB} -v -Z 9  > backup_$today/database_backup_$today \
docker cp api:/api/public ./backup_$today/public \
tar -cvf ./backup_$today.tar ./backup_$today \
rm -rf ./backup_$today