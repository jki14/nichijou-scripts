## [A] CHANGE HOSTNAME
hostname devil
vi /etc/hosts
vi /etc/sysconfig/network
hostname

## [B] MOUNT DISK PARTITION
blkid
vi /etc/fstab
mkdir /mnt/data

## [C] USERADD
useradd -m -s /bin/bash jki14
passwd jki14

## [+] YUM UPDATE
yum update

# --------REBOOT--------

## [D] INSTALL MYSQL 5.6
yum list installed | grep mysql
yum erase mysql-libs
cd /home/jki14
wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
rpm -ivh mysql-community-release-el6-5.noarch.rpm
yum install mysql-server
mkdir /var/log/mysql
chown mysql.mysql /var/log/mysql
chown -R mysql.mysql /mnt/sql/mysql
vi /etc/my.cnf
/etc/init.d/mysqld start
mkdir /var/lib/mysql
ln -s /var/run/mysqld/mysqld.sock /var/lib/mysql/mysql.sock
chown -R mysql.mysql /var/lib/mysql
mysql_secure_installation
chkconfig mysqld on

## [E] INSTALL PHP 5.5
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
yum install php55w php55w-common

## [F] INSTALL NGINX
yum install nginx
yum install php55w-fpm php55w-mysqlnd
vi /etc/php.ini 
# cgi.fix_pathinfo=0
# date.timezone = Asia/Hong_Kong
vi /etc/php.ini
# mysql.default_socket = /var/run/mysqld/mysqld.sock
# mysqli.default_socket = /var/run/mysqld/mysqld.sock
# pdo_mysql.default_socket = /var/run/mysqld/mysqld.sock
vi /etc/php-fpm.d/www.conf
# user = nginx
# group = nginx
service php-fpm restart
vi /etc/nginx/nginx.conf
# worker_processes 4;
service nginx restart
chkconfig php-fpm on
chkconfig nginx on

#[G] INSTALL APACHE
yum install httpd
vi /etc/httpd/conf/httpd.conf
chkconfig httpd on

#[H] UPDATE DNS
vi /etc/sysconfig/network-scripts/ifcfg-eth0
#DNS1=223.5.5.5

#[G] CHECK DNS
cat /etc/resolv.conf
