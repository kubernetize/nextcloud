FROM ghcr.io/rkojedzinszky/webhost-images/php83

LABEL org.opencontainers.image.authors="Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source=https://github.com/kubernetize/nextcloud

ARG NC_VER=30.0.4

USER 0

# download packages & nextcloud
RUN apk --no-cache add curl tar php83-pecl-apcu php83-pecl-imagick php83-pecl-redis && \
    mkdir -p /var/www/html && \
    curl -sL https://download.nextcloud.com/server/releases/nextcloud-${NC_VER}.tar.bz2 | tar xjf - -C /var/www/html --strip-components=1 --no-same-owner --no-same-permissions

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
