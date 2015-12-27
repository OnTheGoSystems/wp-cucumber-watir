#!/usr/bin/env bash

FOLDER_NAME=$1
DOMAIN=$2
PORT=$3
DB_HOST=$4
DB_PORT=$5
DB_USERNAME=$6
DB_PASSWORD=$7
MULTISITE=$8

rm -rf ${FOLDER_NAME}
cp -r /wp ${FOLDER_NAME}
cat << EOF > "${FOLDER_NAME}/wp-config.php"
<?php
define('DB_NAME', '${DOMAIN}');
define('DB_USER', '${DB_USERNAME}');
define('DB_PASSWORD', '${DB_PASSWORD}');
define('DB_HOST', '${DB_HOST}:${DB_PORT}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('AUTH_KEY',         'salt');
define('SECURE_AUTH_KEY',  'salt');
define('LOGGED_IN_KEY',    'salt');
define('NONCE_KEY',        'salt');
define('AUTH_SALT',        'salt');
define('SECURE_AUTH_SALT', 'salt');
define('LOGGED_IN_SALT',   'salt');
define('NONCE_SALT',       'salt');
\$table_prefix = 'wp_';
define("WP_DEBUG_LOG" , true );
define("WP_DEBUG" , true );
define('SCRIPT_DEBUG', true);
define("WP_DEBUG_DISPLAY" , false );
define("AUTOMATIC_UPDATER_DISABLED" , true );
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
EOF
if [ ${MULTISITE} != '0' ]
then
cat << EOF >> "${FOLDER_NAME}/wp-config.php"
define('MULTISITE', true);
define('SUBDOMAIN_INSTALL', false);
\$base = '/';
define('DOMAIN_CURRENT_SITE', '${DOMAIN}');
define('PATH_CURRENT_SITE', '/');
define('SITE_ID_CURRENT_SITE', 1);
define('BLOG_ID_CURRENT_SITE', 1);
EOF
INSTALL_COMMAND=multisite-install
else
INSTALL_COMMAND=install
fi

cat << EOF >> "${FOLDER_NAME}/wp-config.php"
require_once(ABSPATH . 'wp-settings.php');
EOF

./wait.sh ${DB_HOST} ${DB_PORT}

CMD_SUFFIX="--path=${FOLDER_NAME} --allow-root"
wp db drop --yes ${CMD_SUFFIX}
wp db create --yes ${CMD_SUFFIX}
if [ ${PORT} != '80' ]
then
  HOST="${DOMAIN}:${PORT}"
else
  HOST=${DOMAIN}
fi
wp core ${INSTALL_COMMAND} --url=http://${HOST} --title=${DOMAIN} --admin_user=Admin --admin_password=test --admin_email=test@test.dev ${CMD_SUFFIX}