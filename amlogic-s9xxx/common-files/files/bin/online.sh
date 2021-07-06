#!/bin/bash
list=$(cat /proc/net/arp | grep 0x2 | sed 's/192.168.1.254.*//g' | sed '/^$/d' | grep 0x2 | sort | awk '{print $4 " -> " $1}')
no=1

while read -r line
do
  ip=$(echo $line | awk '{print $3}')
  mac=$(echo $line | awk '{print $1}')
  host=$(cat /usr/dhcp.leases | grep $ip | awk 'NR==1{print $4}')
  host=$(cat /usr/dhcp.leases | grep $mac | awk '{print $4}')
  if [ "$host" == "Repeater" ]
  then
  	if [ "$ip" != "192.168.1.150" ]
	then
		host="Repeater Client"
	fi
  fi
  echo "$no. $line ($host)<br>"
  no=$((no+1))
done <<<"$list"

