FROM richarvey/nginx-php-fpm:latest

ARG VERSION

#Install Necessary PHP Extensions and Composer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions sockets mysqli @composer

# Copy wadapi entrypoint
COPY ./bin/wadapi_entrypoint.sh /wadapi_entrypoint.sh

# Copy custom nGinx config
COPY ./conf/nginx.conf /var/www/html/conf/nginx/nginx-site.conf

# Create blank wadapi project
RUN composer create-project --no-scripts dadlian/wadapi:${VERSION} project

WORKDIR project
CMD ["/wadapi_entrypoint.sh"]