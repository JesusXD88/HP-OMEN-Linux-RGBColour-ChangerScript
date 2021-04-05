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

clear
echo -e "\nHP Omen RGB colour chooser by JesusXD88\n\n"
echo -e "To use this script you need elevated privileges, as we're messing with system configs.\n"
echo -e "\nPlease enter number of the RGB zone to change:\n\n"
echo -e "1) Left zone\t\t(zone02)\n2) WASD\t\t\t(zone03)\n3) Mid zone\t\t(zone01)\n4) Right zone\t\t(zone00)" 
echo -e "\n\n"
read -p "=> " zona
clear

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

zoneSwitchRecursivo

echo -e "\n\nPlease input the RGB zone colour you want to change (like this: 0000ff):\n\n"
read -p "=> " colorRGB
clear

echo -e "\nChanging RGB colour, please wait..."
sleep 1
sudo bash -c " echo '$colorRGB' > /sys/devices/platform/hp-wmi/rgb_zones/$zone"
sleep 1
echo -e "\n\nColour changed succesfully!\n\nBye!"

