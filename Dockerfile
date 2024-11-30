# Gunakan Alpine sebagai base image
FROM php:7.4-fpm-alpine AS php74
FROM php:8.0-fpm-alpine AS php80

# Install dependensi untuk SLiMS, Nginx, PHP, dan alat tambahan (nano, ssh, git)
RUN apk update && apk add --no-cache \
    nginx \
    php-mysqli \
    php-fpm \
    php-mbstring \
    php-json \
    php-xml \
    php-pdo \
    php-pdo_mysql \
    php-bcmath \
    php-iconv \
    php-gd \
    php-gettext \
    bash \
    curl \
    nano \
    openssh \
    git \
    && rm -rf /var/cache/apk/*

# Konfigurasi nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Konfigurasi PHP-FPM
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Salin SLiMS dari direktori lokal ke direktori di dalam container
COPY slims /var/www/slims

# Set hak akses folder SLiMS
RUN chown -R www-data:www-data /var/www/slims

# Expose port untuk Nginx dan PHP
EXPOSE 80 443

# Script untuk menjalankan Nginx dan PHP-FPM
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
