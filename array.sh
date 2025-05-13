#!/bin/bash
: '
Fruits=("hello" "world" "devops")
echo "${Fruits[@]}"
Fruits+=("grapes")
echo "${#Fruits[@]}"
'

echo "Enter the number of employees being onboarded today:"
read num
employees=()
for ((i=0; i<num; i++))
do
	echo "Enter name of employee:"
	read name
	employees+=("$name")
done
echo "The following employees have been onboarded:"
for ((i=0; i<num; i++))
do
	echo "${employees[$i]}"
done
