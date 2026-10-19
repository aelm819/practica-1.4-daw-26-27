#!/bin/bash
set -ex

#Importamos los varaibles de entorno
source .env

# Creamos el certificado autofirmado
sudo openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

  # copiamos el archivo de configuración de Apache para HTTPS
  cp ../conf/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

  # Habilitamos el virtualHost de Apache para SSL
  a2ensite default-ssl.conf

  # Habilitamos el módulo SSL de Apache 
  a2enmod ssl

  # copiamos el archivo de configuración de Apache para redirigir HTTP a HTTPS
  cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

  # Habilitamos el módulo de rescritura de Apache
  a2enmod rewrite

  # Reiniciamos restart Apache
  systemctl restart apache2