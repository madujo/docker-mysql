#!/bin/bash -e

# (1) 마스터 살아있는지 확인
while :
do
  if mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "quit" > /dev/null 2>&1 ; then
    echo "MySQL master is ready!"
    break
  else
    echo "MySQL master is not ready"
  fi
  sleep 3
done

#mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_MONITOR_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_MONITOR_PASSWORD';"
#mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT REPLICATION CLIENT ON *.* TO '$MYSQL_MONITOR_USER'@'%';"

#while :
#do
#  if mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "quit" > /dev/null 2>&1 ; then
#    echo "MySQL is ready!"
#    break
#  else
#    echo "MySQL is not ready"
#  fi
#  sleep 3
#done
#
## (2) ProxySQL 호스트 그룹에 DB 서버 정보 입력
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (20, '$MYSQL_MASTER_HOST', 3306);"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (10, '$MYSQL_SLAVE01_HOST', 3306);"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_servers(hostgroup_id, hostname, port) VALUES (10, '$MYSQL_SLAVE02_HOST', 3306);"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_replication_hostgroups VALUES (10, 20, 'read_only', '');"
#
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "LOAD MYSQL SERVERS TO RUNTIME;"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "SAVE MYSQL SERVERS TO DISK;"
#
## (3) ProxySQL 호스트 그룹에 에플리케이션 유저 정보 입력
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_users(username, password, default_hostgroup, transaction_persistent) VALUES ('$MYSQL_APP_USER', '$MYSQL_APP_PASSWORD', 10, 0);"
#
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "LOAD MYSQL USERS TO RUNTIME;"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "SAVE MYSQL USERS TO DISK;"
#
#
## (4) ProxySQL 호스트 그룹에 쿼리 룰 정보 입력
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_query_rules(rule_id, active, match_pattern, destination_hostgroup) VALUES (1, 1, '^SELECT.*FOR UPDATE$', 10);"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "INSERT INTO mysql_query_rules(rule_id, active, match_pattern, destination_hostgroup) VALUES (2, 1, '^SELECT', 20);"
#
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "LOAD MYSQL QUERY RULES TO RUNTIME;"
#mysql -h 127.0.0.1 -P 6032 -u radmin -pradmin -e "SAVE MYSQL QUERY RULES TO DISK;"

echo "setting end"
