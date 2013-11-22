#!/usr/bin/env bash

# CONFIGURATION VARIABLES
MYSQL_PASSWORD='root'
LARAVEL_PROJECT=true

if [ "$1" == "db" ]; then
DB=true
DBNAME="$2"
else
DB=false
fi

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- MySQL time ---"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_PASSWORD}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_PASSWORD}"

echo "--- Redis time ---"
sudo apt-get install -y redis-server

echo "--- MongoDB time ---"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install mongodb-10gen
sudo /etc/init.d/mongodb start

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties

# echo "--- We want the bleeding edge of PHP, right master? ---"
# sudo add-apt-repository -y ppa:ondrej/php5

# echo "--- Updating packages list ---"
# sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5-dev php5-fpm php5-cli php-pear nginx php5-curl php5-gd php5-imagick php5-mcrypt mysql-server mysql-client php5-mysql git-core
sudo pecl install mongo
sudo sh -c 'echo "extension=mongo.so" >> /etc/php5/fpm/php.ini'

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Setting document root ---"
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www


echo "--- What developer codes without errors turned on? Not you, master. ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini

echo "--- Change Nginx to listen to php5 socket ---"
sed -i "s/listen = 127.0.0.1:9000/listen = \/tmp\/php5-fpm.sock/" /etc/php5/fpm/pool.d/www.conf

echo "--- Replace old default Nginx vhost ---"
sudo rm /etc/nginx/sites-available/default
sudo cp /vagrant/vagrant/nginx-vhost /etc/nginx/sites-available/default

echo "--- Restart Nginx && PHP5-FPM ---"
sudo service php5-fpm restart
sudo service nginx restart

echo "--- Composer is the future. But you knew that, did you master? Nice job. ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

if $DB; then
echo "--- Create database. ---"
mysql --user=root --password="$MYSQL_PASSWORD" -Bse "CREATE DATABASE IF NOT EXISTS \`$DBNAME\` CHARACTER SET utf8 COLLATE utf8_general_ci"
fi

if $LARAVEL_PROJECT; then
# echo "--- Lets make sure the app storage directory is writable. ---"
# chmod -R o+w /vagrant/app/storage
echo "--- Migrate the database for Laravel project ---"
php /vagrant/artisan migrate --env=local
echo "--- Now lets run the db:seed command! ---"
php /vagrant/artisan db:seed --env=local
fi

echo "--- All set to go! Would you like to play a game? ---"
