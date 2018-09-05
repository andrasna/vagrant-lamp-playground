#!/usr/bin/env bash

apt-get update

# Variables
DBPASSWD=root

echo "=== Install Apache ==="

apt-get install -y apache2
ln -fs /vagrant/dev /var/www/html
# Enable mod mode_rewrite
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
a2enmod rewrite
service apache2 restart

# Add main user to the Apache user group
# usermod -a -G www-data ubuntu 

echo "=== Install PHP ==="

add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get -y install php7.2

echo "=== Install MySQL ==="

debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
apt-get -y install mysql-server

echo "=== Install PhpMyAdmin ==="

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install phpmyadmin
ln -fs /usr/share/phpmyadmin /var/www/html
