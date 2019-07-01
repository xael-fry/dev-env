#!/bin/bash
# Author- Alexandre Chatiron

# include parse_yaml function
. /config/parse_yaml.sh

eval $(parse_yaml /config/config.yaml "config_")

# Variables
DBPASSWD=root
PHP_POST_MAX_SIZE=$config_config_php_post_max_size
PHP_UPLOAD_MAX_FILESIZE=$config_config_php_upload_max_filesize

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

# Installing apache modules
echo -e "\n--- Installing Apache modules : mod_rewrite ---\n"

sudo a2enmod rewrite

sudo a2enmod headers

# Installing MySQL and it's dependencies, Also, setting up root password for MySQL as it will prompt to enter the password during installation
echo -e "\n--- Install MySQL phpmyadmin specific packages and settings ---\n"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

sudo apt-get install -y mysql-server

# Installing PHP and it's dependencies
echo -e "\n--- Install PHP and more---\n"
sudo apt-get install -y php5 libapache2-mod-php5 

# php5-gd: module for handling graphics directly from PHP scripts. It supports the PNG, JPEG, XPM formats as well as Freetype/ttf fonts. 
sudo apt-get install -y php5-gd php5-mcrypt php5-mysqlnd php-soap php5-xdebug php5-intl

# curl
sudo apt-get install -y curl php5-curl

# Configure PHP
echo -e "\n--- Configure PHP ---\n"
sudo sed -i "/post_max_size = .*/c post_max_size = $PHP_POST_MAX_SIZE" /etc/php5/apache2/php.ini
sudo sed -i "/upload_max_filesize = .*/c upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE" /etc/php5/apache2/php.ini


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

# Update apache config
echo -e "\n--- Configure Apache ---\n"
cat /config/customConfigFiles/default.conf | tee /etc/apache2/sites-available/000-default.conf


# Restarting 
echo -e "\n--- Restarting Apache ---\n"
sudo service apache2 restart

sudo service mysql restart
