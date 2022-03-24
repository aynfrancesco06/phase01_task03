#!/bin/bash
# Please do not remove this line. This command tells bash to stop executing on first error. 
set -e

# Your code goes below ...
echo 'This script should install and setup Wordpress'

#run as root
sudo su

# Install Dependencies for Wordpress
sudo apt-get update
sudo apt-get install -y apache2 \
                 -y ghostscript \
                 -y libapache2-mod-php \
                 -y mysql-server \
                 -y php \
                 -y php-bcmath \
                 -y php-curl \
                 -y php-imagick \
                 -y php-intl \
                 -y php-json \
                 -y php-mbstring \
                 -y php-mysql \
                 -y php-xml \
                 -y php-zip

#Install Wordpress
sudo mkdir -p /var/www
sudo chown www-data: /var/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C var/www

#Configure Apache for Wordpress
touch /etc/apache2/sites-available/wordpress.conf
cat << EOF > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    DocumentRoot /var/www/wordpress
    <Directory /var/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

#Enable the site with:
sudo a2ensite wordpress

#Enable URL rewriting with:
sudo a2enmod rewrite

#Disable the default "It Works" site with:
sudo a2dissite 000-default

# reload apache2
sudo service apache2 reload

#Configure database
#mysql -u root -e "CREATE DATABASE 'wordpress'"
#mysql -u root -e "CREATE USER 'wordpress@localhost' IDENTIFIED BY 'minishcap123'"
#mysql -u root -e GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER  'wordpress'"

