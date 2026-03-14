FROM debian:bookworm

# Install WordPress, PHP, MariaDB client, and WP-CLI
RUN apt-get update && \
    apt-get install -y curl\
        wordpress \
        php8.2 \
        php8.2-fpm \
        php8.2-mysql \
        mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Copy WordPress default config (if needed)
COPY conf/www.conf /etc/wordpress/config-default.php

# Copy your setup script
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Expose PHP-FPM port
EXPOSE 9000

# Entry point runs setup.sh, then PHP-FPM
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["/usr/sbin/php-fpm8.2", "-F"]