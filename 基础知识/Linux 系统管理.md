# Linux 系统管理

## 系统管理 待整理。。

### hostname

> CentOS6查看设置主机名。配置文件: `/etc/sysconfig/network`

- 临时修改：`# hostname  主机名`  注意：`重启失效`
- 永久修改：修改配置文件 `/etc/sysconfig/network`   注意： `重启生效`

主机名需要设置为FQDN（全限定域名），即带有主机名和域名， eg:`LogServer.tigeru.cn`

### hostnamectl

> CentOS7查看设置主机名

设置主机名：`# hostnamectl set-hostname source.tigeru.cn`

### ifconfig

> 查看网络信息。配置文件：`/etc/sysconfig/network-scripts/*`

| 选项 | 全称 | 作用             |
| ---- | ---- | ---------------- |
| -a   | all  | 查看所有网卡信息 |

### ip a

> 查看ip地址

### ping

> 测试能否连接到某个主机

| 选项 | 全称  | 作用                                            |
| ---- | ----- | ----------------------------------------------- |
| -c   | count | 指定ping 次数<br>eg: `# ping -c2 www.tigeru.cn` |

### uname

> 查看系统信息

| 选项 | 全称              | 作用             |
| ---- | ----------------- | ---------------- |
| -r   | kernel release    | 查看内核版本信息 |
| -n   | nodename          | 查看主机名       |
| -s   | kernel name       | 查看内核名称     |
| -i   | hardware platform | 查看硬件信息     |

### uptime

> 输出计算机的持续在线时间

### df

> 查看磁盘挂载及使用信息

### lsblk

> （list block devices）查看当前系统所有设备信息

### free

> 查看内存信息

### ntpdate

> 从ntp服务器同步时间

eg : `# ntpdate cn.ntp.org.cn`

### mount

> 挂载设备

`# mount 设备原始地址 要挂载的位置路径`

设备原始地址统一都在 `/dev/`下（根据文件大小确定设备name），挂载位置建议放在 `/mnt/`下

开机挂载：

修改配置文件 `/etc/fstab`

添加如下内容：

``` powershell
/dev/sr0     /mnt    iso9660 defaults 0 0
```

### umount

> 解除挂载

`# umount 当前设备挂载点`

### sync

> 将缓存数据写入磁盘；刷新文件系统缓存，强制将修改过的数据块写入磁盘，执行速度非常快

