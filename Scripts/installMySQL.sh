#!/bin/bash
#Decs:安装 MySQL
#Tip：该脚本需要跟软件包在同一目录并确保软件名完全正确

mysql="mysql-5.6.35-linux-glibc2.5-x86_64"

#1.解压安装包
tar -zvxf $mysql.tar.gz
#2.移动到安装目录 /usr/local/mysql
mv $mysql /usr/local/mysql
#3.创建mysql账号
useradd -r -s /sbin/nologin mysql
#4.分配安装目录权限
chown -R mysql.mysql /usr/local/mysql
#5.进入安装目录
cd /usr/local/mysql 
#6.删除 mariadb-libs 数据库 
yum remove mariadb-libs -y 
#7.初始化数据库vim
scripts/mysql_install_db --user=mysql
#8.将服务添加到 /etc/init.d/ 目录下
cp support-files/mysql.server /etc/init.d/mysql
#9.启动 mysql 服务
service mysql start
#10.配置环境变量
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
source /etc/profile