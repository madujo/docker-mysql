ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION}

# (3) 스크립트 및 각종 설정파일 복사
COPY add-server-id.sh /usr/local/bin/
COPY conf/mysqld.cnf /etc/mysql/mysql.conf.d/
COPY conf/mysql.cnf /etc/mysql/conf.d/
COPY prepare.sh /docker-entrypoint-initdb.d
COPY init-data.sh /usr/local/bin/
COPY entrykit /usr/local/bin/
COPY sql /sql

# (2) entrykit 설치
RUN entrykit --symlink

# (4) 스크립트, mysqld 실행
ENTRYPOINT [ \
  "prehook", \
    "add-server-id.sh", \
    "--", \
  "docker-entrypoint.sh" \
]
CMD ["mysqld"]