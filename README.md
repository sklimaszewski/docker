# Docker Alpine images for ARM64 and AMD64 architectures

## PHP FPM

All PHP images contains:
- composer
- basic dev utils (git, rsync, bash, nano, curl, unzip, shadow)
- php modules (opcache, redis, exif, gd, pcntl, intl, xsl, zip)
- composer

Additionally, **non-slim** images contains:
- node, yarn, npm
- imagemagick and php-imagick
- pngquant, jpegoptim

### MongoDB - `sklimaszewski/php:<version>-mongodb`

Image with `php-mongodb` and `mongodb-tools` installed.

### MySQL - `sklimaszewski/php:<version>-mysql`

Image with `php-mysqli, PDO` and `mysql-client` installed.

### Slim Images - `sklimaszewski/php:<version>-<database>-slim`

Smaller images without node and image optimization libraries.

## Varnish

### X-Keys modules  - `sklimaszewski/varnish:<version>-xkeys`

Varnish image containing x-keys modules installed.