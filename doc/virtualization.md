# Setup virtualized production VM

This guide shows you how to configure a **_"cinevoraces.fr"_** production environment in a VM. This will allow you to test your application/infrastructure in a safe and controlled environment.

_Because testing in production is wrong... Don't do that._

#### Current configuration

```
OVH VPS - Monocore
Ubuntu 23 Server (Lunar Lobster)
2Go RAM
40Go SSD NVMe
```

#### Sources

-   [Download Ubuntu Lunar Lobster (server)](https://releases.ubuntu.com/lunar/ubuntu-23.04-live-server-amd64.iso)
-   [Download VM tool - VirtualBox](https://www.virtualbox.org/)
-   [Download VM tool - UTM _(Mac only)_](https://mac.getutm.app/)

#### Requirements (VM)

-   git
-   ssh

#### Set SSH port (VirtualBox 7.0)

-   Open your VM Settings and select the **"Network"** menu.
-   Select an adapter and set it to **"NAT"**
-   Click on **"Advanced"** then **"Port Forwarding"**
-   Add a new rule where:
    -   **Name** => Whatever name you want
    -   **Protocol** => **"TCP"** _(as it's what ssh uses)_
    -   **Host IP** => Best to leave blank
        -   _(use `ip a` in your VM to get it if you want to set it manually)_
    -   **Host Port** => Whatever port you wish to use
    -   **Guest IP** => Best to leave blank
        -   _(use `ip a` in your VM to get it if you want to set it manually)_
    -   **Guest Port** => VM SSH port _(default to 22)_

#### Connect from your host

```bash
ssh -p <my_ssh_port> <username>@<my_vm_ip_address>
```

That should look like something like that

```bash
ssh -p 8090 ubuntu@127.0.0.1
```
