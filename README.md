# Cinévoraces Infra

## Initiate server

Use the following command to setup the server

```bash
git clone https://github.com/Cinevoraces/cinevoraces_infra.git && \
cd cinevoraces_infra && \
git checkout infra_ubuntu23 && \
find ./scripts -type f -name "*.sh" -exec chmod +x {} \; && \
./scripts/init_server.sh
```

## Documentation

### DEV

-   [**DEV | Setup virtualized production VM**](./doc/virtualization.md)

### DEBUG

-   **DEBUG | Update Nginx config**

    ```sh
    # Revert config with available backups
    nginx_conf_revert
    # Update config using default.conf
    nginx_conf_update
    ```

-   **DEBUG | Update Postgress access**

    ```sh
    # Enable one or many IP for remote access
    pg_enable_access
    # Disable one or many IP for remote access
    pg_disable_access
    ```

-   **DEBUG | Set project variables**

    ```sh
    # Open env file using nano, create file if not existing
    set_app_variables
    set_api_variables
    set_postgres_variables
    ```

-   [**DEBUG | Generate Password (./scripts/node/generate_psw.mjs)**](./scripts/node/generate_psw.mjs)

    ```sh
    node ./scripts/node/generate_psw.msj --psw=foo --salt=10
    ```
