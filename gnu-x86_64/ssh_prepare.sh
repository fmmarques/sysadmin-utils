#!/usr/bin/env bash

ssh_prepare() {
	read -e -p "Remote server (with administrative privileges):" REMOTE_SERVER
	read -e -p "Remote server's SSH port:" REMOTE_PORT
	read -e -p "Remote hostname as an alias to ${REMOTE_SERVER} (leave empty if you dont know any):" REMOTE_HOST
	read -e -p "Remote user to be used:" REMOTE_USER

	if [ "${REMOTE_HOST}" == "" ]; then
		REMOTE_HOST=${REMOTE_SERVER};
	fi;

	if [[ ! -e "${HOME}/.ssh/rsa/${REMOTE_USER}@${REMOTE_HOST}.pub" ]]; then
		mkdir -p "${HOME}/.ssh/rsa"
		ssh-keygen -b 4096 -t rsa -N "" -C "Key generated automatically for ${REMOTE_USER} in ${REMOTE_HOST}" -f ${HOME}/.ssh/rsa/${REMOTE_USER}@${REMOTE_HOST};
	fi;

	
	if [[ `command -v ssh-copy-id >> /dev/null && echo $?` -eq 0 ]]; then
		ssh-copy-id -i ${HOME}/.ssh/rsa/${REMOTE_USER}@${REMOTE_HOST}.pub -p ${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_SERVER};
	else 
		cat ${HOME}/.ssh/rsa/${REMOTE_USER}@${REMOTE_HOST}.pub | ssh ${REMOTE_USER}@${REMOTE_SERVER} "mkdir -p /home/${REMOTE_USER}/.ssh && cat >> /home/${REMOTE_USER}/.ssh/authorized_keys && chown -R ${REMOTE_USER}. /home/${REMOTE_USER}/.ssh && chmod 700 /home/${REMOTE_USER}/.ssh && chmod 600 /home/${REMOTE_USER}/.ssh/authorized_keys"
	fi;	

	if [[ ! -e "${HOME}/.ssh/config" ]] || [[ $(grep -ci "^Host ${REMOTE_HOST}$" ${HOME}/.ssh/config) -eq 0 && $(grep -ci "^Host ${REMOTE_SERVER}$" ${HOME}/.ssh/config) -eq 0 ]]; then
		mkdir -p ${HOME}/.ssh/ && chmod 700 ${HOME}/.ssh && touch ${HOME}/.ssh/config && chmod 600 ${HOME}/.ssh/config;
  
		if [[ "${REMOTE_HOST}" != "" ]]; then		
			echo -e "\n# Adding ${REMOTE_HOST} to configuration." >> ${HOME}/.ssh/config
			echo -e "Host ${REMOTE_HOST}" >> ${HOME}/.ssh/config
			echo -e "\tHostName ${REMOTE_HOST}" >> ${HOME}/.ssh/config
		else 
			echo -e "\n# Adding ${REMOTE_SERVER} to configuration." >> ${HOME}/.ssh/config
			echo -e "Host ${REMOTE_SERVER}" >> ${HOME}/.ssh/config
			echo -e "\tHostName ${REMOTE_SERVER}" >> ${HOME}/.ssh/config
		fi;		
		echo -e "\tPort ${REMOTE_PORT}" >> ${HOME}/.ssh/config
		echo -e "\tUser ${REMOTE_USER}" >> ${HOME}/.ssh/config
		echo -e "\tIdentityFile ${HOME}/.ssh/rsa/%r@%h" >> ${HOME}/.ssh/config
	fi;
} 
