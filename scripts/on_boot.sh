#!/bin/bash

/home/ubuntu/cinevoraces_infra/scripts/env_set.sh
/home/ubuntu/cinevoraces_infra/scripts/pg_access.sh
/home/ubuntu/cinevoraces_infra/scripts/nginx_conf_update.sh
/home/ubuntu/cinevoraces_infra/scripts/nginx_conf_revert.sh