#!/bin/sh
set -e

# SSL
SSL_DIR="/etc/nginx/ssl"
mkdir -p "$SSL_DIR"
if [ ! -f "$SSL_DIR/inception.crt" ] || [ ! -f "$SSL_DIR/inception.key" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$SSL_DIR/inception.key" \
        -out "$SSL_DIR/inception.crt" \
        -subj "/C=FR/ST=42/L=Paris/O=42 School/OU=Inception/CN=llarrey.42.fr"
fi
chmod 600 "$SSL_DIR/inception.key"
chmod 644 "$SSL_DIR/inception.crt"

# Ensure WordPress folder exists
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# Test Nginx config
nginx -t

# Start CMD (Nginx)
exec "$@"