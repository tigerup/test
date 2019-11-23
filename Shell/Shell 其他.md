# Shell 补充

## 一、随机数

>  `$RANDOM`
>
>  默认随机产生`0~32767`

### 语法

```shell
#产生0~1之间的随机数
echo $[$RANDOM%2]
#产生0~6之间的随机数
echo $[$RANDOM%7]
#产生0~55之间的随机数
echo $[$RANDOM%56]
#产生50~60之间的随机数
echo $[$RANDOM%11+50]
#产生50~90之间的随机数
echo $[$RANDOM%41+50]
#规律：第一个数为最大值(90)减去最小值(50)加1，第二个数为最小值(50)
```

### 案例

①随机产生1000个以139开头的号码

```shell
#!/bin/env bash
> /tmp/phonenum.txt
for ((i=1;i<=1000;i++));do
    num=""
    for ((j=1;j<=8;j++));do
      num+=$[$RANDOM%10]
    done
    echo "139$num" >> /tmp/phonenum.txt
done

# uniq /tmp/phonenum.txt |wc -l
```

## 二、Expect

> 实现自动交互，捕获屏幕输出，再进行对用输入

### 脚本格式

使用：`# except -f 脚本路径`

语法格式

```bash
#!/usr/bin/expect
spawn ssh root@10.1.1.1
expect {
	"(yes/no)?" { send "yes\r";exp_continue }
	"password:" { send "xxh\r"}
}
#交互 
interact 
#结束
#expect eof
```

接收参数

```bash
#!/usr/bin/expect
#定义第一个参数变量
set ip [ lindex $argv 0 ]
#定义第二各参数变量
set pass [ lindex $argv 2 ]
#定义变量
set test "test"
#定义超时时间，也就是等待程序响应的最长时间
set timeout 10

spawn ssh root@$ip
expect {
	"(yes/no)?" { send "yes\r";exp_continue }
	"password:" { send "$pass\r"}
}
#交互
interact
#结束
#expect eof
```

### 案例：

1.在指定服务器上清空`/tmp/*`  并创建文件`/tmp/1.txt`

```shell
#!/bin/bash
read -p "Please input username:" name
read -p "Please input server ip:" ip

/usr/bin/expect<<-EOF
spawn ssh $name@$ip
expect {
    "yes/no" { send "yes\r";exp_continue}
    "password:" { send "$pass\r" }
}
expect "#"
send "rm -rf /tmp/* \r"
send "touch /tmp/1.txt \r"
send "exit \r"
expect eof
EOF
```

2.myql 安全初始化 

```bash
#!/bin/bash
cd /usr/local/mysql
/usr/bin/expect <<-ww 
spawn mysql_secure_installation
expect {
    "none"          {send "\r";exp_continue}
    "Y/n"      {send "y\r";exp_continue}
    "New password"  {send "123\r";exp_continue}
    "Re-enter new password" {send "123\r";exp_continue}
    "Y/n"         {send "y\r";exp_continue}
    "Y/n"      {send "n\r";exp_continue}
    "Y/n"            {send "y\r";exp_continue}
    "Y/n"           {send "y\r";exp_continue}
    }
    expect eof
ww
```

## 三、并发执行

```shell
{

}&
wait
```

检测局域网内主机通讯使用**并发执行**

```shell
#!/bin/env bash
baseip=192.168.15
for i in {1..254};do
{
    ip=$baseip.$i
    ping -c1 $ip &> /dev/null
    [ $? -eq 0 ] && echo "$ip" >> /tmp/ip_up.txt || echo "$ip" >> /tmp/ip_down.txt
}&
done
wait
echo "Detection completed"
```

## 四、小工具

### time

统计脚本执行完成所需要的时间

```shell
time ./脚本名
```
