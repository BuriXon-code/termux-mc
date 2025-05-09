#!/data/data/com.termux/files/usr/bin/bash

# 0. MOTD
	motd() {
	banner() {
		local word=$*
		local lenght=30
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
	echo -e "⢰⠀⢸⣿⣦⠈⠀⠀⢼⠁⠀ ⢰⡇⠀⠀⣿⣿⠀⠀⢼⠀⡄⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⡇⠂⠀⣿⠀⠀⢸⡆⠀⢘⡧⠀⠀⣿⠀⠀⢸⠛⠃⠘⣿⣿⡇⠀⡆ "
	echo -e "⠀⠑⢤⣀⣙⡿⠉⠱⣄⣠⣷⣄⣀⣹⣄⣀⣘⡏⢆⣀⣘⣧⣀⣀⣀⣀⣀⣿⣀⣀⣀⣀⣀⣸⣇⣀⣰⣏⣀⣠⣿⣀⣀⣾⣁⣀⣴⣋⣀⡠⠃⠀⠀⠀⢿⣋⣀⡤⠋⠀"
	if command -v tput &>/dev/null; then
		banner "\e[0mInstaller made by \e[38;5;123mBuriXon-code\e[38;5;250m"
	else
		echo -e "\e[0mInstaller made by \e[38;5;123mBuriXon-code\e[38;5;250m"
	fi
	echo -e "\e[?7h"
	echo -e "\e[38;5;123mThe script will prepare the environment and install the necessary packages to run the Minecraft Server.\e[0m"
}

# 1. Check dependencies
check_dependencies() {
	echo -e "\n\e[38;5;70mDependencies:\e[0m"
	declare MISSING_PKGS=()
	declare -A TOOL_TO_PACKAGE=(
		[wget]="wget"
		[unzip]="unzip"
		[jq]="jq"
		[ssh]="openssh"
		[sshpass]="sshpass"
		[tput]="ncurses-utils"
	)
	for cmd in "${!TOOL_TO_PACKAGE[@]}"; do
		if command -v "$cmd" &>/dev/null 2>&1; then
			echo -e "  [ \e[1;32m✓\e[0m ] Package ${TOOL_TO_PACKAGE[$cmd]} installed."
		else
			echo -e "  [ \e[1;31m✕\e[0m ] Package ${TOOL_TO_PACKAGE[$cmd]} is missing."
			MISSING_PKGS+=("${TOOL_TO_PACKAGE[$cmd]}")
		fi
		sleep 0.3
	done

	echo -e "\n\e[38;5;70mOpenJDK (java):\e[0m"
	if command -v java &>/dev/null; then
		# Installed
		echo -e "  [ \e[1;32m✓\e[0m ] Java installed."
		java_version=$(java --version 2>/dev/null | head -n 1)
		if [[ "$java_version" =~ openjdk\ 17\.* ]]; then
			JDKversion=17
		elif [[ "$java_version" =~ openjdk\ 21\.* ]]; then
			JDKversion=21
		fi
		echo -e "    [ \e[1;32m✓\e[0m ] version $JDKversion"
		if [[ $JDKversion -eq 17 ]]; then
			echo -e "    \e[38;5;123mThe maximum Minecraft version you can run on this setup is 1.20.4.\e[0m"
		elif [[ $JDKversion -eq 21 ]]; then
			echo -e "    \e[38;5;123mJDK 21 can run every Minecraft version.\e[0m"
		else
			echo -e "    [ \e[1;31m✕\e[0m ] Very old or unknown version. Try uninstall first."
			exit 1
		fi
	else
		# Installing
		echo -e "  [ \e[1;31m✕\e[0m ] Java not found."
		loop_choose=true
		while $loop_choose; do
			echo -en "    [ \e[1;33m>\e[0m ] Enter version to install [17/21]:  "
			read -r jdk_to_install
			if [[ $jdk_to_install -eq 17 || $jdk_to_install -eq 21 ]]; then
				loop_choose=false
				JDKversion=$jdk_to_install
			else
				echo -e "    [ \e[1;31m✕\e[0m ] Unknown version."
			fi
		done
		echo -e "  [ \e[1;32m✓\e[0m ] OpenJDK-$jdk_to_install selected to install."
		MISSING_PKGS+=("openjdk-${jdk_to_install}")
	fi
}

# 2. Update and install
update_and_install() {
	if [ "${#MISSING_PKGS[@]}" -gt 0 ]; then
		# 2.1 Updating
		echo -e "\n\e[38;5;70mUpdating pkg repository (please wait):\e[0m"
		if apt update &>/dev/null; then
			echo -e "  [ \e[1;32m✓\e[0m ] Done - updated."
		else
			echo -e "  [ \e[1;31m✕\e[0m ] Error while updating pkg repository."
			echo -e "  An error occurred during the update, but don’t worry. We’ll try to install it anyway!"
		fi
		# 2.2 Installing
		echo -e "\n\e[38;5;70mInstalling missings (please wait):\e[0m"
		echo -e "  [ \e[1;33m>\e[0m ${MISSING_PKGS[*]} ]"
		effect_installing=true
		for pkg in "${MISSING_PKGS[@]}"; do
			if apt install -y "$pkg" &>/dev/null; then
				echo -e "    [ \e[1;32m✓\e[0m ] Package $pkg installed."
			else
				effect_installing=false
				echo -e "    [ \e[1;31m✕\e[0m ] Error while installing $pkg."
			fi
		done
		if $effect_installing; then
			echo -e "  [ \e[1;32m✓\e[0m ] Done - installed."
		else
			echo -e "  [ \e[1;31m✕\e[0m ] Error while installing."
			exit 1
		fi
	fi
}

# 3. Creating Minecraft dirs
create_dirs() {
	echo -e "\n\e[38;5;70mCreating directories for server files:\e[0m"
	effect_dir=true
	mkdir -p "$HOME/server_mc/server" || effect_dir=false
	mkdir -p "$HOME/server_mc/datapacks" || effect_dir=false
	if $effect_dir; then
		echo -e "  [ \e[1;32m✓\e[0m ] Done - created."
	else
		echo -e "  [ \e[1;31m✕\e[0m ] Error while creating directories."
		exit 1
	fi
}

# 4. Downloading Minecraft server
download_server() {
	if [[ $JDKversion -eq 17 ]]; then
		echo -e "\n\e[38;5;70mDownloading official server.jar (1.20.4):\e[0m"
		if wget https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar -O "$HOME/server_mc/server/server.jar" &>/dev/null; then
			echo -e "  [ \e[1;32m✓\e[0m ] Done - downloaded."
		else
			echo -e "  [ \e[1;31m✕\e[0m ] Error while downloading server.jar."
		fi
	elif [[ $JDKversion -eq 21 ]]; then
		echo -e "\n\e[38;5;70mDownloading official server.jar (1.21.5):\e[0m"
		if wget https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar -O "$HOME/server_mc/server/server.jar" &>/dev/null; then
			echo -e "  [ \e[1;32m✓\e[0m ] Done - downloaded."
		else
			echo -e "  [ \e[1;31m✕\e[0m ] Error while downloading server.jar."
		fi
	fi
}

# 5. Moving files
move_files() {
	echo -e "\n\e[38;5;70mMoving launcher files:\e[0m"
	effect_moving=true
	if [ ! -f ./template.conf ] || [ ! -f ./launcher.sh ]; then effect_moving=false; fi
	mv ./template.conf "$HOME/server_mc/template.conf" &>/dev/null || effect_moving=false
	chmod +x ./launcher.sh &>/dev/null || effect_moving=false
	mv ./launcher.sh "$HOME/server_mc/launcher.sh" &>/dev/null || effect_moving=false
	if $effect_moving; then
		echo -e "  [ \e[1;32m✓\e[0m ] Done - moved."
	else
		echo -e "  [ \e[1;31m✕\e[0m ] Error while moving files."
		exit 1
	fi
}

# 6. Making link to bin
make_symlink() {
	echo -e "\n\e[38;5;70mPreparing symbolic link into PATH:\e[0m"
	find_available_bin_name() {
		effect_find_name=true
		AVAILABLE_NAMES=("server" "minecraft" "mcserver" "mc-server" "mcraft" "mc" "mcs")
		BIN_PATH="/data/data/com.termux/files/usr/bin"
		for name in "${AVAILABLE_NAMES[@]}"; do
			if [ ! -e "$BIN_PATH/$name" ]; then
				echo "$name"
				return
			fi
		done
		effect_find_name=false
	}
	NEW_NAME=$(find_available_bin_name)
	if $effect_find_name; then
		ln -s "/data/data/com.termux/files/home/server_mc/launcher.sh" \
		"/data/data/com.termux/files/usr/bin/$NEW_NAME" &>/dev/null || { \
			echo -e "  [ \e[1;31m✕\e[0m ] Error creating symbolic link in the PATH directory."; \
			exit 1; \
		}
		echo -e "  [ \e[1;32m✓\e[0m ] Done - linked."
	else
		echo -e "  [ \e[1;31m✕\e[0m ] Error creating symbolic link in the PATH directory."
		exit 1
	fi
}

# 7. Instructions, help
outro() {
	echo -e "\n\e[38;5;70mInstruction:\e[0m"
	echo -e "\e[38;5;123mDone. The Minecraft server has been successfully installed.\e[0m"
	echo -e "\e[38;5;123mTo start the server, simply run the command \"$NEW_NAME\".\e[0m"
	echo -e "\e[38;5;123mTry using \"$NEW_NAME -help\" to learn how the script works.\e[0m\n"
}

# Do the job
motd
check_dependencies
update_and_install
create_dirs
download_server
move_files
make_symlink
outro
