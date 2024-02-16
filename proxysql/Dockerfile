ARG PROXYSQL_VERSION

FROM proxysql/proxysql:${PROXYSQL_VERSION}

# 스크립트를 컨테이너에 복사
COPY prepare.sh /prepare.sh

# 스크립트 실행 권한 부여
RUN chmod +x /prepare.sh

# 스크립트 실행
CMD /prepare.sh && exec proxysql -f
