FROM php:7.1-fpm

ENV ENABLE_XDEBUG false
ENV OPENSSL_CONF=/etc/ssl/
ENV NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    re2c \
    sendmail-bin \
    sendmail \
    autoconf \
    automake \
    shtool \
    graphviz \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libxslt-dev \
    libicu-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libpcre3-dev \
    libssl-dev \
    libtool \
    libzip-dev \
    build-essential \
    chrpath \
    libxft-dev \
    libfreetype6 \
    libfontconfig1 \
    libfontconfig1-dev \
    nodejs \
    npm

RUN docker-php-ext-configure gd \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-webp-dir=/usr/include/ \
    --with-freetype-dir=/usr/include/

RUN npm install -g terser \
    requirejs \
    casperjs

RUN docker-php-ext-install bcmath \
    gd \
    simplexml \
    sockets \
    intl \
    soap \
    xsl \
    zip \
    pdo_mysql \
    opcache

RUN pecl install -o -f \
    apcu \
    xdebug

RUN docker-php-ext-enable apcu

WORKDIR /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64 /usr/local/share
RUN ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin

RUN mkdir -p /tmp/xdebug/profile \
    && mkdir -p /tmp/xdebug/trace \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -a -G root www-data \
    && chown -R www-data ./

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]
