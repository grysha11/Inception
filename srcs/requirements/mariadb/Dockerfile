FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 

COPY ./tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh
ENTRYPOINT [ "/usr/local/bin/setup.sh" ]