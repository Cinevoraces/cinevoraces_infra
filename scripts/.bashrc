# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History control
HISTCONTROL=ignoreboth
HISTSIZE=1000 
HISTFILESIZE=2000
shopt -s histappend

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# PS1 -> user@host
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Aliases
alias ls='ls --color=auto -la'

# Variables
cinevo_path=/home/ubuntu/cinevoraces_infra/cinevoraces
path_to_infra=/home/ubuntu/cinevoraces_infra
path_to_backup_folder="${path_to_infra}/backup"

######################################
## Server functions
######################################

function backup_db() {
    today=`date +%Y-%m-%d.%H:%M:%S`
    path_to_backup="${path_to_backup_folder}/backup_${today}"
    source "${path_to_infra}/cinevoraces/data/.env"

    # Create backup
    mkdir $path_to_backup
    sudo docker exec postgres pg_dump -U ${POSTGRES_USER} -F c ${POSTGRES_DB} -v -Z 9  > "${path_to_backup}/database_backup_${today}"
    sudo docker cp api:/api/public "${path_to_backup}/public" 
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

function restore_db() {
    source "${path_to_infra}/cinevoraces/data/.env"

    # Get a list of backup files
    backup_files=$(ls $path_to_backup_folder)

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
                    tar -xvf "${path_to_backup_folder}/${backup_file}" -C $path_to_backup_folder
                    
                    # Stop main containers during file replacement
                    sudo docker stop api
                    sudo docker stop app

                    # Update docker volumes
                    sudo docker exec api rm -rf public
                    sudo docker cp "${path_to_backup_folder}/${backup_file%.*}/public" api:/api
                    sudo docker cp "${path_to_backup_folder}/${backup_file%.*}/database_${backup_file%.*}" postgres:/database_${backup_file%.*}
                    sudo docker exec postgres pg_restore -c --no-owner -v -U ${POSTGRES_USER} -d ${POSTGRES_DB} "/database_${backup_file%.*}"
                    sudo docker exec postgres rm -rf /database_${backup_file%.*}
                    sudo docker start api
                    sudo docker start app

                    # Cleanup folder
                    rm -rf "${path_to_backup_folder}/${backup_file%.*}"

                    echo "Database restored."
                    return 0
                fi
                ;;
        esac
    done
}

function set_app_variables() {
    if [ ! -f $cinevo_path/app/.env.local ]; then
        touch $cinevo_path/app/.env.local
    fi
    nano $cinevo_path/app/.env.local
}

function set_api_variables() {
    if [ ! -f $cinevo_path/api/.env ]; then
        touch $cinevo_path/api/.env
    fi
    nano $cinevo_path/api/.env
}

function set_postgres_variables() {
    if [ ! -f $cinevo_path/data/.env ]; then
        touch $cinevo_path/data/.env
    fi
    nano $cinevo_path/data/.env
}

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

function pg_enable_access {
    echo "Enter IP addresses to allow Postgres access (separated by spaces):"
    read -a IPS
    for IP in "${IPS[@]}"
    do
        sudo ufw route allow proto tcp from $IP to any port 5432
    done
    sudo ufw status
}

function pg_disable_access {
    sudo ufw status
    echo "Enter IP addresses to deny Postgres access (separated by spaces):"
    read -a IPS
    for IP in "${IPS[@]}"
    do
        sudo ufw route deny proto tcp from $IP to any port 5432
    done
    sudo ufw status
}

function update_cinevoraces {
    cd $cinevo_path
    git pull
    cd $path_to_infra

    sudo docker compose down
    sudo docker compose build --no-cache
    sudo docker compose up -d
}
