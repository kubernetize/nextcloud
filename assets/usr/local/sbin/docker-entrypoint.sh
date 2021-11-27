#!/bin/sh

mkdir -p /data/data
mkdir -p /data/apps
mkdir -p /data/config

if [ -f /data/config/config.php ]; then
	php8 occ upgrade
	php8 occ maintenance:update:htaccess
else
	cat <<'EOF' >config/config.php
<?php
$CONFIG = array (
  'datadirectory' => '/data/data',
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/data/apps',
      'url' => '/apps-ext',
      'writable' => true,
    ),
    1 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
  ),
);
EOF
	touch /data/config/CAN_INSTALL
fi

cd /tmp
exec /usr/bin/supervisord
