#!/bin/sh
SERVICE='deluged'
 
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE is running, everything is fine"
else
    echo "$SERVICE is not running"
    $SERVICE
fi
