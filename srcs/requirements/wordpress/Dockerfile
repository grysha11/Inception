FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget

RUN sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/html

ENTRYPOINT [ "setup.sh" ]

CMD [ "/usr/sbin/php-fpm8.2", "-F" ]
