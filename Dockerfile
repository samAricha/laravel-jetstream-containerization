FROM php:8.2-fpm-alpine

RUN apk add --no-cache nginx wget nodejs npm

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app
COPY . /app

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
RUN cd /app && \
    /usr/local/bin/composer install --no-dev

# Install npm packages
RUN cd /app && \
    npm install && npm run build

# Installing mysql
RUN docker-php-ext-install pdo pdo_mysql

RUN chown -R www-data: /app

CMD sh /app/docker/startup.sh


