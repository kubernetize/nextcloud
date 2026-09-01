FROM ghcr.io/rkojedzinszky/webhost-images/php84

LABEL org.opencontainers.image.authors="Richard Kojedzinszky <richard@kojedz.in>"
LABEL org.opencontainers.image.source=https://github.com/kubernetize/nextcloud

ARG NC_VER=34.0.3

USER 0

COPY assets/ /

# download packages & nextcloud
RUN phpver=$(php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;') && \
    apk --no-cache add curl tar php${phpver}-pecl-apcu php${phpver}-pecl-imagick php${phpver}-pecl-redis && \
    rm -rf "/etc/php${phpver}/conf.d" && \
    ln -sf /etc/php/conf.d "/etc/php${phpver}/conf.d" && \
    sed -i -e '/^pm.max_children /s/=.*/= 20/' /etc/php-fpm.conf && \
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

USER 8080
