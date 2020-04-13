#!/bin/bash
#Mar 04, 2020, 03:44:27

title="SanDisk /SRC Mount"
prompt="Pick an option:"
options=("REmount SanDisk" "Unmount Sandisk" "Force Unmount(Danger!)")

echo ""
echo -e "\033[1;31m""$title""\033[m"
echo ""

PS3="$prompt "
select opt in "${options[@]}" "Quit"; do 

    case "$REPLY" in

    1 ) clear
    
    	echo "$opt"
    	echo ""

    	sudo umount -r /dev/sda1

		echo "Unmounting sda1"
		echo ""

		sleep 1

		echo "Mounting /usr/src to /dev/sda1"
		echo ""

		sudo mount --make-rslave /dev/sda1 /usr/src
		sleep 1

		echo "DONE!"
		echo ""
		echo "Dont forget to Unmount before you remove the USB"
		echo ""
		read -p -r "Press [Enter] key to exit..."

		xdg-open /usr/src
		exit;;

    2 ) clear
    
    	echo "$opt"
    	echo ""
    	
    	sudo umount -r /dev/sda1
    	sleep 1
    	
    	echo ""
    	echo "DONE"
    	
    	sleep 2
    	exit;;
    	
    3 ) clear
    	
    	echo "$opt"
    	echo ""
    	echo "fuser force killing mount"
    	sleep 2
    	
    	sudo fuser -k /usr/src
    	sudo fuser -k /dev/sda1
    	sudo umount -f /dev/sda1
    	
    	read -p -r "Press [Enter] key to exit..."
    	exit;;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done
