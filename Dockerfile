FROM ghcr.io/rkojedzinszky/webhost-images/php8

LABEL org.opencontainers.image.authors "Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source https://github.com/kubernetize/nextcloud

ARG NC_VER=24.0.4

USER 0

# download packages & nextcloud
RUN apk --no-cache add curl tar php8-pecl-apcu php8-pecl-imagick && \
    mkdir /var/www/html && \
    curl -sL https://download.nextcloud.com/server/releases/nextcloud-${NC_VER}.tar.bz2 | tar xjf - -C /var/www/html --strip-components=1 && \
    chown -R 0:0 /var/www/html

# Update installation, prepare /data
WORKDIR /var/www/html

RUN \
    chown 8080:8080 .htaccess && \
    mkdir -p /data && \
    chown 8080:8080 /data && \
    rm -rf config && \
    ln -s /data/config config && \
    ln -s /data/apps apps-ext

COPY assets/ /

USER 8080
