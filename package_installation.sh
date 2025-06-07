#!/bin/bash
read -p "Enter the packages you want to install:" packages
for i in $packages
do
	if sudo apt list --installed 2>/dev/null | grep -q "$i"
	then
		echo "$i is already installed"
		continue
	fi
	sudo apt update 1>/dev/null
	sudo apt install "$i" 

	if sudo apt list --installed 2>/dev/null | grep -q "$i"
        then
                echo "$i has been successfully installed"
                continue
	else
		echo "There was an error in installing $i package"
		continue
        fi

done
