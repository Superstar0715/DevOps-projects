#!/bin/bash

#you need to make sure this is executale by all users, else itll try to run as root which doesn't have any stored keys#

FILE=$1
egrep "([[:digit:]]{1,3}\.?){4}|^[^\[]" $FILE | awk '{print $1}' | while read SERVERNAME;
    do ssh-copy-id $SERVERNAME
done
