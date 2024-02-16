#!/bin/bash -e

echo "Initialize data..."
for SQL in `ls /sql/*.sql`
do
  echo "mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < $SQL > /dev/null 2>&1"
  mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE "< $SQL >" /dev/null 2>&1
done

