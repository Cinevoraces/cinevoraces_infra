# Cinévoraces Infra

## Initiate server

Use the following command to setup the server

```bash
git clone https://github.com/Cinevoraces/cinevoraces_infra.git && \
cd cinevoraces_infra && \
git checkout -b safaridigital_test && \
find ./scripts -type f -name "*.sh" -exec chmod +x {} \; && \
./scripts/init_server.sh
```

## Documentation

-   [**Setup virtualized production VM**](./doc/virtualization.md)
-   [**Setup GDrive remote**](./doc/gdrive_remote.md)

## Server commands

-   **Download/Send backup using ssh**

    ```bash
    scp -P <ssh_port> <username>@<ip_address>:/home/ubuntu/cinevoraces_infra/backup/<backup_name>.tar \<destination_file>.tar
    ```

    ```bash
    scp -P <ssh_port> local/file.tar <username>@<ip_address>:/home/ubuntu/cinevoraces_infra/backup/
    ```

-   **Update Nginx config**

    ```sh
    # Revert config with available backups
    nginx_conf_revert
    # Update config using default.conf
    nginx_conf_update
    ```

-   **Update Postgress access**

    ```sh
    # Enable one or many IP for remote access
    pg_enable_access
    # Disable one or many IP for remote access
    pg_disable_access
    ```

-   **Set project variables**

    ```sh
    # Open env file using nano, create file if not existing
    set_app_variables
    set_api_variables
    set_postgres_variables
    ```

-   [**Generate Password (./scripts/node/generate_psw.mjs)**](./scripts/node/generate_psw.mjs)

    ```sh
    node ./scripts/node/generate_psw.msj --psw=foo --salt=10
    ```
