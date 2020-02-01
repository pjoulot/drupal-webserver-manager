#!/bin/bash

echo "Before launching this script, make sure you can connect to your server with an ssh key."

DOMAIN_NAME=$1
if [ -z "$1" ]; then
    read -p "What is the website? (domain.com) : " DOMAIN_NAME
fi

SERVER_USER=$2
DEFAULT_SERVER_USER="root"
if [ -z "$2" ]; then
    read -p "Enter the user to connect to your server (default: $DEFAULT_SERVER_USER): " SERVER_USER
fi

if [ "$SSH_PORT" == "" ]; then
    SERVER_USER=$DEFAULT_SERVER_USER
fi

if [[ $DOMAIN_NAME =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  SERVER_IP=$DOMAIN_NAME
else
  SERVER_IP=`dig +short $DOMAIN_NAME`
fi

echo "Starting the install of your website"

echo "Launching the playbook that install all the components."
ansible-playbook -i inventory/webservers site.yml --extra-vars "server_ip=$SERVER_IP server_user=$SERVER_USER domain_name=$DOMAIN_NAME"
