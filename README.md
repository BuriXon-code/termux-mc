# Minecraft Server Launcher for Termux

---

## About

![screenshot](/screenshots/img1.jpg)  

This project is a **Minecraft Server Launcher for Termux**, created to simplify launching and managing a Java Edition server directly on Android.  
It supports configuration via CLI or external file, SSH tunneling to expose the server externally, datapack management, RAM allocation, and automated setup of required environment components.  
The launcher handles temporary or permanent saves, offers colorful terminal output, and supports Minecraft versions up to 1.20.4 (JDK 17) or 1.21.5+ (JDK 21).

---

## Installation

There are two ways to install and use the launcher:

**1. Automatic Installation**  
Use the included installer script (`install.sh`) to:
- Check and install required dependencies
- Download the correct Minecraft server version
- Create the server directory structure
- Move launcher and config files into place
- Create a symbolic link for quick access

To use simply run:

```
git clone https://BuriXon-code/termux-mc
cd termux-mc
chmod +x *.sh
./install.sh
```

**2. Manual Installation**  
You can also install manually by:
- Placing the launcher and configuration files in the appropriate directory
- Creating the required server and datapacks directories
- Ensuring the required dependencies are installed (see Compatibility)

Step by step guide:

```
# install all dependencies
pkg update
pkg install -y ncurses-utils openssh unzip wget sshpass jq openjdk-21
```

```
# create directories
mkdir -p $HOME/server_mc/server
mkdir -p $HOME/server_mc/datapacks
```

```
# download minecraft server (for jdk 17)
wget https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar -O "$HOME/server_mc/server/server.jar
```

```
# download minecraft server (for jdk 21)
wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar -O "$HOME/server_mc/server/server.jar
```

```
# move files
mv launcher.sh $HOME/server_mc/launcher.sh
mv template.conf $HOME/server_mc/template.conf
```

```
# make symlink
ln -s $HOME/server_mc/launcher.sh $PREFIX/bin/servermc # or any name you want
```

---

## Usage

![screenshot](/screenshots/img2.jpg)  

### Parameters

The launcher supports the following CLI arguments:

- `-config <path>` – Path to the configuration file
- `-server_port <port>` – Port for the Minecraft server (default: 25565)
- `-min_ram <amount>` – Minimum RAM allocation (default: 1G)
- `-max_ram <amount>` – Maximum RAM allocation (default: 2G)
- `-world <name>` – World name to load (default: "world")
- `-temp` – Creates a temporary world (auto-deleted after shutdown)
- `-datapacks` – Enables datapack copy into the selected world
- `-tunnel` – Enables SSH tunneling
- `-tunnel_host <host>` – SSH tunnel destination
- `-tunnel_login_port <port>` – SSH port of the remote host
- `-tunnel_login_user <user>` – SSH login username
- `-tunnel_passwd <password>` – SSH login password (optional, prompts if empty)
- `-tunnel_forward_port <port>` – Remote port to be forwarded

### Configuration

You can also define parameters in a config file. All options are optional:

- `CONFIG_SERVER_ENABLE_TUNNEL` – Enable SSH tunnel (`true`/`false`)
- `CONFIG_TUNNEL_HOST` – Remote SSH host
- `CONFIG_TUNNEL_LOGIN_PORT` – SSH port
- `CONFIG_TUNNEL_LOGIN_USER` – SSH username
- `CONFIG_TUNNEL_PASSWD` – SSH password
- `CONFIG_TUNNEL_FORWARD_PORT` – Remote port to be forwarded

- `CONFIG_SERVER_SAVE` – World name
- `CONFIG_SERVER_TEMP` – Launch as temporary (`true`/`false`)
- `CONFIG_SERVER_MIN_RAM` – Minimum RAM (e.g. 1G)
- `CONFIG_SERVER_MAX_RAM` – Maximum RAM
- `CONFIG_SERVER_PORT` – Server port
- `CONFIG_SERVER_DATAPACKS` – Enable datapack import (`true`/`false`)

CLI arguments override config file values if both are provided.

### Examples

1. **Default server launch**  
   Runs the server with default settings, loading the default world on port 25565 with 1G–2G RAM.

```
launcher.sh
```

2. **Launch with custom world and datapacks**  
   Loads a specific world name and injects datapacks from a shared directory.

```
launcher.sh -world example.world -datapacks
```

3. **Launch with SSH tunnel**  
   Opens a reverse SSH tunnel to expose the server via a remote VPS.

```
launcher.sh -tunnel -tunnel_host your-hostname -tunnel_login_port 22 -tunnel_forward_port 25565 -tunnel_login_user example-user -tunnel_passwd PASSWD1234example
```

4. **Start temporary world for testing**  
   Creates a fresh world instance that is deleted when the server stops.

```
launcher.sh -temp
```

---

## Compatibility

This project is designed for **Termux on Android** and supports:

- **Minecraft Java Edition** (official `server.jar`)
- JDK **17** – compatible with Minecraft up to version 1.20.4  
- JDK **21** – supports newer Minecraft versions (e.g. 1.21.5+)

### Required components

The following packages/tools are needed:

- **openjdk-17 / openjdk-21** – Required Java runtime
- **wget** – For downloading the official `server.jar`
- **unzip** – To extract and verify Minecraft version
- **jq** – Used to parse Minecraft metadata from `version.json`
- **ssh** – Enables tunneling functionality (optional)
- **sshpass** – For SSH password authentication (optional)
- **tput** – For visual terminal formatting

The installer script automatically installs all missing components.

---

## Support

### Contact me:
For any issues, suggestions, or questions, reach out via:

- **Email:** support@burixon.com.pl
- **Contact form:** [Click here](https://burixon.com.pl/contact.php)

### Support me:
If you find this script useful, consider supporting my work by making a donation:

[**DONATE HERE**](https://burixon.com.pl/donate/)
