#!/bin/bash

set -e
set -x

DIR=$(realpath $(dirname "$0"))
USER=$(whoami)
PHP_VERSION=$(phpenv version-name)
ROOT=$(realpath "$DIR/..")
PORT=9000
SERVER="/tmp/php.sock"

function tpl {
    sed \
        -e "s|{DIR}|$DIR|g" \
        -e "s|{USER}|$USER|g" \
        -e "s|{PHP_VERSION}|$PHP_VERSION|g" \
        -e "s|{ROOT}|$ROOT|g" \
        -e "s|{PORT}|$PORT|g" \
        -e "s|{SERVER}|$SERVER|g" \
        < $1 > $2
}

# Make some working directories.
mkdir "$DIR/nginx"
mkdir "$DIR/nginx/sites-enabled"
mkdir "$DIR/var"

# Configure the PHP handler.
PHP_FPM_BIN="$HOME/.phpenv/versions/$PHP_VERSION/sbin/php-fpm"
PHP_FPM_CONF="$DIR/nginx/php-fpm.conf"

# Build the php-fpm.conf.
tpl "$DIR/php-fpm.conf" "$PHP_FPM_CONF"

# Start php-fpm
"$PHP_FPM_BIN" --fpm-config "$PHP_FPM_CONF"

# Build the default nginx config files.
tpl "$DIR/nginx.conf" "$DIR/nginx/nginx.conf"
tpl "$DIR/fastcgi_params" "$DIR/nginx/fastcgi_params"
rm $DIR/nginx/sites-enabled/*
tpl "$DIR/001-api.shwrm.net" "$DIR/nginx/sites-enabled/001-api.shwrm.net"

# Start nginx.
nginx -c "$DIR/nginx/nginx.conf"
