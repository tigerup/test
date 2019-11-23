# Linux  命令概述

> Linux通过命令与系统进行交互，命令输入在终端（shell)中，`Shell` （命令解释器）是一个应用程序，处于用户和核心的之间，起桥梁作用。`Bash`(Bourne Again Shell)是大多数Linux系统默认的`Shell`
>

## 命令构成

![](http://img.tigeru.cn/FqyPEPYfKM2vJvu0YEoFxlsVsyYB)

命令说明：

* `command` 指令名称。例如`cal` 显示日历
* `options` 选项 ,`[]`表示可选，输入选项时前面需要带`-`或者`--` ，`-`后边用缩写（`可以是多个选项的缩写`），`--`后边用完整名称。例如 `cal -y` `cal --year` 输出整年日历
* `parameter1` 参数，可多个参数

> 指令，选项，参数之间使用空格分隔，不管几个空格shell都是视为一格。
>
> 注意：`Linux 区分大小写`
