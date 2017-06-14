#!/bin/sh
# グローバル変数
vagrantPath=/vagrant/www/documentroot
phpMyAdminPath=/vagrant/www/documentroot/phpMyAdmin
mysqlAdd=/etc/my.cnf
phpPath=/etc/php.ini
services=( "wget" "unzip" "git" )

echo "-------------------------------"
echo "DocumentRootのフォルダを作成"
echo "-------------------------------"
echo "DocumentRootフォルダを作成"
if [ -d $vagrantPath ]; then
  echo 'フォルダは存在します。'
else
  echo 'フォルダが存在しないため作成します。Loading Now'
  sudo mkdir -p $vagrantPath
fi

echo "-------------------------------"
echo "system update"
echo "-------------------------------"
sudo yum -y update

echo "-------------------------------"
echo "install other package"
echo "-------------------------------"
sudo yum -y install wget unzip git

echo "-------------------------------"
echo "httpd"
echo "-------------------------------"
if(( $(yum list installed | grep httpd | wc -l) == 0))
then
  echo "-------------------------------"
  echo "install httpd"
  echo "-------------------------------"
  sudo yum -y install httpd httpd-devel
  echo "-------------------------------"
  echo "setting httpd"
  echo "-------------------------------"
  sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.org
  echo -e '\nNameVirtualHost *:80' | sudo tee -a /etc/httpd/conf/httpd.conf
  sudo chmod 755 /home/vagrant
fi

sudo \cp -f /vagrant/setting/httpd/virtualhost.conf /etc/httpd/conf.d/virtualhost.conf

echo "-------------------------------"
echo "function Shell"
echo "-------------------------------"
mysqlFunction()
{
  sudo rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
  sudo rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
  sudo rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
}

echo "-------------------------------"
echo "MySQL"
echo "-------------------------------"
if(( $(yum list installed | grep mysql | wc -l) == 0))
then
  echo "-------------------------------"
  echo "install MySQL"
  echo "-------------------------------"
  mysqlFunction
  sudo yum install -y http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
  sudo yum -y install mysql mysql-server mysql-devel
fi

echo "-------------------------------"
echo "PHP"
echo "-------------------------------"
if(( $(yum list installed | grep php | wc -l) == 0))
then
  echo "-------------------------------"
  echo "install PHP"
  echo "-------------------------------"
  sudo yum install -y --enablerepo=epel libmcrypt
  sudo yum install -y --enablerepo=remi,remi-php55 php php-devel php-pear php-mbstring php-xml php-mcrypt php-gd php-pecl-xdebug php-opcache php-pecl-apcu php-fpm php-phpunit-PHPUnit php-mysqlnd
  sudo yum install -y --enablerepo=remi,remi-php55 phpMyAdmin
  sudo yum -y install php-mysqli
fi

echo "-------------------------------"
echo "phpMyAdmin"
echo "-------------------------------"
if [ -d $phpMyAdminPath ]; then
  echo 'phpMyAdminフォルダは存在します。'
else
  echo "-------------------------------"
  echo "install phpMyAdmin"
  echo "-------------------------------"
  sudo wget https://files.phpmyadmin.net/phpMyAdmin/4.4.15.7/phpMyAdmin-4.4.15.7-all-languages.zip
  sudo unzip phpMyAdmin-4.4.15.7-all-languages.zip
  sudo mv phpMyAdmin-4.4.15.7-all-languages /vagrant/www/documentroot/phpMyAdmin
  sudo mv /vagrant/www/documentroot/phpMyAdmin/config.sample.inc.php /vagrant/www/documentroot/phpMyAdmin/config.inc.php
  sudo chown -R apache /vagrant/www/documentroot/phpMyAdmin
fi

echo "-------------------------------"
echo "symlink DocumentRoot"
echo "-------------------------------"
sudo rm -rf /var/www/html
sudo ln -fs /vagrant/www/documentroot /var/www/html

echo "-------------------------------"
echo "自動起動"
echo "-------------------------------"
sudo service iptables stop
sudo chkconfig iptables off
sudo chkconfig httpd on
sudo /etc/init.d/httpd start

