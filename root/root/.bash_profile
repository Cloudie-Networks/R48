#!/bin/sh
v4Addr=$(curl -s --connect-timeout 2 https://api.ipify.org)
v6Addr=$(curl -s --connect-timeout 2 https://api6.ipify.org)
v4Session=$(birdc show proto 2>/dev/null  | grep -s 'BGP' | wc -l)
v6Session=$(birdc6 show proto 2>/dev/null  | grep -s 'BGP' | wc -l)
v4Active=$(birdc show proto 2>/dev/null  | grep -s 'BGP' | grep 'Established' | wc -l)
v6Active=$(birdc6 show proto 2>/dev/null  | grep -s 'BGP' | grep 'Established' | wc -l)
v4Inactive=$(birdc6 show proto 2>/dev/null  | grep 'BGP' | grep -v 'Established' | wc -l)
v6Inactive=$(birdc6 show proto 2>/dev/null  | grep 'BGP' | grep -v 'Established' | wc -l)
RS4Status=$(ps aux | grep bird)
RS6Status=$(ps aux | grep bird6)
upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
texts=("Route48.org" "ROUTE48" "Tunnelbroker" "Zappie FTW" "Poink Poink" "Cloudie FTW" "Hello" "~ERROR!~")
selectedtext=$(printf "%s\n" "${texts[@]}" | shuf -n1)
fonts=("gangshit1.flf" "gangshit2.flf" "3D-ASCII.flf" "3-D.flf" "3d.flf" "amcslash.flf" "amcslider.flf" "Banner3-D.flf")
selectedfonts=$(printf "%s\n" "${fonts[@]}" | shuf -n1)
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`
        clear
        echo ""
		echo -e "\e[32m ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: \e[1m"
figlet -f $fonts "$selectedtext" -w 10000 | lolcat
		echo -e "\e[32m ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: \e[1m"
        echo -e "\e[1;35mSystem Uptime: $UPTIME \e[1m\e[0m"
        echo "IPv4: $v4Addr - IPv6: $v6Addr"
if [ "${RS4Status}" ]; then
  echo -e "BIRD (IPv4) Status: \e[1;32mONLINE\e[1m\e[0m"
else
  echo -e "BIRD (IPv4) Status: \e[1;31mOFFLINE\e[1m\e[0m"
fi
if [ "${RS6Status}" ]; then
  echo -e "BIRD (IPv6) Status: \e[1;32mONLINE\e[1m\e[0m"
else
  echo -e "BIRD (IPv6) Status: \e[1;31mOFFLINE\e[1m\e[0m"
fi
        echo "IPv4 Sessions: $v4Session (Active: $v4Active Inactive: $v4Inactive)"
        echo "IPv6 Sessions: $v6Session (Active: $v6Active Inactive: $v6Inactive)"
        echo ""
        echo ""
