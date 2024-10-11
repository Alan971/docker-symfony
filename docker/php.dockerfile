FROM php:8.1-apache
LABEL maintainer="Alan ROUXEL"
# Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y sudo

RUN apt-get install git -y \
    && apt-get install zip -y

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY . /var/www/html

# Installer Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# utilisation du script d'initialisation de projet si nécessaire (voir le fichier init.sh)
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Configurer le document root d'Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Copie le fichier de configuration Apache
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

# Active le module rewrite d'Apache
RUN a2enmod rewrite


CMD ["/usr/local/bin/init.sh"]

# Exposer le port 80
EXPOSE 80
