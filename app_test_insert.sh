#!/bin/bash
for i in {1..30};
do
  mysql -ugigi_user1 -pmadujo -h 192.168.80.128 -P16033 -N -e "INSERT INTO testdb.insert_test SELECT @@hostname,now()" 2>&1| grep -v "Warning"
  sleep 1
done