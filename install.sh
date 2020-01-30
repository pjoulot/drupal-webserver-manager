#!/bin/bash

echo "Before launching this script, make sure you can connect to your server with an ssh key."
echo "Make sure you user has permissions to install packages on your server."
echo "This script will try to install all the packages that Drupal needs. Your server should not already be configured."

SERVER_IP=$1
if [ -z "$1" ]; then
    read -p "Enter the IP of your server : " SERVER_IP
fi

SERVER_USER=$2
if [ -z "$2" ]; then
    read -p "Enter the user to connect to your server : " SERVER_USER
fi

DEFAULT_SSH_PORT=22
SSH_PORT=$3
if [ -z "$3" ]; then
    read -p "Do you have a specific ssh port? (default: $DEFAULT_SSH_PORT): " SSH_PORT
fi

if [ "$SSH_PORT" == "" ]; then
    SSH_PORT=DEFAULT_SSH_PORT
fi

TOOLS=$1
if [ -z "$1" ]; then
    read -p "Do you want to install some tools that could help administrate your server like vim or wget? (default: yes): N / Y " TOOLS
fi

if [ "$TOOLS" == "N" ] || [ "$TOOLS" == "n" ] || [ "$TOOLS" == "no" ]; then
  TOOLS="no"
else
  TOOLS="yes"
fi

echo "Starting the install of your server"

echo "Install required package for using ansible and configure the server."
ssh -p $DEFAULT_SSH_PORT "$SERVER_USER@$SERVER_IP" "apt-get update; apt-get install python -y;"
