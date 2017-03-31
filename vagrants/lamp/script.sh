#!/bin/bash
# Author- Alexandre Chatiron

# Variables
DBPASSWD=root

echo -e "\n--- Installing now... ---\n"

# Updating repository

echo -e "\n--- Updating packages list ---\n"
sudo apt-get update -y 

# Installing Apache

sudo apt-get install -y apache2

echo -e "\n--- Setting document root to public directory ---\n"
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant /var/www/html
fi

# Installing MySQL and it's dependencies, Also, setting up root password for MySQL as it will prompt to enter the password during installation
echo -e "\n--- Install MySQL phpmyadmin specific packages and settings ---\n"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

sudo apt-get install -y mysql-server

# Installing PHP and it's dependencies
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

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
