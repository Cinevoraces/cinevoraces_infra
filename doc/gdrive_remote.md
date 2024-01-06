# Setup GDrive remote

This guide shows you how to configure a remote access to a Google drive account using [rclone](https://rclone.org/).

_Because backups should have backups..._

### Requirements

-   A local version of rclone installed on your host _(see https://rclone.org/downloads/)_
-   A client id from the targeted Google account https://rclone.org/drive/#making-your-own-client-id

### Install rclone

Open a remote connection to the server and execute the following command

```sh
sudo apt install rclone
```

Then execute the config

```sh
rclone config
```

Follow the instructions and choose _Google Drive_ when asked to. **Once the configuration is completed you will be prompted to connect to the Google Account to authenticate the server using _Auto config_, select "no".**

```
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine

y) Yes (default)
n) No
y/n> n
```

Use your local copy of rclone to proceed with authentication _(see https://rclone.org/remote_setup/)_.

### Mount the GDrive account on your server

Run the following command on the server to mount the GDrive account to the backup folder. **(This operation will erase the content of the folder!)**

```sh
rclone mount cinevoraces_gdrive: /home/ubuntu/cinevoraces_infra/backup/ --daemon
```
