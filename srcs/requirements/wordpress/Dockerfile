FROM debian:bookworm

# 1. Installation de PHP-FPM, des extensions requises et de curl
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-soap \
    php8.2-xml \
    php8.2-zip \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Installation de WP-CLI (Récupéré du premier tutoriel, crucial pour le script)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 3. Configuration du dossier de travail (Standard pour WordPress et Nginx)
WORKDIR /var/www/html

# 4. Copie de la configuration PHP-FPM (Pour écouter sur le port 9000 au lieu d'une socket)
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# 5. Configuration du script de démarrage
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]

