#!/bin/bash
# Author- Alexandre Chatiron

# Variables
DBPASSWD=root

echo -e "\n--- Installing now... ---\n"

# Updating repository

echo -e "\n--- Updating packages list ---\n"
sudo apt-get update -y 

# Installing Apache

echo -e "\n--- Installing Apache ---\n"
sudo apt-get install -y apache2

# set Vagrant folder as Apache root folder and go to it
echo -e "\n--- Setting document root to public directory ---\n"
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant /var/www/html
fi

# Installing mod_rewrite
echo -e "\n--- Installing mod_rewrite ---\n"

sudo a2enmod rewrite

# Installing MySQL and it's dependencies, Also, setting up root password for MySQL as it will prompt to enter the password during installation
echo -e "\n--- Install MySQL phpmyadmin specific packages and settings ---\n"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

sudo apt-get install -y mysql-server

# Installing PHP and it's dependencies
echo -e "\n--- Install PHP and more---\n"
sudo apt-get install -y php5 libapache2-mod-php5 

# php5-gd: module for handling graphics directly from PHP scripts. It supports the PNG, JPEG, XPM formats as well as Freetype/ttf fonts. 
sudo apt-get install -y php5-gd php5-mcrypt php5-mysqlnd php-soap php5-xdebug

# curl
sudo apt-get install -y curl php5-curl

# Installing phpmyadmin 
echo -e "\n--- Install phpmyadmin specific packages and settings ---\n"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

sudo apt-get install -y phpmyadmin 

# Make phpmyadmin available
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/sites-enabled/phpmyadmin.conf

# Restarting 
echo -e "\n--- Restarting Apache ---\n"
sudo service apache2 restart

sudo service mysql restart
