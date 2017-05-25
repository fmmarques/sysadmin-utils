#!/usr/bin/bash
#
# CentOS 7 prepare script
# - Installs PHP5.5 repos
# 
# Written by fmmarques @ June 3rd 2016

#
# Check if the script is running under root's user privileges
#  
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#
# Check if the system is a CentOS 7 system
#
if [[ ! -e "/etc/centos-release" ]] || [[ $(grep -c "CentOS Linux release 7" /etc/centos-release) -eq "0" ]]; then
	echo "This script must be run in a CentOS 7 system only" 1>&2
	exit
fi

echo "System's name (do not use DNS): ";
read SYSTEM
echo "Hostname to be used in this system (the DNS name will do): ";
read HOSTNAME
echo "Is this a production or a development system (production/development): ";
read TYPE
hostnamectl set-hostname "${SYSTEM}"
hostnamectl set-hostname "${HOSTNAME}" --static
hostnamectl set-hostname "${HOSTNAME} ${TYPE}" --pretty
echo "The system's names are: "
hostnamectl status
read -p "Are those ok (y/n)? " OK;
if [[ "${OK}" == "y" ]]; then
	echo "Restarting systemd-hostnamed
	systemctl restart systemd-hostnamed;
fi;
