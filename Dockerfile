FROM registry.lan/krichy/webhost-php8

ARG NC_VER=22.2.3

USER 0

# download packages & nextcloud
RUN apk --no-cache add curl tar php8-pecl-apcu && \
    mkdir /var/www/html && \
    curl -sL https://download.nextcloud.com/server/releases/nextcloud-${NC_VER}.tar.bz2 | tar xjf - -C /var/www/html --strip-components=1 && \
    chown -R 0:0 /var/www/html

# Update installation, prepare /data
RUN \
    chown 8080:8080 /var/www/html/.htaccess && \
    mkdir -p /data && \
    rm -rf /var/www/html/config && \
    ln -s /data/config /var/www/html/config && \
    chown 8080:8080 /data

COPY assets/ /

USER 8080

WORKDIR /var/www/html

CMD ["/usr/local/sbin/nextcloud"]
