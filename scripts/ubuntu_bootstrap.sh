#!/usr/bin/env bash

#########################  C O N F I G U R A T I O N  #########################
source /vagrant/ubuntu.conf
###############################################################################

# set timezone
sudo timedatectl set-timezone $TIMEZONE

# supress irrelevant stdin errors
sudo sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
sudo ex +"%s@DPkg@//DPkg" -cwq /etc/apt/apt.conf.d/70debconf
sudo dpkg-reconfigure debconf -f noninteractive -p critical

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install unzip; this may come handy later on
sudo apt-get install -y unzip

# install Apache 2
sudo apt-get install -y apache2

# enable mod_rewrite & mod_headers
sudo a2enmod rewrite
sudo a2enmod headers

# install PHP
echo | sudo add-apt-repository ppa:ondrej/php
sudo apt-get install -y php libapache2-mod-php php-dev php-pear php-json php-mysql php-xml php-intl php-gd php-curl php-mbstring php-soap

curl php7.3-mbstring php7.3-soap

sudo phpenmod mbstring

# configure php: display_errors = On, opcache.enable=0
sudo sed -i -e 's/display_errors = Off/display_errors = On/g' /etc/php/7.?/apache2/php.ini
sudo sed -i -e 's/;opcache.enable=0/opcache.enable=0/' /etc/php/7.?/apache2/php.ini
# set memory_limit
if [[ "$PHP_MEMORY_LIMIT" != "128M" ]]; then
  sudo sed -i -e 's/memory_limit = 128M/memory_limit = '"$PHP_MEMORY_LIMIT"'/' /etc/php/7.?/apache2/php.ini
fi

# install NDL-Vufind2
if [ "$INSTALL_VUFIND2" = true ]; then
  source /vagrant/scripts/ubuntu_vufind2.sh;
fi

# restart Apache
sudo service apache2 reload

# additional installs
if [ "$INSTALL_ORACLE_CLIENT" = true ]; then
  source /vagrant/scripts/ubuntu_oracle.sh
fi
if [ "$INSTALL_SOLR" = true ]; then
  source /vagrant/scripts/ubuntu_solr.sh
fi
if [ "$INSTALL_RECMAN" = true ]; then
  source /vagrant/scripts/ubuntu_recman.sh
fi
if [ "$INSTALL_SIZZY" = true ]; then
  source /vagrant/scripts/ubuntu_sizzy.sh
fi
