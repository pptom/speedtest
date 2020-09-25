FROM php:7.4-apache

# Install extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && mkdir -p /speedtest/

# Copy sources

COPY backend/ /speedtest/backend

COPY results/*.php /speedtest/results/
COPY results/*.ttf /speedtest/results/

COPY *.js /speedtest/
COPY docker/servers.json /servers.json

COPY docker/*.php /speedtest/
COPY docker/entrypoint.sh /

# Prepare environment variabiles defaults

ENV TITLE=LibreSpeed \
    MODE=standalone \
    PASSWORD=password \
    TELEMETRY=false \
    ENABLE_ID_OBFUSCATION=false \
    REDACT_IP_ADDRESSES=false \
    WEBPORT=80

# Final touches

EXPOSE 80
CMD ["bash", "/entrypoint.sh"]
