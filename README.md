# Cinévoraces Infra

## Initiate server

Use the following command to setup the server

```bash
git clone https://github.com/Cinevoraces/cinevoraces_infra.git && \
cd cinevoraces_infra && \
git checkout infra_ubuntu23
find ./scripts -type f -name "*.sh" -exec chmod +x {} \; && \
./scripts/init_server.sh
```

## Documentation

### DEV

-   [**DEV | Setup virtualized production VM**](./doc/virtualization.md)

### DEBUG

-   [**DEBUG | Update Nginx config (./scripts/update_nginx_conf.sh)**](./scripts/update_nginx_conf.sh)

    ```sh
    ./scripts/update_nginx_conf.sh
    ```

-   [**DEBUG | Revert Nginx config (./scripts/revert_nginx_conf.sh)**](./scripts/revert_nginx_conf.sh)

    ```sh
    ./scripts/revert_nginx_conf.sh
    ```

-   [**DEBUG | Generate Password (./scripts/node/generate_psw.mjs)**](./scripts/node/generate_psw.mjs)

    ```sh
    node ./scripts/node/generate_psw.msj --psw=foo --salt=10
    ```
