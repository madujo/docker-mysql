#!/bin/bash -e
echo "WHAT"
# (1) 환경 변수로 마스터와 슬레이브 구분 .. 마스터면 바로 종료
if [ ! -z "$MYSQL_MASTER" ]; then
  echo "this container is master"
  exit 0
fi

echo "prepare as slave"

# (2) 슬레이브에서 마스터와 통신 가능 여부 확인
if [ -z "$MYSQL_MASTER_HOST" ]; then
  echo "mysql_master_host is not specified" 1>&2
  exit 1
fi

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

# (3) 마스터에 레플리케이션용 사용자 생성 및 권한 부여
IP=`hostname -i`
IFS='.'
set -- $IP
SOURCE_IP="$1.$2.%.%"
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_REPL_USER1'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_REPL_PASSWORD';"
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPL_USER1'@'%';"

# (4) 마스터의 binlog 포지션 정보 확인
MASTER_STATUS_FILE=/tmp/master-status
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW MASTER STATUS\G" > $MASTER_STATUS_FILE
BINLOG_FILE=`cat $MASTER_STATUS_FILE | grep File | xargs | cut -d' ' -f2`
BINLOG_POSITION=`cat $MASTER_STATUS_FILE | grep Position | xargs | cut -d' ' -f2`
echo "BINLOG_FILE=$BINLOG_FILE"
echo "BINLOG_POSITION=$BINLOG_POSITION"

# (5) 레플리케이션 시작
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "reset master;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CHANGE MASTER TO MASTER_HOST='$MYSQL_MASTER_HOST', MASTER_USER='$MYSQL_REPL_USER1', MASTER_PASSWORD='$MYSQL_REPL_PASSWORD', MASTER_LOG_FILE='$BINLOG_FILE', MASTER_LOG_POS=$BINLOG_POSITION;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "START SLAVE;"

echo "slave started"

mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS '$MYSQL_MONITOR_USER'@'%';"
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_MONITOR_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_MONITOR_PASSWORD';"
mysql -h $MYSQL_MASTER_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT REPLICATION CLIENT ON *.* TO '$MYSQL_MONITOR_USER'@'%';"

while :
do
  if mysql -h proxysql -P 6032 -u radmin -pradmin -e "quit" > /dev/null 2>&1 ; then
    echo "MySQL is ready!"
    break
  else
    echo "MySQL is not ready"
  fi
  sleep 3
done

# (6) ProxySQL 호스트 그룹에 DB 서버 정보 입력
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_servers(hostgroup_id, hostname, port) VALUES (10, '$MYSQL_MASTER_HOST', 3306);"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_servers(hostgroup_id, hostname, port) VALUES (20, '$MYSQL_MASTER_HOST', 3306);"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_servers(hostgroup_id, hostname, port) VALUES (20, '$MYSQL_SLAVE01_HOST', 3306);"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_servers(hostgroup_id, hostname, port) VALUES (20, '$MYSQL_SLAVE02_HOST', 3306);"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_replication_hostgroups VALUES (10, 20, 'read_only', '');"

mysql -h proxysql -P 6032 -u radmin -pradmin -e "LOAD MYSQL SERVERS TO RUNTIME;"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "SAVE MYSQL SERVERS TO DISK;"

# (7) ProxySQL 호스트 그룹에 에플리케이션 유저 정보 입력
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_users(username, password, default_hostgroup, transaction_persistent) VALUES ('$MYSQL_APP_USER', '$MYSQL_APP_PASSWORD', 10, 0);"

mysql -h proxysql -P 6032 -u radmin -pradmin -e "LOAD MYSQL USERS TO RUNTIME;"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "SAVE MYSQL USERS TO DISK;"


# (8) ProxySQL 호스트 그룹에 쿼리 룰 정보 입력
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_query_rules(rule_id, active, match_pattern, destination_hostgroup) VALUES (1, 1, '^SELECT.*FOR UPDATE$', 10);"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "INSERT INTO main.mysql_query_rules(rule_id, active, match_pattern, destination_hostgroup) VALUES (2, 1, '^SELECT', 20);"

mysql -h proxysql -P 6032 -u radmin -pradmin -e "LOAD MYSQL QUERY RULES TO RUNTIME;"
mysql -h proxysql -P 6032 -u radmin -pradmin -e "SAVE MYSQL QUERY RULES TO DISK;"

echo "ProxySQL Setting End"
