FROM alpine:3.11

ARG UID=1000

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV MUSL_LOCPATH="/usr/share/i18n/locales/musl"

COPY ./php-enable-extensions.sh /tmp/php-enable-extensions.sh
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx-server.conf /etc/nginx/conf.d/default.conf
COPY ./php-fpm.ini /etc/php7/php-fpm.d/www.conf

RUN set -e; \
    apk update; \
    apk add --no-cache --virtual .build-deps \
            autoconf \
            alpine-sdk \
            build-base \
            linux-headers \
            libzip-dev \
            imagemagick-dev \
            unixodbc-dev \
            php7-dev \
            php7-pear; \
    apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/v3.13/community" musl-locales musl-locales-lang; \
    cd "$MUSL_LOCPATH"; \
    for i in *.UTF-8; do cp -a "$i" "${i%%.UTF-8}"; done; \
    cd /tmp; \
    apk add --no-cache \
        git \
        nginx \
        tzdata \
        php7-intl \
        php7-openssl \
        php7-dba \
        php7-sqlite3 \
        php7-pear \
        php7-tokenizer \
        php7-pecl-protobuf \
        php7-gmp \
        php7-phalcon \
        php7-pdo_mysql \
        php7-sodium \
        php7-pcntl \
        php7-common \
        php7-pecl-oauth \
        php7-xsl \
        php7-fpm \
        php7-pecl-mailparse \
        php7-pecl-imagick \
        php7-enchant \
        php7-pecl-uuid \
        php7-pspell \
        php7-pecl-ast \
        php7-pecl-redis \
        php7-snmp \
        php7-fileinfo \
        php7-mbstring \
        php7-pecl-lzf \
        php7-pecl-amqp \
        php7-pecl-yaml \
        php7-pecl-timezonedb \
        php7-xmlrpc \
        php7-embed \
        php7-xmlreader \
        php7-pdo_sqlite \
        php7-exif \
        php7-pecl-msgpack \
        php7-opcache \
        php7-ldap \
        php7-posix \
        php7-session \
        php7-gd \
        php7-gettext \
        php7-json \
        php7-xml \
        php7-iconv \
        php7-sysvshm \
        php7-curl \
        php7-shmop \
        php7-odbc \
        php7-phar \
        php7-pdo_pgsql \
        php7-imap \
        php7-pecl-apcu \
        php7-pdo_dblib \
        php7-pdo_odbc \
        php7-pecl-igbinary \
        php7-cgi \
        php7-ctype \
        php7-pecl-mcrypt \
        php7-wddx \
        php7-bcmath \
        php7-calendar \
        php7-tidy \
        php7-dom \
        php7-sockets \
        php7-pecl-zmq \
        php7-pecl-event \
        php7-pecl-vips \
        php7-pecl-memcached \
        php7-brotli \
        php7-soap \
        php7-sysvmsg \
        php7-pecl-ssh2 \
        php7-ftp \
        php7-sysvsem \
        php7-pdo \
        php7-static \
        php7-bz2 \
        php7-simplexml \
        php7-xmlwriter \
        php7-zip; \
    export MAKEFLAGS="-j $(nproc)"; \
    pecl install -f ds-1.4.0; \
    pecl install grpc; \
    pecl install inotify; \
    pecl install -f memcache-4.0.5.2; \
    pecl install propro; \
    pecl install psr; \
    pecl install raphf; \
    pecl install rar; \
    pecl install -f pdo_sqlsrv-5.7.0; \
    /bin/sh /tmp/php-enable-extensions.sh; \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/02276be601ec59697e9f474b668d27d14938e910/web/installer -O - -q | php -- --quiet; \
    mv composer.phar /usr/local/bin/composer; \
    mkdir /run/nginx -p; \
    wget -c https://github.com/nicolas-van/multirun/releases/download/1.1.3/multirun-x86_64-linux-musl-1.1.3.tar.gz -O - | tar -xz; \
    mv multirun /usr/local/bin/; \
    mkdir -p /var/www/app/public /run/nginx /run/php; \
    adduser -D -H -h /var/www/app -u $UID app; \
    chown -R app:app /var/www/app /var/lib/nginx /run/nginx /var/log/php7 /run/php; \
    ln -sf /proc/1/fd/1 /var/log/nginx/access.log; \
    ln -sf /proc/1/fd/2 /var/log/nginx/error.log; \
    ln -sf /proc/1/fd/2 /var/log/php7/error.log; \
    apk del .build-deps; \
    rm -fr /usr/lib/php7/modules/*.a /tmp/* /usr/src/* /usr/lib/debug/*;


USER $UID

COPY ./index.php /var/www/app/public/index.php

WORKDIR /var/www/app

EXPOSE 8080

ENTRYPOINT [ "/usr/local/bin/multirun" ]
CMD [ "php-fpm7 -F", "nginx -g 'daemon off;'" ]
