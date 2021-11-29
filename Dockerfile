FROM registry.lan/krichy/webhost-php8

ARG NC_VER=22.2.3

USER 0

# download packages & nextcloud
RUN apk --no-cache add curl tar php8-pecl-apcu php8-pecl-imagick && \
    mkdir /var/www/html && \
    curl -sL https://download.nextcloud.com/server/releases/nextcloud-${NC_VER}.tar.bz2 | tar xjf - -C /var/www/html --strip-components=1 && \
    chown -R 0:0 /var/www/html

# Update installation, prepare /data
WORKDIR /var/www/html

RUN \
    sed -i -e '/RewriteRule.*remote.php.*\[.*R=.*\]/s,/remote.php,%{HTTP:X-Forwarded-Proto}://%{HTTP:X-Forwarded-Host}/remote.php,g' .htaccess && \
    chown 8080:8080 .htaccess && \
    mkdir -p /data && \
    chown 8080:8080 /data && \
    rm -rf config && \
    ln -s /data/config config

COPY assets/ /

USER 8080

CMD ["/usr/local/sbin/nextcloud"]
