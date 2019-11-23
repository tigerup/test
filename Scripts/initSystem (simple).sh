#!/bin/bash
#Desc:系统初始化，修改主机名与IP，并更新时间,配置Hosts

#接收用户输入
read -p "Please input hostname:" hostname
read -p "Please input ip:" ip
 
#配置主机名
hostnamectl set-hostname $hostname.tigeru.cn
#配置IP
sed -i "s/^IPADDR.*/IPADDR=10.1.1.$ip/" /etc/sysconfig/network-scripts/ifcfg-ens33
service network restart
#更新时间
yum install ntpdate &>/dev/null
ntpdate cn.ntp.org.cn
#配置Hosts
echo "10.1.1.$ip $hostname $hostname.tigeru.cn" >> /etc/hosts

echo "Initialization successful"
su