# Cinévoraces Infra

## Setup

-   Generate your SSH Key

    ```bash
    ssh-keygen -t ed25519 -C "cinevoraces@gmail.com" -f ~/.ssh/id_ed25519 -N '' && \
    cat ~/.ssh/id_ed25519.pub
    ```

-   Clone the repositories

    ```bash
    git clone git@github.com:Cinevoraces/cinevoraces_infra.git && \
    git clone git@github.com:Cinevoraces/cinevoraces.git
    ```

-   Make all scripts executable at _clone/pull_

    ```bash
    find ./scripts -type f -name "*.sh" -exec chmod +x {} \;
    ```

### Documentation

#### Install dependencies

##### [DEPENDENCIES | Install Docker (./scripts/install_docker.sh)](./scripts/install_docker.sh)

#### Developpment

##### [DEV | Setup virtualized production VM](./doc/virtualization.md)

#### Debug

##### [DEBUG | Generate Password (./scripts/node/generate_psw.mjs)](./scripts/node/generate_psw.mjs)

> ```sh
> node ./scripts/node/generate_psw.msj --psw=foo --salt=10
> ```

#### Recommended tools

##### [TOOLS | Azure Data Studio](https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio?tabs=win-install%2Cwin-user-install%2Credhat-install%2Cwindows-uninstall%2Credhat-uninstall#download-azure-data-studio)
