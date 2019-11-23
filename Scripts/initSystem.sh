#!/bin/bash

#功能菜单
menu(){
clear
cat <<-EOF
************系统初始化配置***********
 1.设置主机名                      
 2.设置IP                         
 3.更新时间
 4.epel
 q:退出
 ?:帮助
************************************
EOF
}

#1.配置主机名
setHostname(){
    read -p "Please input hostname:" hostname
    hostnamectl set-hostname $hostname
    su
}

#2.配置IP
setIP(){ 
    read -p "Please input ip:" ip
    sed -i "s/^IPADDR.*/IPADDR=$ip/" /etc/sysconfig/network-scripts/ifcfg-ens33
    echo "Loading....."
    service network restart &>/dev/null
    echo "Edit successfully"
}

#3.更新时间
setDateTime(){
    yum install ntpdate &>/dev/null
    echo "Loading....."
    ntpdate cn.ntp.org.cn &>/dev/null
    echo "Current time :$(date)"
}

#4.安装epel 
setEpel(){
    rpm -ivh  http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm &>/dev/null
    yum makecache
}

menu
while true 
do
    read -p "请输入想要进行的操作(?):" command
    case $command in
        1) setHostname ;;
        2) setIP ;;
        3) setDateTime ;;
        4) setEpel ;;
        q) exit ;;
        ?) menu ;;
        *) menu ;;
    esac
done
