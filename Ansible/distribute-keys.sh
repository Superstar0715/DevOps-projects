#!/bin/bash

#this is designed to work with the layout of ansible inventory files#
#you need to make sure this is executale by all users, else itll try to run as root which doesn't have any stored keys#

INVENTORY_FILE=$1
KEYFILE=$2
egrep "([[:digit:]]{1,3}\.?){4}|^[^\[]" $INVENTORY_FILE | awk '{print $1}' | while read SERVERNAME;
    do ssh-copy-id -i $KEYFILE $SERVERNAME
done
