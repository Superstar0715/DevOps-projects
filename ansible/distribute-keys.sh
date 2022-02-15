#!/bin/bash

FILE=$1
egrep "([[:digit:]]{1,3}\.?){4}|^[^\[]" $FILE | awk '{print $1}' | while read SERVERNAME;
    do ssh-copy-id $SERVERNAME
done