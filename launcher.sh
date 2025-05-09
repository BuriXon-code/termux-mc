#!/data/data/com.termux/files/usr/bin/bash

banner() {
        local word=$*
        local lenght=29
        local cols
        cols=$(tput cols)
        if (( cols >= 60 )); then
                local width=60
        else
                local width=$cols
        fi
        echo -en "\e[38;5;250m"
        printf '#%.0s' $(seq 1 $((width)))
        echo
        printf '=%.0s' $(seq 1 $((width)))
        echo
        printf '#%.0s' $(seq 1 $((width)))
        echo
        echo -en "\e[2A\r\e[$((width/2 - lenght/2 - 2))C $word \e[1B"
        echo
}
echo -e "\e[?7l\e[38;5;70m"
echo -e "⠀⠀⡰⠉⠉⣷⡄⣀⣎⠉⢹⡎⠉⢉⡞⠉⠉⣧⡎⠉⠉⡞⠉⠉⠉⠉⠉⣿⠉⠉⠉⠉⠉⢹⡏⠋⠉⠉⠉⠙⡏⠉⣉⠉⣉⠉⢿⠉⠉⠉⢉⠉⢱⡏⠉⠉⠉⢉⠉⡄"
echo -e "⠀⢀⠃⠀⠀⠘⠛⠁⠀⠀⣼⠀⠀⣸⠃⠀⠀⠘⠃⠀⢰⡇⠀⠀⠛⠛⠛⣿⠀⠀⢸⣿⣿⣿⡇⠀⠈⠃⠀⣠⣿⠀⠉⣶⣍⠀⢸⡆⠀⠘⠛⠛⠛⣿⣿⡆⠀⠈⡟⠁"
echo -e "⠀⡜ ⢀⣶⣀⣰⠆⠀⢀⡏⠀⠀⣿⠀⠀⣸⣄⠤⠄⢸⠃⠀⢰⣶⣶⣶⣿⠀⠀⢸⣉⣉⣉⡇⡀⠀⣶⠀⠀⢹⠀⠀⢀⡀⢀⠀⣇⠀⠀⢶⣶⣶⢾⣿⣿⡀⠀⢱⠀"
echo -e "⢰⠀⠀⢸⣿⣦⠈⠀⠀⢼⠁⠀⢰⡇⠀⠀⣿⣿⠀⠀⢼⠀⡄⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⡇⠂⠀⣿⠀⠀⢸⡆⠀⢘⡧⠀⠀⣿⠀⠀⢸⠛⠃⠘⣿⣿⡇⠀⠀⡆"
echo -e "⠀⠑⢤⣀⣙⡿⠉⠱⣄⣠⣷⣄⣀⣹⣄⣀⣘⡏⢆⣀⣘⣧⣀⣀⣀⣀⣀⣿⣀⣀⣀⣀⣀⣸⣇⣀⣰⣏⣀⣠⣿⣀⣀⣾⣁⣀⣴⣋⣀⡠⠃⠀⠀⠀⢿⣋⣀⡤⠋⠀"
banner "\e[0mLauncher made by \e[38;5;123mBuriXon-code\e[38;5;250m"
echo -en "\e[?7h"

# DEFAULTS [ \e[1;32m✓\e[0m ] [ \e[1;31m✕\e[0m ] [ \e[1;33m>\e[0m ]
CONFIG_FILE=""
SERVER_DIR="$HOME/server_mc"
PID_FILE="$SERVER_DIR/ssh-$(date +%s).pid"
SERVER_JAR="$SERVER_DIR/server/server.jar"
START_TUNNEL=false
SERVER_DATAPACKS=false
TEMP=false
TUNNEL_HOST=""
TUNNEL_LOGIN_PORT=""
TUNNEL_LOGIN_USER=""
TUNNEL_PASSWD=""
TUNNEL_FORWARD_PORT=""
SERVER_MIN_RAM="1G"
SERVER_MAX_RAM="2G"
SERVER_PORT="25565"
SERVER_SAVE="world"
NEW_SAVE=false
PREV_DIR=$(pwd)

# CHECK ENVIROMENT
check_java_version() {
    if ! command -v java &>/dev/null; then
    	echo -e "\n\e[38;5;70mDependencies error:\e[0m" >&2
        echo -e "  [ \e[1;31m✕\e[0m ] Java is not installed. Please install JDK package.\e[0m\n" >&2
        exit 1
    fi  
    java_version=$(java --version 2>/dev/null | head -n 1)
    if [[ "$java_version" =~ openjdk\ 17\.* || "$java_version" =~ openjdk\ 21\.* ]]; then
        return 0
    else
    	echo -e "\n\e[38;5;70mDependencies error:\e[0m" >&2
        echo -e "  [ \e[1;31m✕\e[0m ] Invalid Java version. Required JDK 17 or 21.\e[0m\n" >&2
        exit 1
    fi
}
check_java_version

# HELP INFO
help() {
	echo -e "\n\e[38;5;70mUsage:\e[0m"
	echo -e "  $(basename "$0") [options]"
	echo
	echo -e "\e[38;5;70mOptions:\e[0m"
	echo -e "  \e[38;5;123m-config <path>\e[0m\t\tPath to config file"
	echo -e "  \e[38;5;123m-server_port <port>\e[0m\t\tPort for Minecraft server (default: 25565)"
	echo -e "  \e[38;5;123m-min_ram <amount>\e[0m\t\tMinimum RAM for server (default: 1G)"
	echo -e "  \e[38;5;123m-max_ram <amount>\e[0m\t\tMaximum RAM for server (default: 2G)"
	echo -e "  \e[38;5;123m-world <name>\e[0m\t\t\tSpecify world name (default: world)"
	echo -e "  \e[38;5;123m-temp\e[0m\t\t\t\tGenerate new non-persistant world"
	echo -e "  \e[38;5;123m-datapacks\e[0m\t\t\tClone all datapacks to selected save"
	echo -e "  \e[38;5;123m-tunnel \e[0m\t\t\tEnable SSH tunnel"
	echo -e "  \e[38;5;123m-tunnel_host <host>\e[0m\t\tRemote SSH tunnel host"
	echo -e "  \e[38;5;123m-tunnel_login_port <port>\e[0m\tSSH login port on tunnel host"
	echo -e "  \e[38;5;123m-tunnel_login_user <user>\e[0m\tSSH login username"
	echo -e "  \e[38;5;123m-tunnel_passwd <password>\e[0m\tSSH login password"
	echo -e "  \e[38;5;123m-tunnel_forward_port <port>\e[0m\tRemote port to forward"
	echo
	echo -e "\e[38;5;70mDescription:\e[0m"
	echo -e "  Launches a Minecraft server with optional SSH tunnel."
	echo -e "  Values can be provided via config file and/or command-line arguments."
	echo -e "  Command-line arguments override config file values."
	echo -e "\n  All data and files must be located in $SERVER_DIR directory."
	echo
	exit "$1"
}

# READ CLI OARAMETERS
while [[ $# -gt 0 ]]; do
	case $1 in
		-tunnel_host) TUNNEL_HOST="$2"; START_TUNNEL=true; shift 2 ;;
		-tunnel_login_port) TUNNEL_LOGIN_PORT="$2"; START_TUNNEL=true; shift 2 ;;
		-tunnel_login_user) TUNNEL_LOGIN_USER="$2"; START_TUNNEL=true; shift 2 ;;
		-tunnel_passwd) TUNNEL_PASSWD="$2"; START_TUNNEL=true; shift 2 ;;
		-tunnel_forward_port) TUNNEL_FORWARD_PORT="$2"; START_TUNNEL=true; shift 2 ;;
		-min_ram) SERVER_MIN_RAM="$2"; shift 2 ;;
		-max_ram) SERVER_MAX_RAM="$2"; shift 2 ;;
		-server_port) SERVER_PORT="$2"; shift 2 ;;
		-config) CONFIG_FILE="$2"; shift 2 ;;
		-tunnel) START_TUNNEL=true ;;
		-world) SERVER_SAVE="$2"; shift 2 ;;
		-datapacks) SERVER_DATAPACKS=true; shift ;;
		-temp) TEMP=true; TEMP_SAVE="world.tmp_$(date +%s)" ;;
		-help) help 0 ;;
		*) echo -e "\n  [ \e[1;31m✕\e[0m ] Unknown argument: $1\e[0m" >&2; help 1 ;;
	esac
	shift
done

# SOURCE SELECTED CONFIG
if [[ -n "$CONFIG_FILE" ]]; then
	if [[ -f "$CONFIG_FILE" ]]; then
		# DISABLE SHELLCHECK INFO
		# shellcheck source=/dev/null
		source "$CONFIG_FILE"
	else
		echo -e "\n  [ \e[1;31m✕\e[0m ] Config file not found: $CONFIG_FILE\e[0m\n" >&2
		exit 1
	fi
fi

# VALIDATE CONFIG/PARAMETERS/DEFAULTS
[[ -z "$TUNNEL_HOST" ]] && TUNNEL_HOST="$CONFIG_TUNNEL_HOST"
[[ -z "$TUNNEL_LOGIN_PORT" ]] && TUNNEL_LOGIN_PORT="$CONFIG_TUNNEL_LOGIN_PORT"
[[ -z "$TUNNEL_LOGIN_USER" ]] && TUNNEL_LOGIN_USER="$CONFIG_TUNNEL_LOGIN_USER"
[[ -z "$TUNNEL_PASSWD" ]] && TUNNEL_PASSWD="$CONFIG_TUNNEL_PASSWD"
[[ -z "$TUNNEL_FORWARD_PORT" ]] && TUNNEL_FORWARD_PORT="$CONFIG_TUNNEL_FORWARD_PORT"
[[ "$SERVER_SAVE" == "world" ]] && SERVER_SAVE="${CONFIG_SERVER_SAVE:-world}"
[ -d "$HOME/.server_mc/server/$SERVER_SAVE" ] || NEW_SAVE=true
[[ "$CONFIG_SERVER_TEMP" == "true" ]] && { TEMP=true; TEMP_SAVE="world.tmp_$(date +%s)"; }
$TEMP && SERVER_SAVE="temporary"
[[ "$SERVER_MIN_RAM" == "1G" ]] && SERVER_MIN_RAM="${CONFIG_SERVER_MIN_RAM:-1G}"
[[ "$SERVER_MAX_RAM" == "2G" ]] && SERVER_MAX_RAM="${CONFIG_SERVER_MAX_RAM:-2G}"
[[ "$SERVER_PORT" == "25565" ]] && SERVER_PORT="${CONFIG_SERVER_PORT:-25565}"
[[ "$CONFIG_SERVER_ENABLE_TUNNEL" == "true" ]] && START_TUNNEL=true
[[ "$SERVER_DATAPACKS" == "false" ]] && SERVER_DATAPACKS="$CONFIG_SERVER_DATAPACKS"
[[ "$SERVER_PORT" =~ ^[0-9]+$ && "$SERVER_PORT" -gt 1024 ]] || { echo -e "\n  [ \e[1;31m✕\e[0m ] Invalid server port: $SERVER_PORT.\e[0m\n" >&2; exit 1; }
[[ "$SERVER_PORT" -eq "25575" ]] && { echo -e "\n  [ \e[1;31m✕\e[0m ] Port $SERVER_PORT cannot be used.\e[0m\n" >&2; exit 1; }
FREE_RAM=$(free -g | awk '/^Mem:/ {print $7}')
[[ "${SERVER_MAX_RAM%G}" -le "$FREE_RAM" ]] || { echo -e "\n  [ \e[1;31m✕\e[0m ] Not enough RAM.\e[0m\n" >&2; exit 1; }

# EXIT/ABORTION CLEANUP
cleanup() {
	echo -e "\n[ \e[1;33m>\e[0m ] Cleaning up...\e[0m"
	kill "$(cat "$PID_FILE" 2>/dev/null)" &>/dev/null
	echo -e "  [ \e[1;32m✓\e[0m ] Killing processes...\e[0m"
	rm -f "$PID_FILE"
	if $TEMP && [ -d "$SERVER_DIR/server/$TEMP_SAVE" ] && [ -n "$TEMP_SAVE" ]; then
		echo -e "  [ \e[1;32m✓\e[0m ] Removing temporary save...\e[0m"
		rm -rf "$SERVER_DIR/server/$TEMP_SAVE" || echo -e "  [ \e[1;31m✕\e[0m ] Failed to remove temp save...\e[0m" >&2
	fi
	echo -e "[ \e[1;32m✓\e[0m ] Done.\n\e[0m"
	cd "$PREV_DIR" || exit 1
	exit "$1"
}
abort() {
	cleanup 0
}
trap abort SIGINT

# DISPLAY INFO
echo -e "\n\e[38;5;70mCurrent settings:\e[0m"
echo -e "  [ \e[1;33m>\e[0m ] JDK version\t\e[0m= \e[38;5;123m$java_version\e[0m"
echo -e "  [ \e[1;33m>\e[0m ] Tunnel SSH\t\e[0m= \e[38;5;123m$START_TUNNEL\e[0m"
if [[ "$START_TUNNEL" == true ]]; then
	echo -e "  [ \e[1;33m>\e[0m ] SSH host\t\e[0m= \e[38;5;123m$TUNNEL_HOST\e[0m"
	echo -e "  [ \e[1;33m>\e[0m ] SSH user\t\e[0m= \e[38;5;123m$TUNNEL_LOGIN_USER\e[0m"
	echo -e "  [ \e[1;33m>\e[0m ] SSH port\t\e[0m= \e[38;5;123m$TUNNEL_LOGIN_PORT\e[0m"
	echo -e "  [ \e[1;33m>\e[0m ] Remote port\t\e[0m= \e[38;5;123m$TUNNEL_FORWARD_PORT\e[0m"
fi
echo -e "  [ \e[1;33m>\e[0m ] Min. RAM\t\e[0m= \e[38;5;123m$SERVER_MIN_RAM\e[0m"
echo -e "  [ \e[1;33m>\e[0m ] Max. RAM\t\e[0m= \e[38;5;123m$SERVER_MAX_RAM\e[0m"
echo -e "  [ \e[1;33m>\e[0m ] Port\t\t\e[0m= \e[38;5;123m$SERVER_PORT\e[0m"
echo -e "  [ \e[1;33m>\e[0m ] World\t\t\e[0m= \e[38;5;123m$SERVER_SAVE\e[0m"
echo -e "\n\e[38;5;70mWaiting 3 seconds...\nPress Ctrl+C to cancel.\e[0m\n"
sleep 3

# CONFIGURE SSH TUNNEL, IF ENABLED
if [[ "$START_TUNNEL" == true ]]; then
	echo -e "\n\e[38;5;70mSetting up SSH tunnel:\e[0m"
	# VALIDATE OPTIONS
	[[ "$TUNNEL_FORWARD_PORT" =~ ^[0-9]+$ ]] || { echo -e "  [ \e[1;31m✕\e[0m ] Invalid tunnel port: $TUNNEL_FORWARD_PORT\e[0m\n" >&2; exit 1; }
	[[ -z "$TUNNEL_HOST" ]] && { echo -e "  [ \e[1;31m✕\e[0m ] Missing ssh host.\e[0m\n" >&2; exit 1; }
	[[ -z "$TUNNEL_LOGIN_USER" ]] && { echo -e "  [ \e[1;31m✕\e[0m ] Missing ssh user.\e[0m\n" >&2; exit 1; }
	[[ -z "$TUNNEL_LOGIN_PORT" ]] && { echo -e "  [ \e[1;31m✕\e[0m ] Missing ssh port.\e[0m\n" >&2; exit 1; }
	# ASK USER PASSWORD
	if [[ -z "$TUNNEL_PASSWD" ]]; then
		echo -en "  [ \e[38;5;200m>\e[0m ] Enter password: \e[0m"
	    while IFS= read -r -s -n1 char; do
	        if [[ $char == $'\0' ]]; then
	            break
	        elif [[ $char == $'\177' ]]; then
	            if [[ -n "$TUNNEL_PASSWD" ]]; then
	                TUNNEL_PASSWD="${TUNNEL_PASSWD%?}"
	                echo -ne "\b \b"
	            fi
	        else
	            TUNNEL_PASSWD+="$char"
	            echo -ne "\e[38;5;200m•\e[0m"
	        fi
	    done
	    echo
    fi
	# START TUNNEL
    if ! command -v sshpass &>/dev/null; then
        echo -e "  [ \e[1;31m✕\e[0m ] Command sshpass is not installed.\e[0m\n" >&2
        cleanup 1
    fi
    if ! command -v ssh &>/dev/null; then
        echo -e "  [ \e[1;31m✕\e[0m ] SSH is not installed.\e[0m\n" >&2
        cleanup 1
    fi
	if sshpass -p "$TUNNEL_PASSWD" ssh -f -N -R "$TUNNEL_FORWARD_PORT":localhost:"$SERVER_PORT" \
		-p "$TUNNEL_LOGIN_PORT" "$TUNNEL_LOGIN_USER@$TUNNEL_HOST" &>/dev/null; then
		pgrep -f "ssh -f -N -R $TUNNEL_FORWARD_PORT:localhost:$SERVER_PORT" > "$PID_FILE"
		echo -e "  [ \e[1;32m✓\e[0m ] SSH connected.\e[0m"
	else
		pgrep -f "ssh -f -N -R $TUNNEL_FORWARD_PORT:localhost:$SERVER_PORT" > "$PID_FILE"
		echo -e "  [ \e[1;31m✕\e[0m ] Connection failed.\e[0m" >&2
		cleanup 1
	fi
	# CHECK IF TUNNEL WORKS
	sleep 1.5
	if timeout 5 bash -c "</dev/tcp/$TUNNEL_HOST/$TUNNEL_FORWARD_PORT" &>/dev/null; then
		echo -e "  [ \e[1;32m✓\e[0m ] Tunnel established.\e[0m"
	else
		echo -e "  [ \e[1;31m✕\e[0m ] Tunneling failed.\e[0m"
		cleanup 1
	fi

	sleep 1
fi

# START SERVER
echo -e "\e[38;5;70mPreparing server:\e[0m"
echo -e "  [ \e[1;33m>\e[0m ] Changing directory to $SERVER_DIR/server/\e[0m"
cd "$SERVER_DIR/server/" || cleanup 1
echo -e "  [ \e[1;33m>\e[0m ] Starting server on port $SERVER_PORT.\e[0m"
if $START_TUNNEL; then
	echo -e "  [ \e[1;33m>\e[0m ] Forwarded to $TUNNEL_HOST:$TUNNEL_FORWARD_PORT.\e[0m"
fi
# INFO - NEW SAVE
if $NEW_SAVE && ! $TEMP; then
	echo -e "  [ \e[1;33m>\e[0m ] Creating new world \"$SERVER_SAVE\".\e[0m"
fi
# INFO - TEMPORARY WORLD
if $TEMP; then
	echo -e "  [ \e[1;33m>\e[0m ] Selected temporary world.\e[0m"
	echo -e "  \e[38;5;123mGame save will be removed after exit.\e[0m"
	SERVER_SAVE="$TEMP_SAVE"
fi
# CLONE DATAPACKS IF ENABLED
if $SERVER_DATAPACKS; then
	mkdir -p "$SERVER_DIR/datapacks"
	echo -e "  [ \e[1;33m>\e[0m ] Preparing datapacks...\e[0m"
	DATAPACKS_DIR="$SERVER_DIR/server/$SERVER_SAVE/datapacks/"
	if [ -d "$DATAPACKS_DIR" ]; then
		rm -rf "$DATAPACKS_DIR"
		mkdir -p "$DATAPACKS_DIR"
	else
		mkdir -p "$DATAPACKS_DIR"
	fi
	mkdir -p "$SERVER_DIR/datapacks/"
	cp -r "$SERVER_DIR/datapacks/"* "$DATAPACKS_DIR"/
fi
# CHECK IF SERVER JAR EXISTS
if [ ! -f "$SERVER_DIR/server/server.jar" ]; then
	echo -e "  [ \e[1;31m✕\e[0m ] Server launcher not found.\e[0m" >&2
	cleanup 1
fi
# CHECK VERSION
check_version() {
    if ! command -v unzip &>/dev/null; then
        echo -e "  [ \e[1;31m✕\e[0m ] Command unzip is not installed.\e[0m" >&2
        cleanup 1
    fi
    if ! command -v jq &>/dev/null; then
        echo -e "  [ \e[1;31m✕\e[0m ] Command jq is not installed.\e[0m" >&2
        cleanup 1
    fi
    java_version=$(java --version 2>/dev/null | head -n 1)
    if [[ "$java_version" =~ openjdk\ 17\.* ]]; then
		local MAX_VERSION="1.20.4"
	elif [[ "$java_version" =~ openjdk\ 21\.* ]]; then
		local MAX_VERSION="1.25.0" # Big number to prevent script fail with next versions
	fi
	local MC_VERSION
	MC_VERSION="$(unzip -p "$SERVER_DIR/server/server.jar" version.json | jq -r .name 2>/dev/null)"
	[ -z "$MC_VERSION" ] && return 1
	if [ "$(printf '%s\n' "$MC_VERSION" "$MAX_VERSION" | sort -V | head -n1)" = "$MC_VERSION" ]; then
		return 0
	else
		return 1
	fi
}
if ! check_version; then
	echo -e "  [ \e[1;31m✕\e[0m ] Wrong Minecraft version!\e[0m" >&2
	cleanup 1
fi
echo -e "\e[38;5;70mStarting:\n\e[0m"
sleep 1
# DO THE MAGIC WITH SOME COLORS
java \
	-Xmx"$SERVER_MAX_RAM" \
	-Xms"$SERVER_MIN_RAM" \
	-jar "$SERVER_JAR" \
	--world "$SERVER_SAVE" \
	--port "$SERVER_PORT" \
	| sed \
	-e 's/Unknown or incomplete command/\x1b[1;31m&\x1b[0m/g' \
	-e 's/ERROR/\x1b[31m&\x1b[0m/g' \
	-e 's/WARN/\x1b[33m&\x1b[0m/g' \
	-e 's/INFO/\x1b[36m&\x1b[0m/g' \
	-e 's/HERE/\x1b[35m&\x1b[0m/g' \
	-e 's/DONE/\x1b[1;32m&\x1b[0m/g' \
	-e 's/Done/\x1b[1;32m&\x1b[0m/g' \
	-e 's/No existing world data, creating new world/\x1b[35m&\x1b[0m/g' \
	-e "s/\"$SERVER_SAVE\"/\x1b[35m&\x1b[0m/g" \
	-e "s/\*\:$SERVER_PORT/\x1b[35m&\x1b[0m/g" \
	|| cleanup 1 && cleanup 0
