#!/usr/bin/env bash

backup() {

	USER=$1;   
	SQL_USER=$2;
	SQL_PWD=$3;
	SQL_DB=$4;


	NOW=`date +"%D" | tr "/" "-"`


	mkdir -p /home/${USER}/backups 

	mysqldump -u${SQL_USER} -p${SQL_PWD} ${SQL_DB} > /home/${USER}/public_html/${NOW}.db.sql
	
	tar caf /home/${USER}/backups/${NOW}.tar.gz /home/${USER}/public_html/ 
	rsync -avz /home/${USER}/backups -e "ssh -p 22" root@37.187.92.189:/home/backup/${USER}/

	rm -rf /home/${USER}/backups 
	rm -f /home/${USER}/public_html/${NOW}.db.sql
}


