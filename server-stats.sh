#!/bin/bash


echo

echo "###################"
echo "# Total CPU Usage #"
echo "###################"

usage=$(top -bn1 | grep '%Cpu' | cut -d "," -f 4 | awk '{print $1}')
percent=$(echo "100 - $usage" | bc -l)
echo "$percent %"
		
totalmemory=$(free --mega| grep 'Mem' | awk '{print $2 }')
freememory=$(free --mega| grep 'Mem' | awk '{print $4 }')
usedmemory=$(free --mega| grep 'Mem' | awk '{print $3 }')
echo

echo "###################"
echo "# Total Memory Usage #"
echo "###################"
echo -e "\n Free storage:$freememory MB"
echo "Used storage:$usedmemory MB"
usedpercentage=$(echo "scale=2; $usedmemory / $totalmemory * 100 " | bc -l)
echo -e "$usedpercentage % of total memory has been used \n"
echo

echo "###############################"
echo "# Top 5 processes by CPU usage #"
echo "################################"
echo -e "$(top -bn1 --sort-override=%CPU | awk 'NR==7||NR==8||NR==9||NR==10||NR==11||NR==12') \n"
echo

echo "###############################"
echo "# Top 5 processes by Memory usage #"
echo "################################"
echo -e "$(top -bn1 --sort-override=%MEM | awk 'NR==7||NR==8||NR==9||NR==10||NR==11||NR==12') \n"
