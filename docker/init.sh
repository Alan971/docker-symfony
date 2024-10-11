#!/bin/sh

# charge les variable d'environnement
. /etc/environment

if [ ! -d "/var/www/html/${PROJECT_NAME}/public" ]; then
    echo "Creating Symfony project..."
    sudo composer create-project symfony/skeleton "/var/www/html/"
    cd "/var/www/html/${PROJECT_NAME}"
    sudo composer require symfony/${PROJECT_TYPE}
    sudo chown -R www-data:www-data "/var/www/html"
    sudo chmod -R 777 "/var/www/html"
else
    echo "Symfony project already exists."
fi

# Exporte la variable SERVER_NAME
export SERVER_NAME=${SERVER_NAME}

exec apache2-foreground
