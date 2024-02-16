#!/bin/bash
while true;
do
  mysql -ugigi_user1 -pmadujo -h 192.168.80.128 -P16033 -N -e "SELECT @@hostname, NOW()" 2>&1 | grep -v "Warning"
  sleep 1
done