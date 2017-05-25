#!/usr/bin/bash
#
# CentOS 7 prepare script
# - Installs PHP5.5 repos
# 
# Written by fmmarques @ June 3rd 2016


REPO_EPEL=("https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm" "https://mirror.webtatic.com/yum/el7/webtatic-release.rpm")

PHP55SAPI=(php55w php55w-common php55w-fpm php55w-mysql php55w-opcache) 

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
else

# install the mysql server
yum install mysql msysql-server
# enable and start the server
systemctl enable mysqld.service 
systemctl start mysqld.service
# secure the server
mysql_secure_installation
