#!/bin/bash

: '
    HP-OMEN-Linux-RGBColour-ChangerScript

    Copyright (C) 2021  JesusXD88

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
'   

# zone00 -> derecha | zone01 -> medio | zone02 -> izquierda | zone03 -> WASD

#Main function. This serves as an elevated privileges checker and as menu
function main() {
    clear
    echo -e "\nHP Omen RGB colour chooser by JesusXD88\n\n"
    if [[ "$EUID" != 0 ]]
    then
        echo -e "To use this script you need elevated privileges, as we're messing with system configs.\n"
        exit 1
    fi
    checker=true
    while [[ $checker != false ]]
    do
        echo -e "\nPlease select an option:\n\n"
        echo -e "1. Install RGB control driver (Kernel module)."
        echo -e "2. Change keyboard colour."
        echo -e "3. Exit.\n"
        read -p "=> " option
        if  [[ "$option" =~ ^[1-3]+$ ]]
        then
            checker=false
        fi
    done

    case "$option" in
        "1")
            driverInstaller
            ;;
        "2")
            zoneSelector
            ;;
        "3")
            echo -e "\nExiting...\n"
            sleep 1
            exit 0
            ;;
        esac
}


#Function that will clone the Kernel module's repository, build and install it.
#Thanks to pelrun (https://github.com/pelrun/hp-omen-linux-module)

function driverInstaller() {
    clear
    echo -e "The driver (Kernel module) will be installed, please wait...\n"
    if [[ -d "hp-omen-linux-module" ]]
    then
        rm -rf hp-omen-linux-module
    fi
    git clone https://github.com/pelrun/hp-omen-linux-module.git
    cd hp-omen-linux-module
    make install
    if [ $? -eq 0 ]
    then
        echo -e "\nThe driver has been built and installed succesfully!\nYou will need to reboot so the module can be loaded.\n"
        sleep 3
        main
    else
        echo -e "\nAn error has ocurred!\n"
        main
    fi
}

function zoneSelector() {
    echo -e "\nPlease enter number of the RGB zone to change:\n\n"
    echo -e "1) Left zone\t\t(zone02)\n2) WASD\t\t\t(zone03)\n3) Mid zone\t\t(zone01)\n4) Right zone\t\t(zone00)"
    echo -e "\n\n"
    read -p "=> " zona
    zoneSwitchRecursivo
    clear
}

function zoneSwitchRecursivo() {
	case "$zona" in
		"1")
			zone="zone02"
			echo -e "\nYou selected Left zone\n\n"
			;;
		"2")
			zone="zone03"
			echo -e "\nYou selected WASD zone\n\n"
			;;
		"3")	
			zone="zone01"
			echo -e "\nYou selected Mid zone\n\n"
			;;
		"4")
			zone="zone00"
			echo -e "\nYou selected Right zone\n\n"
			;;
		*)
			echo -e "\n\nPlease input a valid number:\n\n"
			read -p "=> " zona
			zoneSwitchRecursivo
			;;
	esac
}	



main

echo -e "\n\nPlease input the RGB zone colour you want to change (like this: 0000ff):\n\n"
read -p "=> " colorRGB
clear

echo -e "\nChanging RGB colour, please wait..."
sleep 1
sudo bash -c " echo '$colorRGB' > /sys/devices/platform/hp-wmi/rgb_zones/$zone"
sleep 1
echo -e "\n\nColour changed succesfully!\n\nBye!"

