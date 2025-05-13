#!/bin/bash
read -p "Enter your name" name
if [ $(grep $name /etc/passwd) ]

then
	echo "Welcome $name"
else
     	echo "Access denied"
fi
