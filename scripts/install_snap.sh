#!/bin/bash

# Install snapd
apt update
apt install snapd
snap install core

# Install Certbot using snap
snap install --classic certbot