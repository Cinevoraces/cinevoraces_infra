#!/bin/bash

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