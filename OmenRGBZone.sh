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

#Functions that is used as a RGB zone selector

function zoneSelector() {
    echo -e "\nPlease enter number of the RGB zone to change:\n\n"
    echo -e "1) Left zone\t\t(zone02)\n2) WASD\t\t\t(zone03)\n3) Mid zone\t\t(zone01)\n4) Right zone\t\t(zone00)"
    echo -e "\n\n"
    read -p "=> " zona
    zoneSwitchRecursive
    clear
}

#Function that will stablish the RGB zone

function zoneSwitchRecursive() {
	case "$zona" in
		"1")
			zone="zone02"
			clear
			echo -e "\nYou selected Left zone\n\n"
			colourInputChooser
			;;
		"2")
			zone="zone03"
			clear
			echo -e "\nYou selected WASD zone\n\n"
			colourInputChooser
			;;
		"3")	
			zone="zone01"
			clear
			echo -e "\nYou selected Mid zone\n\n"
			colourInputChooser
			;;
		"4")
			zone="zone00"
			clear
			echo -e "\nYou selected Right zone\n\n"
			colourInputChooser
			;;
		*)
			echo -e "\n\nPlease input a valid number:\n\n"
			read -p "=> " zona
			zoneSwitchRecursive
			;;
	esac

}	

function colourInputChooser() {
    checker=true
    while [[ $checker != false ]]
    do
        echo -e "Choose the way the colour will be entered:\n"
        echo -e "1. Choose colour from built-in presets.\n"
        echo -e "2. Choose colour manually by hex code input.\n"
        echo -e "3. Go back to main menu.\n"
        read -p "=> " option
        if  [[ "$option" =~ ^[1-3]+$ ]]
        then
            checker=false
        fi
    done

    case "$option" in
        "1")
            echo "e"
            colourChangerPresets
            ;;
        "2")
            colourChangerManually
            ;;
        "3")
            main
            ;;
    esac
}

function colourChangerPresets() {
    echo -e "Choose the built-in colour you want to choose:\n"
    echo -e "1. Red.\n"
    echo -e "2. Blue.\n"
    echo -e "3. \033[0;32mGreen.\n"
    echo -e "4. Purple.\n"
    echo -e "5. Yellow.\n"
    echo -e "6. Orange.\n"
    echo -e "7. White.\n"
    echo -e "8. Go back.\n"
}

#Function that will let you to manually enter the desired colour

function colourChangerManually() {
    echo -e "\n\nPlease input the RGB zone colour you want to change (like this: 0000ff):\n\n"
    read -p "=> " colorRGB
    clear
    colourChanger
}

#Function that will change the colour on the desired zone by writing the colour in hex code to the zone file

function colourChanger() {
    echo -e "\nChanging RGB colour, please wait..."
    sleep 1
    sudo bash -c " echo '$colorRGB' > /sys/devices/platform/hp-wmi/rgb_zones/$zone"
    sleep 1
    echo -e "\n\nColour changed succesfully!\n"
    main
}

main #Call to main
