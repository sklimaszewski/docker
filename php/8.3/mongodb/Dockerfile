# Build arguments
ARG VERSION

# Alpine base image
FROM php:${VERSION}-fpm-alpine

# Common dependencies
RUN wget https://getcomposer.org/installer && \
    php installer --install-dir=/usr/local/bin/ --filename=composer && \
    rm installer

RUN apk update && \
    apk add --no-cache --virtual dev-deps autoconf gcc g++ make && \
    apk add --no-cache git rsync bash bash-completion nano curl unzip openssl-dev shadow \
        libzip-dev libxslt-dev icu-dev freetype-dev libxpm-dev libgomp \
        libpng-dev libjpeg-turbo-dev libwebp-dev libwebp-tools \
        imagemagick-dev imagemagick jpegoptim pngquant \
        nodejs yarn && \
    echo "no" | pecl install redis

# MongoDB dependencies
RUN apk add --no-cache mongodb-tools && \
    echo "no" | pecl install mongodb-1.16.2 && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-enable opcache redis mongodb && \
    docker-php-ext-install exif gd pcntl intl xsl zip

# Imagick
RUN curl -L -o /tmp/imagick.tar.gz https://github.com/Imagick/imagick/archive/7088edc353f53c4bc644573a79cdcd67a726ae16.tar.gz && \
    tar --strip-components=1 -xf /tmp/imagick.tar.gz && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

# Cleanup
RUN apk del --no-cache dev-deps && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/*

# Final touch
ENV PS1="\u@\h:\w\\$ "

RUN mkdir -p /var/www/html/project/symfony
WORKDIR /var/www/html/project/symfony

CMD ["php-fpm"]