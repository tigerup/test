# Linux  三剑客

>  Linux三剑客： grep、sed 和 awk 命令

## 一. grep

> 行过滤工具, 从文件中找到包含指定信息的那些行 ，并且使用正则表达式搜索文本 	

### 1语法:

```bash
grep [选项] '关键字' 文件名
```

### 2.常用参数

| 选项   | 描述                               |
| ------ | ---------------------------------- |
| -i     | **忽略大小写**                     |
| -n     | 显示行号                           |
| -w     | 单词匹配，也就是忽略部分匹配       |
| -v     | **不包含**，查找不包含指定内容的行 |
| -E     | 使用扩展正则匹配                   |
| -P     | Perl regular 格式正则              |
| **-o** | **打印匹配到的关键字**             |
| **-c** | 统计匹配到的**行数**               |
| -r     | 逐层遍历目录查找                   |
| -e     | 使用正则匹配                       |

其他：

```bash
-A  #显示匹配行及后面多少行
-B  #显示匹配行及前面多少行
-C  #显示匹配行前后多少行
^key #以key开头的行
key$ #以key结尾的行
```

### 3案例

```bash
#1.匹配以#号开头的行
grep '^#' /etc/rc.local
#2.匹配不以#号开头，并且不知空行的行
grep -vE '^#|^$' /etc/rc.local
#3.显示空行的行数
grep -c '^$' /etc/rc.local
```


## 二、sed

> Stream Editor，流编辑器，不交互编辑文件内容
>
> sed每次仅读取一行内容，把把每一行都存在临时缓冲区中，对这个副本进行编辑，默认并不会直接编辑源文件， 当一行数据匹配完成后，它会继续读取下一行数据，并重复这个过程，直到将文件中所有数据处理完毕 

### 1.语法格式

```bash
sed [options] '处理动作' 文件名
```

### 2常用选项

| 选项   | 描述                             |
| ------ | -------------------------------- |
| -e     | 进行多项编辑，默认选项           |
| -n     | 取消默认输出，不自动打印模式空间 |
| -r     | 使用扩展正则表达式               |
| **-i** | **编辑源文件**                   |
| -f     | 指定sed脚本的文件名              |

注意：使用`-i`时候，不要使用`-n`选项和打印`p`操作

### 3对文件进行操作

进行增删改查

| 动作 | 描述                     |
| ---- | ------------------------ |
| ‘p’  | 打印特定行               |
| ‘d’  | 删除特定行               |
| ‘i’  | 在指定行**之前**插入内容 |
| ‘a’  | 在指定行**之后**插入内容 |
| ‘c’  | 替换指定行               |

**注意：要编辑的行在前，动作在后**

案例

```bash
#1.打印行内容
  #打印第3行到第5行
  sed '3,5p' passwd
  #打印第6行和第8行
  sed '6p;8p' passwd
#2.删除最后一行
sed '$d' passwd
#3.将第3行替换为hello
sed '3i hello' passwd
#4.将第3行到第5号替换为hello
sed '3,5i hello' passwd
#5.将包含 user 的行替换为 test
sed '/user/c test' passwd
```

**注意：使用正则匹配时，需要将表达式使用`/表达式/`包住**

### 4搜索替换

语法格式

```bash
sed [options] 's/要搜索的内容/要替换的内容/动作' 文件
```

案例

```bash
#1.替换root为ROOT
  #仅替换每行第一个root
  sed 's/root/ROOt/p' passwd
  #替换每行所有root
  sed 's/root/ROOt/gp' passwd
  #仅替换第一行
  sed '1s/root/ROOt/gp' passwd
#2.替换 /bin/bash 为 test
  # 取消转义
  sed -n 's/\/bin\/bash/test/gp' passwd
  # 替换分隔符
  sed -n 's#/bin/bash#test#gp' passwd
#3.第1到5添加注释符
  #仅打印,加p
  sed -n '1,5s/^/#/p' passwd
  #修改源文件,注意：不加p
  sed -i '1,5s/^/#/' passwd
#4.删除第1到5注释符
  sed -i '1,5/^#//' passwd
#5.搜索以root开头或者以stu开头的行
  sed -nr '/^root|^stu/p' passwd
  sed -n '/^root/p;/^stu/p' passwd
  sed -ne '/^root/p' -ne '/^stu/p' passwd
#6.删除第一个匹配字符串"root"到第一个匹配字符串"ftp"的所有行本行
  sed '/root/,/ftp/d' file    
```

### 5其他操作

| 选项 | 描述                         |
| ---- | ---------------------------- |
| r    | 从其他文件中读取内容         |
| w    | 内容另存为                   |
| &    | 保存查找到的串，用于后期引用 |
| =    | 打印行号                     |
| ！   | 取反                         |
| q    | 退出                         |

案例：

```bash
#1.读取其它文件
sed '3r /etc/resolv.conf' passwd
#2.另存为
 #保存3到5行内容到 /tmp/1.txt
 sed '3,5w /tmp/1.txt' passwd
 #保存包含 root 的行到 /tmp/2.txt
 sed '/root/w /tmp/2.txt' passwd
#3.打印包含user的行，并打印行号
 sed -ne '/user/=' -ne '/user/p' passwd
#4.打印以root开头到以user（第一个user）开头之间的内容
 sed -n '/^root/,/^user/p' passwd
#5.以root开头的行添加注释符
 sed -n 's/^root/#&/p' passwd
 sed -n 's/^root/#root/p' passwd
 sed -n 's/\(^root\)/#\1/p' passwd
#6.打印不以#开头的行
 sed -n '/^#/!p'  vsftpd.conf
#7.删除空行和注释行
 sed '/^#/d;/^$/d'  vsftpd.conf
```

### 6脚本格式

语法格式

```bash
!/usr/bin/sed -f
command1
command2
```

**注意事项**

①每行为一个sed命令，不需要使用`'`引住
②每行末尾不能有空格，制表符
**案例**

```bash
#!/bin/sed -f
#开始添加 BEGIN
1i BEGIN
#最后添加 END
$a END
#第1到5行添加注释符
1,5s/^/#/
```

**注意：执行顺序为从上到下，所有要注意命令的顺序**

使用：？？？ todo

`sed [选项] -f 脚本路径 要处理的文件 ` 

`./脚本路径 [选项] 要处理的文件 `

## 三、awk

> awk是一种编程语言
>
> 数据处理方式：逐行扫描文件
>
> 用处：处理文件、统计数据

常用选项

| 选项 | 描述                   |
| ---- | ---------------------- |
| -F   | 定义分隔符，默认为空格 |
| -v   | 定义变量并赋值         |

### 1.内部变量

| 变量          | 全称                    | 描述                                 |
| ------------- | ----------------------- | ------------------------------------ |
| `$0`          |                         | 当前处理行所有内容                   |
| `$1,$2,$3,$n` |                         | 以分隔符分割后的每列字段值           |
| `NF`          | number of fields        | 列总长度                             |
| `$NF`         |                         | 最后一列，倒数第二列`$(NF-1)`        |
| `FNR/NR`      |                         | 当前记录所在的行号                   |
| `FS`          | field separator         | 定义**输入字段**分割符               |
| `OFS`         | output field separator  | 定义**输出字段**分割符，默认为空格   |
| `RS`          | record separator        | 定义**输入记录行**分隔符，默认为换行 |
| `ORS`         | output record separator | 定义**输出记录行**分隔符，默认为换行 |
| `FILENAME`    |                         | 当前输入的文件名                     |

更多：`man awk`

#### 案例

```bash
#1 打印文件所有内容
awk '{print}'  passwd
#打印第5行到第10行
awk 'NR==5,NR==10{print}' passwd
#3.打印包含root或者lp行的地一列和第6列内容，以：分隔
awk -F: '/root|lp/{print $1,$6 }' 1.txt
#4.定义输入分割符为“:” 输出分隔符为“@”
awk -F: 'BEGIN{FS=":";OFS="@"};{print $1,$2}' passwd
#5.定义输出行分割符为“\n\n”
awk -F: 'BEGIN{ORS="\n\n"};{print $0}' passwd
```

### 2.工作原理

①一行行地处理，直到结束，通过`RS`分割行

②每行为一个记录，存储在变量`$0`中，

③每行通过`FS`分割字段，并分别存放在`$1,$2,$3,$n`中，

④输出每行字段是通过`,`分隔，`,`表示`OFS`

⑤输出每行以`ORS`结束

### 3.pirnt

```bash
#1.换行打印月份和年份
date |awk '{print "Month: "$2 "\nYear: "$NF}'
#2.打印用户名和UID
awk -F: '{print "username:"$1 "\t uid:"$3}' passwd
```

### 4printf 

> 格式化输出

```bash
awk -F: '{printf "%-15s %-10s %-15s\n", $1,$2,$3}' /etc/passwd
awk -F: '{printf "|%15s| %10s| %15s|\n", $1,$2,$3}' /etc/passwd
awk -F: '{printf "|%-15s| %-10s| %-15s|\n", $1,$2,$3}' /etc/passwd

# %s 字符类型
# %d 数值类型
# num 表示长度
# - 表示左对齐，默认右对齐
```

**注意：printf默认不会在行尾自动换行，需要添加`\n`**

### 5.BEGIN END

①BEGIN : 在程序开始前执行

②END : 在所有操作执行完成后执行

语法：

```bash
awk 'BEGIN{};{};END{}' 
```

案例

格式化输出`passwd`中用户名、家目录、shell

```bash
awk -F: 'BEGIN{print "u_name\t\t\t h_dir\t\t\t shell\n***************************************************************"};{printf "%-20s %-20s %-20s*\n", $1,$6,$7}END{print "***************************************************************"}' /etc/passwd
```

### 6awk和正则

特殊符号：

* `~` ：匹配
* `!~`：不匹配

案例

```bash
#1.截取IP地址
ifconfig ens33|awk -F'[ ]+' 'NR==2{print $3}'
#2.显示可以登录到系统的用户名
awk 'BEGIN{FS=":"}/bash/{print$1}' /etc/passwd
#3.打印3-8行以bash结尾的内容
awk 'NR>=3 && NR<=8 && $0 ~ /sync$/{print $0}' /etc/passwd
awk 'NR>=3 && NR<=8 && /sync$/' /etc/passwd
#4.显示5-10行
awk -F':' 'NR>=5 && NR<=10 {print $0}' /etc/passwd
awk -F: 'NR>=5 && NR<=10 {print $0}' passwd
```

### 7.awk脚本编程

语法结构

```bash
awk 选项 '{if(条件) {要执行的操作}}'
```

案例 ??

```bash
#1.打印管理员
awk -F: '{if($3==0) {print $1 " is admin"}}' /etc/passwd
#2.打印非管理员
awk -F: '{if($3!=0) {print $1 " is not admin"}}' /etc/passwd
#3.判断当前用户是否是管理员
awk 'BEGIN{if('$(id -u)'==0) {print " is admin"} else{print " is not admin"} }'
```

条件判断

语法：

```bash
{ if(表达式1)｛语句;语句；...｝else if(表达式2)｛语句;语句；...｝else if(表达式3)｛语句;语句；...｝
else｛语句;语句；...｝}
```

案例

```bash
#1.打印系统中普通用户
awk -F: '{if( $3>=1000 && $3!=65534) print $1,$3}' /etc/passwd
  #格式化输出
awk -F: 'BEGIN{print "UID\tUSERNAME"} {if($3>=1000 && $3 !=65534 ) {print $3"\t"$1} }' /etc/passwd
#2.统计用户数量
 awk -F: '{if($3==0) {i++} else if($3<=999){j++} else {k++} };END{print "管理员:"i"\n系统用户:"j"\n普通用户:"k}' /etc/passwd
```

循环

```bash
#for
awk 'BEGIN{for(i=1;i<=5;i++){print i}}'
awk 'BEGIN{for(i=1;i<=5;i++){sum+=i};print sum}'
#while
awk 'BEGIN{ i=1; while(i<=5) {print i;i++}} '
awk 'BEGIN{ i=1; while(i<=5) {sum+=i; i++} {print sum}}'
#循环嵌套
awk 'BEGIN{for(i=1;i<=5;i++) {for(j=1;j<=i;j++) {printf j} ;print } }'
#99乘法口诀表
awk 'BEGIN{for(i=1;i<=9;i++) {for(j=1;j<=i;j++) {printf i"*"j"="i*j" "} ;print } }'
```

### 8.案例

```bash
#1.统计系统各个Shell个数
awk -F: '{ shells[$NF]++ };END{for (i in shells) {print i,shells[i]} }' /etc/passwd
#2.统计网站访问状态
ss -antp|grep 80|awk '{states[$1]++};END{for(i in states){print i,states[i]}}'
ss -antp|grep :80 |awk '{states[$1]++};END{for(i in states){print i,states[i]}}' |sort -k2 -nr
```

## 四、文本处理工具

### 1. cut

> 列截取

| 选项 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| -c   | 截取指定位置字符，eg `-c4`、`-c1-3`、`-c5-`                  |
| -d   | 自定义分隔符，默认为 `\t`                                    |
| -f   | 获取指定列内容，一般结合`-d`使用，eg: `-d: -f1`、`-d: -f1,3,5` |

```bash
 # 练习1：获取系统运行级别编号
 tail -1 /etc/inittab | cut -c4
 grep -v '^#' /etc/inittab | cut -d: -f2
 # 练习2：冒号分割，截取第1,6列内容
 cut -d: -f1,6 test.txt
 # 练习3：截取文件中每行的3-5个字符
 cut -c3-5 test.txt
```

### 2. sort

> 用于排序，它将文件的每一行作为一个单位  

| 选项 | 描述                           |
| ---- | ------------------------------ |
| -u   | 取出重复行                     |
| -r   | 降序排序，默认为升序           |
| -n   | 以数字排序，默认是按照字符排序 |
| -t   | 分隔符                         |
| -k   | 第几列                         |
| -b   | 忽略前导空格                   |
| -R   | 随机排序                       |

```bash
# 练习1：按照用户uid进行升序排序
sort -n -t: k3 /etc/passwd
# 练习2：按照数字排序并且去重
sort -nu 1.txt
```

### 3. uniq

> 去除`连续`重复行

| 选项 | 描述           |
| ---- | -------------- |
| -i   | 忽略大小写     |
| -c   | 统计重复行次数 |
| -d   | 只显示重复行   |

### 4. tee

> 双重覆盖重定向（屏幕输出，文件输入）

例如： `# echo 'test' | tee test.txt`

### 5. diff

> 找不同，显示的结果为，怎样改变第一个使它成为第二个文件	

**比较文件内容**：`# diff [选项] file1 file2`

| 选项     | 描述             |
| -------- | ---------------- |
| -b       | 不检查空格       |
| -B       | 不检查空白行     |
| -i       | 不检查大小写     |
| -w       | 忽略所有空格     |
| --normal | 默认显示格式     |
| -c       | 上下文格式显示   |
| **-u**   | **合并格式显示** |

**比较目录内容**：`# diff dir1 dir2`

加选项 `-q`  可以只比较文件是否缺少，而不比较文件内容

**打补丁**

比较不同直接进行修改

```bash
#1.找出不同，导出一个文件
# -N:表示将不存在的文件当做空文件
diff -uN file1 file2 > file.patch
#2.打补丁
patch file1 file.patch
```

### 6.paste

> 合并文件行

| 选项 | 描述                      |
| ---- | ------------------------- |
| -d   | 自定义间隔符，默认是`tab` |
| -s   | 串行处理                  |

### 7. tr

> 字符替换、删除，**一般用于删除文件中的控制字符**
>
> 注意：**是针对单个单个字符进行操作**

| 选项 | 描述                                 |
| ---- | ------------------------------------ |
| -d   | 删除匹配到的字符                     |
| -s   | 删除重复出现的字符，**只保留第一个** |

用法：

```bash
#1.命令执行结果交给tr处理			
commands | tr 'string1' 'string2' 
#2.tr处理的内容来自文件
tr 'string1' 'string2' <filename
```

实例：

```bash
#1.小写字母变为大写字母
tr 'a-z' 'A-Z' < test.txt
#2.删除文件中的 :和/
tr -d '[:/]' < test.txt
#3.删除文件中的 :和/
cat test.txt | tr -d '[:/]'
#4.将所有的小写字母替换成大写
tr '[a-z]' '[A-Z]' < test.txt
#5.将所有的 : 替换为 |
tr ':' '|' < test.txt
```

## 五、案例

1.过滤IP

```bash
ifconfig ens33|awk -F'[ ]+' 'NR==2{print $3}'
ifconfig ens33|grep -Eo 't (.*) n'|tr -d  '[a-z ]'
ifconfig ens33|sed -n '2p'|sed 's/.*inet \(.*\) netmask.*/\1/'
```

待补充!!!