#!/bin/bash

function set_app_variables {
    cinevo_path=/home/ubuntu/cinevoraces_infra/cinevoraces

    if [ ! -f $cinevo_path/app/.env.local ]; then
        touch $cinevo_path/app/.env.local
    fi

    nano $cinevo_path/app/.env.local
}

function set_api_variables {
    cinevo_path=/home/ubuntu/cinevoraces_infra/cinevoraces

    if [ ! -f $cinevo_path/api/.env ]; then
        touch $cinevo_path/api/.env
    fi

    nano $cinevo_path/api/.env
}

function set_postgres_variables {
    cinevo_path=/home/ubuntu/cinevoraces_infra/cinevoraces

    if [ ! -f $cinevo_path/data/.env ]; then
        touch $cinevo_path/data/.env
    fi

    nano $cinevo_path/data/.env
}
