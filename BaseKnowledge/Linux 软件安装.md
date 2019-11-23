# Linux  软件安装

## 一、软件安装方式

* ### 源码包

> 开源软件，可以修改源代码，可以编译安装成更加适合自己的操作系统的安装文件，稳定高效
>
> 需要进行`配置、编译、安装` 
>
> 缺点是：安装步骤较多，容易出错，编译过程时间较长，还需要解决依赖问题

* ### 二进制包

> 经过编译，不能看源码，安装简单，操作方便，安装速度快
>
> 需要根据计算机CPU及操作系统下载合适的rpm包

命名格式：

`包名-版本号-发布次数-发行商-Linux平台-适合的硬件平台-包扩展名`

eg: `httpd-2.2.15-59.el6.centos.1.i686.rpm`

包名指的是：`httpd`  包全名指的是： `httpd-2.2.15-59.el6.centos.1.i686.rpm`

## 二、rpm

> （Red-Hat Package Manager）软件包管理器，需要解决依赖关系

### 查找rpm包

* 光盘
* 官网
* 正规网站  [http://rpm.pbone.net/](http://rpm.pbone.net/)     http://rpmfind.net/
* 

### 使用

安装：`# rpm -ivh 本地包全名/网络链接`  注意：`软件包名需要使用全称  eg: xlockmore-5.31-2.el6.x86_64.rpm`

卸载：`# rpm -e 包名`  注意：`卸载软件只需要软件名字  eg:xlockmore`

升级：`# rpm -Uvh 包名`或者 `# rpm -Fvh 包名`

| 选项     | 全称    | 作用                                             |
| -------- | ------- | ------------------------------------------------ |
| -i       | info    | 显示套件相关信息                                 |
| -v       | verbose | 显示指令指令性过程                               |
| -h       | hash    | 套件安装时列出标记                               |
| -e       | erase   | `删除`指定套件                                   |
| -U       | upgrade | `升级`软件包，如果该软件没有安装，则`会`自动安装 |
| -F       | freshen | 升级软件包，如果该软件没有安装，则`不会`自动安装 |
| --force  |         | 强制安装或者卸载                                 |
| --nodeps |         | 忽略依赖关系安装或卸载                           |

`-q` 询问模式（query）

| 选项 | 全称 | 作用 |
| ---- | ---- | ---- |
| -qR | requires | 查看依赖包 |
| -qa  | all | 显示所有套件信息                               |
| -qc  | configfiles | 列出`配置`文件                                 |
| -qd  | docfiles | 只列出文本文件，文档                              |
| -qi  | info | 显示套件`详细`信息                             |
| -ql | list | 显示套件文件列表 |
| -qf | file list | 查询拥有指定文件的套件 |
| -qlp | package | 显示未安装rpm包里的文件列表 |

## 三、yum

> （Yellow dog Updater, Modified），是一个基于RPM的软件包管理器，YUM从指定的地方（相关网站的rpm包地址或本地的rpm路径）自动下载RPM包并且安装，并可以`自动处理依赖关系`，安装简单快捷

`yum源`位置：`/etc/yum.repos.d/`

| 功能               | 命令                                |
| ------------------ | ----------------------------------- |
| 搜索软件           | `# yum list`                        |
| 查看已经安装的软件 | `yum list installed`                |
| 查看包组           | `yum grouplist`                     |
| 安装软件           | `# yum install 包名`                |
| 安装本地包         | `# yum localinstall 本地包全名路径` |
| 安装包组           | `# yum groupinstall "组名"`         |
| 卸载包组           | `# yum groupremove "组名"`          |
| 升级软件           | `# yum update 包名`                 |
| 降级安装软件       | `# yum downgrade 包名`              |
| 卸载软件           | `# yum remove 关键词`               |
| 查看软件包信息     | `# yum info 包名 `                  |
| 检查是否有更新包   | `# yum check-update 包名`           |
| 清空yum缓存        | `# yum clean all`                   |
| 创建yum缓存        | `# yum makecache`                   |
| 列出可用的仓库     | `# yum repolist`                    |

| 选项 | 作用              |
| ---- | ----------------- |
| -y   | 不提示，直接`yes` |

`yum list  优先列出高版本软件包  仅列出一个仓库中的软件包`

## 四、源码安装

#### 1.解压源码包

#### 2.查看说明书

`README` 或者`INSTALL`

#### 2.根据需求配置

设置安装路径：`# ./configure --prefix=/安装路径`

#### 3.编译

进入到源码解压目录中执行：`# make -j`

`-j` 使用CPU所有核心编译，也可以指定个数

#### 4.安装

`# make install`

#### 5.卸载

进入到源码解压目录中：

* 卸载安装：`# make uninstall`
* 卸载编译和配置过程 `# make distclean`

## 五、其他

#### 环境变量配置

查看当前系统环境变量配置：`# echo $PATH`

临时添加路径到环境变量：`# export PATH=$PATH:/要添加的目录 `

永久添加：在配置文件`/etc/profile` 最后添加 `export PATH=$PATH:/要添加的目录 ` ，`需要`重新读取配置文件 `# source /etc/profile`

#### man手册配置

在配置文件 `/etc/man.config` 中添加 `MANPATH /man文件位置`