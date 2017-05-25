#!/usr/bin/bash
#
# CentOS 7 prepare script
# - Installs HTTPD with fpm-php55 support
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
# Guarantee the availability of EPEL
#
yum -y install epel-release
if [[ "$?" -ne "0" ]]; then
	echo "Could not enable the EPEL repository."
fi;

#
# Install the Apache2.4
# 
yum -y install httpd &
# Install the Apache mod that allows for fastcgi. 
# yum install mod_fastcgi

# Prepare the script
echo ";Configuring basis for Waterstone pools." > /etc/php-fpm.d/ZZ-Waterstone.conf;
echo ";if 10 PHP-FPM child processes exit with SIGSEGV or SIGBUS within 1 minute then PHP-FPM restart automatically. This configuration also sets 10 seconds time limit for child processes to wait for a reaction on signals from master.." > /etc/php-fpm.d/ZZ-Waterstone.conf;
echo "emergency_restart_threshold = 10" > /etc/php-fpm.d/ZZ-Waterstone.conf;
echo "emergency_restart_interval = 1m" > /etc/php-fpm.d/ZZ-Waterstone.conf;
echo "process_control_timeout = 10s" > /etc/php-fpm.d/ZZ-Waterstone.conf;
echo "include=/etc/php-fpm.d/sites/*.conf";
mkdir -p /etc/php-fpm.d/sites/;


# Enable and start httpd. 
systemctl enable httpd.service
systemctl start httpd.service

