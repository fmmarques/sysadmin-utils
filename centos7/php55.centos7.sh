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
fi;

# 
# Install the EPEL repos
#
for REPO in ${REPO_PHP55[*]}; do
	rpm -Uvh ${REPO}
done


#
# Install the PHP5.5 SAPI extensions
#
for SAPI in ${PHP55SAPI[*]}; do
	yum -y install ${SAPI};
done;

if [[ $(grep -c "date\.timezone" /etc/php.ini) -eq "2" ]] && [[ $(grep -c "^;date\.timezone" /etc/php.ini) -eq "1" ]]; then
	echo "Fixing the phpinfo timezone setting";
	mkdir -p ~/configuration/backup/etc/
	cp /etc/php.ini ~/configuration/backup/etc/php.ini.0
	sed 's|;date.timezone =|date.timezone = "Europe/Lisbon"|g' ~/configuration/backup/etc/php.ini.0 > /etc/php.ini
fi;

# enable the service
systemctl enable php-fpm.service
#start
systemctl start php-fpm.service


