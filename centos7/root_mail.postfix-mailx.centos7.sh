#!/usr/bin/bash
#
# CentOS 7 prepare script
# - Redirects root to a external email address
# 
# Written by fmmarques @ June 6th 2016

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


#
# Guarantee the availability of EPEL
#
yum install epel-release
if [[ "$?" -ne "0" ]]; then
	echo "Could not enable the EPEL repository."
fi;

# 
# Install the postfix and mailx deps
#
yum install -y postfix mailx


echo "Setting a redirect for root's local email (useful for debugging problems)";
read -p "To what email address should the root's local email be redirected to: " EXTERNAL_EMAIL;

# create an aliases for root on the aliases file
echo "root: ${EXTERNAL_EMAIL}" >> /etc/aliases

newaliases


