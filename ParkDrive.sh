#!/bin/bash

#This script unmounts all partitions, and parks the heads on a drive for hotswapping
#Input the designation of the Drive you want to Park

#Functions
HelpFunc(){
   # Display Help
   echo "ParkDrive unmounts and puts a drive into standby, which should park the heads, and prepare the drive for removal."
   echo "Ideal for a Hot Swappable drive setup. Uses umount and hdparm. When run without options it is an interactive text UI."
   echo "This Script was designed for my personal use. It is being provided for free, and with no garauntees whatsoever."
   echo "Use at your own risk."
   echo
   echo "Syntax: ParkDrive [-o] [-d] [Drive]"
   echo "options:"
   echo "h     Display this help"
   echo "d     Preselect drive (ie sda sdb sde etc)"
   echo "f     Fast Skips Countdown"
   echo "Y     Skips Confirmation Dialogue. Use at your own risk"
   echo "s     Suspend Drive (default action)"
   echo "r     Remove (Sleep) Drive (lower power state but can cause problems for some raid controllers, or make drives vanish)" 
   echo
   exit 0
}

Park(){
	#Unmounts all Partitions on a drive and puts the Drive into standby
	#input Drive Designation (ie sdd)
	umount /dev/${1}? 
	if [ $? -ne 0 ]; then
		for File in /dev/${1}?
		do
		findmnt ${File}
			if [ $? -ne 0 ]; then
				echo "${File} is not mounted"
			else
				echo
				echo "ERROR: ${File} is still mounted!!"
				echo
				exit 11
			fi
		done
	else
		echo "${1} unmounted" 
	fi
	
	echo "wait three seconds"
	for Index in {3..1}
		do
		echo "Parking drive in ${Index}"
		sleep 1
	done

	hdparm -$Mode /dev/${1}
	if [ $? -ne 0 ]; then
		echo
		echo "ERROR: Can Not Put Drive in Standby"
		echo
		exit 12
	fi
	return 0
}

#Variables
Help=0
Drive=NULL
Fast=0
Confirmation=0
Mode="y"

#Options
while [[ "$#" -gt 0 ]]; do
    case $1 in
		-h|--help) Help=1 ;;
        -d|--Drive) Drive="$2"; shift ;;
        -f|--fast) Fast=1 ;;
        -Y|--NoWarnings) Confirmation=1 ;;        
        -s|--NoWarnings) Mode="y" ;;
        -r|--NoWarnings) Mode="Y" ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

#Help
if [ $Help == 1 ]; then
	HelpFunc
	exit 0
fi 

#Main
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run as Root"
    exit 2
fi

if [ $Drive == NULL ]; then
	printf "$(sudo lsblk /dev/sd?)\n"
	echo "Which drive would you like to remove? (ie sda sdb sdc etc)"
	read Drive
fi
		
test -e /dev/${Drive}
if [ $? -ne 0 ]; then
	echo "ERROR: Drive does Not Exist"
	exit 3
fi

if [ $Confirmation != 1 ]; then 
	echo
	echo "Are you sure you want to unmount /dev/${Drive}?"
	echo "Unmounting system drives could cause system instability. y/N"
	read Input
		if [ "${Input}" != "y" ] && [ "${Input}" != "Y" ]; then
			echo "Exit"
			exit 0
		fi
fi

if [ $Fast != 1 ]; then 
	for Index in {5..1}
	do
	echo "unmounting drive in ${Index}"
	sleep 1
	done
	echo "unmounting drive"
	echo
fi

Park ${Drive}

exit 0
