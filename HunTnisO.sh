#!/bin/bash

# Colors
g="\e[0;32m\033[1m" # Good
b="\e[0;31m\033[1m" # Bad
n="\033[0m\e[0m" # Normal
# Variables
pwd=$(pwd)

# Banner
function banner() {
	echo -e ' _   _                _____         _        ___  '
	echo -e '| | | | _   _   __ _ |_   _|  __ _ (_) ___  / _ \ '
	echo -e '| |_| || | | | / _` |  | |   / _` || ||__ \| | | |'
	echo -e '|  _  || |_| || | | |  | |  | | | || |/ __/| |_| |'
	echo -e '|_| |_||_.__/ |_| |_|  |_|  |_| |_||_|\___| \___/ '
	echo -e
	echo -e "Usage:"
	echo -e "	--osint: Install OSINT tools."
	echo -e "	--hunt: Install Hunting tools."
	echo -e ""
}

# Check requirements and install them where needed.
function requirements() {
	# Verify apt Packet Manager.
	apt -v > /dev/null 2>&1
	if [ $? -ne 0 ]; then 
		echo -e "${b}apt Packet Manager is not installed.${n}"
		exit 1;
	else
		# Verify git.
		git --version > /dev/null 2>&1
		if [ $? -ne 0 ]; then 
			echo -e "${g}Installing git...${n}"
			sudo apt -y install git > /dev/null 2>&1
			if [ $? -ne 0 ]; then 
				echo -e "${b}git installation failed.${n}"
				exit 1
			fi
		fi 
		# Verify python3.
		python3 -V > /dev/null 2>&1
		if [ $? -ne 0 ]; then 
			echo -e "${g}Installing python3...${n}"
			sudo apt -y install python3 > /dev/null 2>&1
			if [ $? -ne 0 ]; then 
				echo -e "${b}python3 installation failed.${n}"
				exit 1
			fi
		fi 
		# Verify pip.
		pip -v > /dev/null 2>&1
		if [ $? -ne 0 ]; then 
			echo -e "${g}Installing pip...${n}"
			sudo apt -y install pip > /dev/null 2>&1
			if [ $? -ne 0 ]; then 
				echo -e "${b}pip installation failed.${n}"
				exit 1
			fi
		fi 
		# Verify java.
		java --version > /dev/null 2>&1
		if [ $? -ne 0 ]; then 
			echo -e "${g}Installing java...${n}"
			sudo apt -y install default-jre > /dev/null 2>&1
			if [ $? -ne 0 ]; then 
				echo -e "${b}java installation failed.${n}"
				exit 1
			fi
		fi 		
	fi
}

# Spiderfoot.
function spiderfoot() {
	cd $pwd
	echo -e "${g}=-Spiderfoot-=${n}"
	which spiderfoot > /dev/null 2>&1
	if [ $? -eq 0 ]; then echo -e "${n}Spiderfoot already installed, skipping...${n}" && return; fi 
	if [ -d "spiderfoot/" ]; then echo -e "${n}Directory 'spiderfoot/' already exists, skipping...${n}" && return; fi
	git clone "https://github.com/smicallef/spiderfoot" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Spiderfoot download failed.${n}" && return; fi 
	cd spiderfoot
	pip3 install -r requirements.txt > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Spiderfoot requirements failed to install.${n}" && return; fi
	echo -e "${g}Spiderfoot usage: cd $pwd/spiderfoot/ && python3 sf.py -l 127.0.0.1:5001 (Web access: https://127.0.0.1:5001)${n}"
}

# nmap.
function NMap() {
	echo -e "${g}=-nmap-=${n}"
	nmap -V > /dev/null 2>&1
	if [[ $? -eq 0 ]]; then echo -e "${n}nmap already installed, skipping...${n}" && return; fi
	sudo apt -y install nmap > /dev/null 2>&1
	if [[ $? -ne 0 ]]; then echo -e "${b}nmap download/install failed.${n}" && return; fi
	echo -e "${g}nmap usage: nmap -h${n}"
}

# theHarvester.
function theharvester() {
	cd $pwd
	echo -e "${g}=-theHarvester-=${n}"
	which theHarvester > /dev/null 2>&1
	if [ $? -eq 0 ]; then echo -e "${n}theHarvester already installed, skipping...${n}" && return; fi 
	if [ -d "theHarvester/" ]; then echo -e "${n}Directory 'theHarvester/' already exists, skipping...${n}" && return; fi
	git clone "https://github.com/laramies/theHarvester" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}theHarvester download failed.${n}" && return; fi 
	cd theHarvester
	pip3 install -r requirements.txt > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}theHarvester requirements failed to install.${n}" && return; fi 
	echo -e "${g}theHarvester usage: cd '$pwd/theHarvester/' && python3 theHarvester.py -h${n}"
}

# Maltego.
function maltego() {
	echo -e "${g}=-Maltego-=${n}"
	which maltego > /dev/null 2>&1
	if [ $? -eq 0 ]; then echo -e "${n}Maltego already installed, skipping...${n}" && return; fi 
	sudo dpkg -l maltego > /dev/null 2>&1
	if [ $? -eq 0 ]; then echo -e "${b}Maltego already installed, skipping...${n}" && return; fi
	wget -nc "https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v4.3.0.deb" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Maltego download failed.${n}" && return; fi 
	sudo dpkg -i "Maltego.v4.3.0.deb" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Maltego installation failed.${n}" && return; fi 
	echo -e "${g}Maltego usage: maltego${n}"
}

# Nessus.
function Nessus() {
	echo -e "${g}=-Nessus-=${n}"
	sudo dpkg -l nessus > /dev/null 2>&1
	if [ $? -eq 0 ]; then echo -e "${n}Nessus is already installed, skipping...${n}" && return; fi
	wget -nc "https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/16125/download?i_agree_to_tenable_license_agreement=true" -O "Nessus-10.1.2-ubuntu1110_amd64.deb" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Nessus installer already exists in $pwd.${n}" && return; fi
	sudo dpkg -i "Nessus-10.1.2-ubuntu1110_amd64.deb" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Nessus installation failed.${n}" && return; fi
	sudo /bin/systemctl start nessusd.service > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}Nessus initialization failed.${n}" && return; fi
	echo -e "${g}Nessus web access (Registration will be requested during setup to get an activation code and user/pass): https://127.0.0.1:8834/${n}" 
}

# RITA.
function Rita() {
	cd $pwd
	echo -e "${g}=-RITA-=${n}"
	which rita > /dev/null 2>&1
	if [ $? -eq 0 ]; then echo -e "${n}RITA already installed, skipping...${n}" && return; fi
	if [[ -d "rita/" ]]; then echo -e "${n}Directory 'rita/' already exists, skipping...${n}" && return; fi
	git clone "https://github.com/activecm/rita" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}RITA download failed.${n}" && return; fi 
	cd rita/
	sudo ./install.sh --disable-zeek -r > /dev/null 2>&1
	#if [ $? -ne 0 ]; then echo -e "${b}RITA installation failed.${n}" && return; fi 
	echo -e "${g}RITA usage: rita -h${n}"
}

# APT-Hunter.
function apt-hunter() {
	cd $pwd
	echo -e "${g}=-APT-Hunter-=${n}"
	if [[ -d "APT-Hunter/" ]]; then echo -e "${n}Directory 'APT-Hunter/' already exists, skipping...${n}" && return; fi
	git clone "https://github.com/ahmedkhlief/APT-Hunter" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}APT-Hunter download failed.${n}" && return; fi 
	cd APT-Hunter
	python3 -m pip install -r requirements.txt > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}APT-Hunter requirements failed to install.${n}" && return; fi
	echo -e "${g}APT-Hunter usage: python3 $pwd/APT-Hunter/APT-Hunter.py -h${n}"
}

# dnstwist.
function dnstwist() {
	cd $pwd
	echo -e "${g}=-DNSTwist-=${n}"
	if [[ -d "dnstwist/" ]]; then echo -e "${n}Directory 'dnstwist/' already exists, skipping...${n}" && return; fi
	git clone "https://github.com/elceef/dnstwist" > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}DNSTwist download failed.${n}" && return; fi 
	cd dnstwist
	pip install . > /dev/null 2>&1
	if [ $? -ne 0 ]; then echo -e "${b}DNSTwist installation failed.${n}" && return; fi
	echo -e "${g}DNSTwist usage: python3 $pwd/dnstwist/dnstwist.py -h${n}"
}

# Clean the screen.
clear
# Show the banner.
banner
if [[ $1 == "--osint" ]] || [[ $1 == "--hunt" ]]; then
	# Install requirements
	requirements
fi
if [[ $1 == "--osint" ]] || [[ $2 == "--osint" ]]; then
	# Install OSINT tools.
	echo -e "${n}+++ Threat Intelligence tools for OSINT +++${n}"
	spiderfoot
	NMap
	theharvester
	maltego
	Nessus
fi
if [[ $1 == "--hunt" ]] || [[ $2 == "--hunt" ]]; then
	# Install Hunt tools.
	echo -e "${n}+++ Threat Hunting tools +++${n}"
	Rita
	apt-hunter
	dnstwist
fi
# The End.
echo -e "${n}+++ Game Over +++${n}"
exit 0
