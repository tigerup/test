### 1.统计网络状态 80  todo 待验证



```bash
#!/bin/bash
declare -A status
allStatus=`ss -nat|grep 80|cut -d' ' -f1`
#统计结果
for i in $status
do
	let $status[$i]++
done
#打印结果
for i in ${!status[*]}
do
	echo "$i:$status[$i]"
done
```



### 2.

将`/etc/passwd` 按照用户类型分类

```bash
#!/bin/bash

[ -d /tmp/work1 ]|| mkdir /tmp/work1
> /tmp/work1/admin
> /tmp/work1/system
> /tmp/work1/general

while read line
do
    tmp=($(echo $line|tr ':' ' '))
    uid=${tmp[2]}
    if [ $uid -eq 0 ];then
        echo $line >>/tmp/work1/admin
    elif [ $uid -le 999 ];then
        echo $line >>/tmp/work1/system
    else
        echo $line >>/tmp/work1/general
    fi
done < passwd
```



### 3.



### 综合案例

推送公钥到其他服务器：

准备好服务器IP和密码`/tmp/ip.txt`

```ash
10.1.1.99 xxh
10.1.1.66 xxh
```

脚本内容

```bash
#!/bin/bash
echo "Loading..."
#判断公钥是否存在，不存在则创建
[ -f ~/.ssh/id_rsa ] || ssh-keygen -P '' -f ~/.ssh/id_rsa &>/dev/null
#读取文件中IP和密码进行推送
while read ip pass
do
    #判断能否通信，若通信失败则将IP保存到/tmp/faildPush.txt
	ping -c1 $ip &>/dev/null 
	[ $? -eq 1 ] && echo "Failed to push :$ip" >> /tmp/faildPush.txt && continue
	#推送公钥
	/usr/bin/expect <<-EOF &>/dev/null
	set timeout 30
	spawn ssh-copy-id root@$ip
	expect{
		"yes/no" { send "yes\r";exp_continue }
		"password:" { send "$pass\r" } 
	}
	expect eof
	EOF	
	#检测能否成功连接
	
done < /tmp/ip.txt
echo "Finish"
```



### 4.创建用户

②批量创建用户

用户名和密码来自文件

```bash
while read user pass
do 
 useradd $user
 echo $pass|passwd --stdin $user
done < user_pass.file
```

③批量创建用户

批量添加用户并将用户名和**随机数字**密码保存到本地

```bash
#!/usr/bin/env bash
for ((i=1;i<=3;i++))
do
    username="user$i"
    password=$[$RANDOM%9000+1000]
    useradd $username
    echo $password|passwd --stdin $username
    echo "$username:$password" >> /tmp/user_pass.file
done
```



### 5.menu 菜单 todo  待验证

```bash
#!/bin/bash
trap '' 1 2 3 19
menu(){
cat <<-EOF
请选择要操作的主机：
1. Service M2
h. help
q. exit
EOF
}

menu
while true
do
    read -p "请选择要操作的主机[h for help]：" host
    case $host in
        1) ssh root@10.1.1.99 ;;     
        h) clear; menu ;;
        q) exit ;;
    esac
done
```





判断网站能够正常提供服务 todo

```bash
#!/bin/env bash
# 判断门户网站是否能够正常提供服务
#定义变量
web_server=www.itcast.cn
#访问网站
wget -P /shell/ $web_server &>/dev/null
[ $? -eq 0 ] && echo "当前网站服务是ok" && rm -f /shell/index.* || echo "当前网站服务不ok，请立刻
处理
```



## 其他

### 屏蔽信号

trap

```
trap '' 1 2 3 19
```

