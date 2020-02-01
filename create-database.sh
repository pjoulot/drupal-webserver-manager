#!/bin/bash

echo "Before launching this script, make sure you can connect to your server with an ssh key."

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

DATABASE_NAME=$3
if [ -z "$3" ]; then
    read -p "Enter the database name : " DATABASE_NAME
fi

DATABASE_USER=$4
if [ -z "$4" ]; then
    read -p "Enter the name of the database user : " DATABASE_USER
fi

DATABASE_USER_PASSWORD=$5
if [ -z "$5" ]; then
    read -p "Enter the password of the database user (default: random) : " DATABASE_USER_PASSWORD
fi

if [ "$DATABASE_USER_PASSWORD" == "" ]; then
    DATABASE_USER_PASSWORD=`date +%s | sha256sum | base64 | head -c 32 ; echo`
fi

echo "Starting the install of your website"

echo "Launching the playbook that install all the components."
ansible-playbook -i inventory/webservers database.yml --extra-vars "server_ip=$SERVER_IP server_user=$SERVER_USER database_name=$DATABASE_NAME database_user=$DATABASE_USER database_password=$DATABASE_USER_PASSWORD"

echo "* RECAP ******************************"
echo "Database name:     $DATABASE_NAME"
echo "Database user:     $DATABASE_USER"
echo "Database password: $DATABASE_USER_PASSWORD"
