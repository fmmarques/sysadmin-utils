#!/usr/bin/bash
#
# CentOS 7 prepare script
# - Configures iptables for acceptiong SSH
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


#
# Prepare iptables
#

# set default policies for INPUT, FORWARD and OUTPUT chains
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# allow access from localhost
iptables -A INPUT -i lo -j ACCEPT

# allow SSH connections on TCP port 22
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# accept packets belonging to established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

