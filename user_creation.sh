#!/bin/bash
read -p "Enter the username:" uname
if id "$uname" 2>&1;
then
	echo "The user $uname exists"
	read -p "Would you like to delete the user(y/n):" choice
	if [ $choice = "y" ];
	then
		sudo userdel $uname
		echo "$uname has been deleted"
	else
		echo "thank you"
	fi
else
	echo "$uname does not exist"
	read -p "Would you like to create the user(y/n):" choice2
	if [ $choice2 = "y" ]
	then
		read -p "Enter the password:" password
		sudo useradd -m -p $password $uname
		echo "user has been created"
	else
		echo "thank you"
	fi
fi
