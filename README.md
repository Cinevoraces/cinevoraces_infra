# Cinévoraces Infra

## Initiate server

Use the following command to setup the server

```bash
git clone git@github.com:Cinevoraces/cinevoraces_infra.git && \
find ./scripts -type f -name "*.sh" -exec chmod +x {} \; && \
./scripts/init_server.sh
```

## Documentation

-   [**DEV | Setup virtualized production VM**](./doc/virtualization.md)
-   [**DEBUG | Generate Password (./scripts/node/generate_psw.mjs)**](./scripts/node/generate_psw.mjs)

    ```sh
    node ./scripts/node/generate_psw.msj --psw=foo --salt=10
    ```
