FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=HU/ST=Tatabanya/L=Tatabanya/O=42/OU=homeless/CN=hzakharc.42.fr" \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

COPY ./config/default /etc/nginx/conf.d/default.conf

COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["nginx", "-g", "daemon off;"]
