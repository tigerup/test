#!/bin/bash
#Desc:安装Nginx
#Tip：该脚本需要跟软件包在同一目录并确保软件名完全正确

nginx="nginx-1.12.2"

#1.添加www用户
useradd -r -s /sbin/nologin www
#2.安装依赖
yum -y install pcre-devel zlib-devel openssl-devel
#3.解压源码
tar -xf $nginx.tar.gz
cd $nginx
#4.配置
./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module
#5.编译并安装
make && make install
#6.进入Nginx安装目录
cd /usr/local/nginx
#7.过滤掉注释行和空行
grep -Ev '#|^$' conf/nginx.conf.default > conf/nginx.conf
#8.启动
sbin/nginx -c conf/nginx.conf