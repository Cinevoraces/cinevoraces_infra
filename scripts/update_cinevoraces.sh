function update_cinevoraces {
    path_to_infra=/home/ubuntu/cinevoraces_infra
    cd $path_to_infra/cinevoraces
    git pull

    cd $path_to_infra

    sudo docker compose down
    sudo docker compose build --no-cache
    sudo docker compose up -d
}