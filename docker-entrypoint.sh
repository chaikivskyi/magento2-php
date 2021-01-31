#!/bin/bash
/etc/init.d/sendmail start

if [[ "$ENABLE_XDEBUG" = "true" ]]; then
  docker-php-ext-enable xdebug;
fi

php-fpm
