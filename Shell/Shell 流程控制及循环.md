# Shell 流程控制及循环

## 一、条件判断

注意：`0表示true`    `1表示false`

### 1.语法格式

* test 条件表达式
* [ 条件表达式 ]
* [[ 条件表达式 ]]    (支持正则，支持嵌套`&&`)

**注意：使用`[ ]` 时，两边必须有空格**

### 2.判断文件类型

| 参数   | 描述               |
| ------ | ------------------ |
| **-e** | 判断文件是否存在   |
| -f     | 是否是普通文件     |
| -d     | 是否是目录         |
| -L     | 是否是软连接文件   |
| -b     | 是否是块设备文件   |
| -S     | 是否是套接字文件   |
| -c     | 是否是字符设备文件 |
| -p     | 是否是命令管道文件 |
| **-s** | 判断文件是否有内容 |

**注意：所有的判断都会先判断文件是否存在，若不在则`flase`**

案例：

```bash
# 1.判断/tmp/dir5是否存在，不存在则创建
test ! -d /tmp/dir5 && mkdir /tmp/dir5
# 2.判断/tmp/file2 文件内容是否为空，若为空则删除
test ! -s /tmp/file2 && rm -f /tmp/file2
```

### 3.判断文件权限

| 参数 | 描述                 |
| ---- | -------------------- |
| -r   | 对当前用户是否可读   |
| -w   | 对当前用户是否可写   |
| -x   | 对当前用户是否可执行 |
| -u   | 是否有`suid`,冒险位  |
| -g   | 是否有`sgid`，强制位 |
| -k   | 是否有`t`位，粘滞位  |

案例：

```bash
#1.判断 /etc/rc.d/rc.local 是否具有可执行权限，没有则加上
test -x /etc/rc.d/rc.local || chmod +x /etc/rc.d/rc.local
```

### 4.判断文件新旧

| 参数              | 描述                                         |
| ----------------- | -------------------------------------------- |
| file1 `-nt` file2 | 比较file1是否比file2新                       |
| file1 `-ot` file2 | 比较file1是否比file2旧                       |
| file1 `-ef` file2 | 比较是否为同一文件，一般用于判断是否为硬链接 |

### 5.判断整数

| 参数  | 全称         | 描述     |
| ----- | ------------ | -------- |
| `-eq` | equal        | 等于     |
| `-ne` | no equal     | 不等于   |
| `-gt` | greater than | 大于     |
| `-lt` | less than    | 小于     |
| `-ge` | great equal  | 大于等于 |
| `-le` | less equal   | 小于等于 |

### 6.判断字符串

| 参数         | 描述                                      | 备注    |
| ------------ | ----------------------------------------- | ------- |
| -z           | 判断是否为`空`字符串，当长度为0则成立     | zero    |
| -n           | 判断是否为`非空`字符串，当长度不为0则成立 | nonzero |
| str1 = str2  | 判断字符串是否相等，比较的是内容          |         |
| str1 != str2 | 判断字符串是否不相等，比较的是内容        |         |

```bash
[ $a = $b ];echo $?

[ "$a" == "$b" ];echo $?
```

### 7.多重条件判断

| 参数         | 描述   | 举例                                                   |
| ------------ | ------ | ------------------------------------------------------ |
| -a 或者 &&   | 逻辑与 | [ 1 -eq 1 -a 1 -ne 0 ]<br>[ 1 -eq 1 ] && [ 1 -ne 0 ]   |
| -o 或者 \|\| | 逻辑或 | [ 1 -eq 1 -o 1 -ne 1 ]<br>[ 1 -eq 1 ] \|\| [ 1 -ne 1 ] |

`&&` : 左边为`true`，则执行右边

`||` ：左边为`flase` ，则执行右边

### 8.类C风格

格式： `(( ))`

注意：`=`表示赋值； `==`表示判断是否相等

```bash
((1==2))
((1!=2))
((1>=2))
((1<=2))
((1>2))
```

## 二、流程控制

**注意: `if`结尾要加 `fi`    条件后要加`;then`**

### 1. if

```bash
if [ condition ];then
    command
fi
```

### 2. if else

```bash
if [ condition ];then
      command1
else
      command2
fi
```

### 3. if elif else 

注意：不管有几个条件，只有一个条件中的内容会执行

```bash
if [ condition ];then
    command1
elif
	command2
else 
	command3
fi
```

### 4.案例

**案例1**

判断用户是否存在

```bash
#!/bin/env bash
read -p "Please input user name:" name
id $name &> /dev/null
[ $? = 0 ] && echo "This user exists" || echo "This user does not exists"
```

**案例2**

判断当前内核主版本是否为3，且次版本是否大于等于6；如果都满足则输出当前内核版本

```bash
#!/bin/env bash
num1=`uname -r|cut -d. -f1`
num2=`uname -r|cut -d. -f2`
[ $num1 -eq 3 ] && [ $num2 -ge 6 ] && echo $(uname -r)
```

**案例3**

判断网页能否正常访问

```bash
#!/bin/env bash
read -p "Please input the website:" website
wget -P /tmp/ $website &>/dev/null
[ $? -eq 0 ] && echo "success" && rm -f /tmp/index.* || echo "failed"
```

**案例4**

判断能否Ping通：

```bash
#/usr/bin/env bash
read -p "Please input an ip:" ip
echo "Loading ..."
ping -c 3 $ip &> /dev/null
[ $? -eq 0 ] && echo "Ping successfully" || echo "Ping failed"
```

**案例5**

判断`/tmp/run`目录是否存在，如果不存在就建立，如果存在就删除目录里所有文件

```bash
#!/bin/env bash
[ -d /tmp/run ] && rm -rf /tmp/run/* || mkdir /tmp/run
```

## 三、循环

### 1.for

#### (1)列表循环

```shell
for variable in {list}
do
   	command
done
```

Example:

```shell
for index in {1..10..3};do echo  "$index Test "; done
```

#### (2)不带列表循环

由用户指定参数，循环的内容是所有参数

```shell
for variable
do
	command
done
```

#### (3)类C风格

```shell
for (( expr1;expr2;expr3))
#for (( i=1;i<=10;i++ ))
do
	command
	...
done
```

#### (4)案例

**①计算奇数和**

计算1到100之间所有奇数和

```shell
#!/bin/env bash
declare -i sum=0
for i in {1..100..2};do
        sum+=$i
done
echo "Sum is $sum"
```

**②批量创建用户**

用户名为u{1.5}，所有用户密码为123，属组统一为class

```shell
#!/bin/env bash
groupadd class
for i in {1..5};do
	useradd u$i -G class
	echo 123|passwd --stdin u$i &>/dev/null
done
```

**③检测局域网内主机通讯**

将`192.168.15.0`网段内所有能Ping通的IP放到`/tmp/1.txt`，Ping不通的IP放到`/tmp/2.txt`

```shell
#!/bin/env bash
baseip=192.168.15
for i in {1..254};do
    ip=$baseip.$i
    ping -c1 $ip &> /dev/null
    [ $? -eq 0 ] && echo "$ip" >> /tmp/1.txt || echo "$ip" >> /tmp/2.txt
done
echo "Detection completed"
```

方法2：

```shell
 # ping扫描
 yum install nmap
 nmap -sP 192.168.15.0/24 > /tmp/result.txt
 cat /tmp/result.txt |grep ^Nmap
```

### 2.while

> 满足循环条件则循环，不满足循环条件则退出

#### (1)语法结构

```
while [ condition ]
do
    command
    ...
done
```

#### (2)案例

**①输出1到10**

```shell
#!/bin/env bash
i=1
while (($i<=10));do
    echo $i
    let i++
done
```

**②计算奇数和**

计算1到50之间所有奇数的和

```shell
#!/bin/env bash
i=0
sum=0
while [ $i -le 50 ]
do
    [ $[i%2] -eq 1 ]&& echo $i && let sum+=$i
    let i++
done
echo "Sum is $sum"
```

### 3. until

> 不满足循环条件则循环，满足循环条件则退出

#### (1)语法结构

```shell
until [ condition ]
do
    command
    ...
done
```

#### (2)案例

输出1到10

```shell
#!/bin/env bash
i=1
until [ $i -gt 10 ]
do
   echo $i
   let i++
done
```

### 4.循环控制语句

`continue` ：跳过本次循环，执行下次循环

`break`：跳出循环，不再执行循环

`shift`：使位置参数向左移动，默认移动1位

`exit`：退出程序

### 5、嵌套循环

乘法口诀表

```shell
#!/bin/env bash
for ((i=1;i<=9;i++));do
    for ((j=1;j<=i;j++));do
       echo -n "$j*$i=$[$i*$j] "
    done
    echo
done
```

## 四、case

### 1.语法结构

```bash
case var in 
pattern 1)     
	command
	;;
pattern 2|parttern3)  #可以使用|添加多个表达式
	command
	;;
*) 				#default
	command
	;;
esac
```

### 2.案例

根据输入等级输出对应分数范围

```bash
#!/bin/bash
read -p "Please input an leve(A-E)" level
case $level in
A) echo "90~100" ;;
B) echo "80~90" ;;
C) echo "70~80" ;;
D) echo "60~70" ;;
E) echo "50~60" ;;
*) echo "0~50" ;;
esac

# 方法2： 使用关联数组
#read -p "Please input an level(A-E):" level
#declare -A  score
#score=([A]='90~100' [B]='80~90' [C]='70~80' [D]='60~70' [E]='50~60')
#ho ${score[$level]}
```


