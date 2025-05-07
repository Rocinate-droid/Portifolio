#!/bin/bash
echo "enter first string"
read str1
echo "enter second string"
read str2
for ((i=1; i<=15; i++))
do 
	if [ $((i%3)) -eq 0 ] && [ $((i%5)) -eq 0 ];
        then
                echo "$str1 $str2"
	elif [ $((i % 3)) -eq 0 ];
	then
		echo "$str1"	
	elif [ $((i % 5)) -eq 0 ];
	then
		echo "$str2"
	else
		echo "$i"
	fi
done
