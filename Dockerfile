FROM php:7-apache

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

ENV VERSION=$BUILD_VERSION

ENV CORE_HOST ""
ENV CORE_PORT 9851

ENV GUI_LANGUAGE "deutsch"
ENV GUI_STYLE "tango"

ENV GUI_REFRESH_STATUS 10
ENV GUI_REFRESH_DOWNLOADS 30
ENV GUI_REFRESH_UPLOADS 30
ENV GUI_REFRESH_SEARCH 30

ENV GUI_SHOW_NEWS 1
ENV GUI_SHOW_SHARE 1

ENV PROGRESSBARS_TYPE 3

RUN apt update && \
    apt install -y --no-install-recommends libpng-dev \
    && docker-php-ext-install gd \
    && apt clean && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    echo 'variables_order=EGPCS' > /usr/local/etc/php/conf.d/phpaj.ini && \
    ln -sf /dev/null /var/log/apache2/access.log && \
    ln -sf /dev/null /var/log/apache2/error.log && \
    ln -sf /dev/null /var/log/apache2/other_vhosts_access.log

COPY . /var/www/html/

EXPOSE 80

HEALTHCHECK --interval=60s --start-period=5s CMD curl -I --fail http://localhost:80 || exit 1

LABEL org.label-schema.name="appleJuice phpGUI" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url="https://github.com/red171/applejuice-docker-core" \
      org.label-schema.version=${BUILD_VERSION} \
      org.label-schema.schema-version="1.0"
