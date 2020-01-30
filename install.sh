#!/bin/bash

echo "Before launching this script, make sure you can connect to your server with an ssh key."
echo "Make sure you user has permissions to install packages on your server."
echo "This script will try to install all the packages that Drupal needs. Your server should not already be configured."

SERVER_IP=$1
if [ -z "$1" ]; then
    read -p "Enter the IP of your server : " SERVER_IP
fi

SERVER_USER=$2
DEFAULT_SERVER_USER="root"
if [ -z "$2" ]; then
    read -p "Enter the user to connect to your server (default: $DEFAULT_SERVER_USER): " SERVER_USER
fi

if [ "$SSH_PORT" == "" ]; then
    SERVER_USER=$DEFAULT_SERVER_USER
fi

DEFAULT_SSH_PORT=22
SSH_PORT=$3
if [ -z "$3" ]; then
    read -p "Do you have a specific ssh port? (default: $DEFAULT_SSH_PORT): " SSH_PORT
fi

if [ "$SSH_PORT" == "" ]; then
    SSH_PORT=$DEFAULT_SSH_PORT
fi

VARNISH_ENABLE=$4
if [ -z "$4" ]; then
    read -p "Do you want to install Varnish? Y or N (default: yes): " VARNISH_ENABLE
fi

if [ "$VARNISH_ENABLE" == "N" ] || [ "$VARNISH_ENABLE" == "n" ] || [ "$VARNISH_ENABLE" == "no" ]; then
    APACHE_PORT=80
    VARNISH_PORT=0
else
    VARNISH_PORT=80
    APACHE_PORT=81
fi


# Write the host in the ansible hosts.
# Clean in case an host with the same name has already been created before
sed "/$SERVER_IP/d" ./inventory/webservers/hosts > ./inventory/webservers/hosts
echo "$SERVER_IP ansible_connection=ssh ansible_user=$SERVER_USER" >> ./inventory/webservers/hosts && echo "Your server $SERVER_IP can now be managed by ansible"

echo "Starting the install of your server"

echo "Install required package for using ansible and configure the server."
ssh -p $DEFAULT_SSH_PORT "$SERVER_USER@$SERVER_IP" "apt-get update; apt-get install python -y;"

echo "Launching the playbook that install all the components."
ansible-playbook -i inventory/webservers  install.yml --extra-vars "server_ip=$SERVER_IP server_user=$SERVER_USER varnish_port=$VARNISH_PORT apache_port=$APACHE_PORT"
