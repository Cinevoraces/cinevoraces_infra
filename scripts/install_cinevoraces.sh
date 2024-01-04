#!/bin/bash

# Download cinevoraces from public source
git clone https://github.com/Cinevoraces/cinevoraces.git

# Set .env files
if [ ! -f ./cinevoraces/app/.env.local ]; then
    echo "Set App .env.local file (Frontend)"
    echo "Press any key to continue..."
    read -n 1 -s -r
    touch ./cinevoraces/app/.env.local
    nano ./cinevoraces/app/.env.local
else
    echo ".env.local already exists."
fi

if [ ! -f ./cinevoraces/api/.env ]; then
    echo "Set Api .env file (Backend)"
    echo "Press any key to continue..."
    read -n 1 -s -r
    touch ./cinevoraces/api/.env
    nano ./cinevoraces/api/.env
else
    echo ".env already exists."
fi

if [ ! -f ./cinevoraces/data/.env ]; then
    echo "Set Postgres .env file (Backend)"
    echo "Press any key to continue..."
    read -n 1 -s -r
    touch ./cinevoraces/data/.env
    nano ./cinevoraces/data/.env
else
    echo ".env already exists."
fi

# Build and run docker images
sudo docker compose build
sudo docker compose up -d