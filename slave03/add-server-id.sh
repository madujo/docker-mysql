#!/bin/bash -e

config_file="/etc/mysql/conf.d/mysqld.cnf"
# server-id 있으면 종료
if grep -q 'server-id' "$config_file"; then
    echo "Error: 'server-id' already exists in $config_file. Exiting."
    exit 0
fi

# 파일 복사
cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/conf.d/mysqld.cnf

# server-id 생성
OCTETS=(`hostname -i | tr -s '.' ' '`)
MYSQL_SERVER_ID=`expr ${OCTETS[2]} \* 256 + ${OCTETS[3]}`

# sever-id 추가
echo "server-id=$MYSQL_SERVER_ID" >> /etc/mysql/conf.d/mysqld.cnf
chmod 0444 /etc/mysql/conf.d/mysqld.cnf

# 수정한 파일 확인
cat /etc/mysql/conf.d/mysqld.cnf