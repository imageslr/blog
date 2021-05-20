---
layout: post
title: 📔【计算机网络】两台主机的通信过程
date: 2021/5/18 16:00
last_modified_at: 2021/5/18
typora-root-url: ../
typora-copy-images-to: ../media
---

> 更多面试题总结请看：[🗂【面试题】技术面试题汇总]({%post_url 2020-07-08-tech-interview%})



## 前言

本文通过在实际场景中执行命令，来深入了解两台主机之间的通信过程。阅读完本文，我们应当能够回答以下两个问题：

* 通过 HTTP 协议访问一台远程服务器的时候发生了什么？
* 在局域网内 `ping` 另一台主机的时候发生了什么？

本文也是[从输入一个 URL 到页面加载完成的过程]({% post_url 2020-02-26-what-happens-when-you-type-in-a-url %})的另一个角度的回答。

## 准备 Docker 环境

本文在 Docker 容器中进行实验，以获得干净、一致的体验。请前往[官网下载](https://docs.docker.com/get-docker/) Docker 的安装包。关于 Docker 的基础概念 (容器、镜像等)，可以阅读阮一峰的 [Docker 入门教程](http://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html)。下文将描述如何配置实验所需的 Docker 环境、以及相关的命令。

### 下载镜像

在启动 Docker 容器之前，我们需要先下载一个 Docker 镜像。这里使用 Ubuntu 系统镜像：

```
# docker pull <image>
docker pull ubuntu
```

### 首次启动

从镜像初始化并进入容器：

```
# docker run -it --name <container> <image>
docker run -it --name ubuntu ubuntu 
```

参数说明：

* `-i`：让容器的标准输入保持打开，从而能够接受主机输入的命令。
* `-t`：为容器分配一个伪终端并绑定到容器的标准输入上。`-i` 和 `-t` 结合，可以在终端中和容器进行交互。
* `--name`：为容器起一个名字，方便后续操作该容器，否则每次都需要查找容器的 `ContainerID`。

需要注意的是，每次 `run` 都会重新创建一个新的容器。后续我们使用 `start` 命令来进入已有的容器，见[下文](#docker-start)。

**注意**：在 Docker 的各个命令中，\<container_id> 和 \<container_name>、\<image_id> 和 \<image_name> 可以互换，本文统一使用 \<container> 和 \<image> 来指代这些参数。
{: .ant-alert .ant-alert-info}

### 配置环境

在容器内执行以下命令，安装必要的工具：

```
apt-get update
apt-get install net-tools tcpdump iputils-ping
```

安装完成后，`exit` 退出容器。

### 提交镜像

如果不小心删除了容器，容器内的所有更改也将丢失。因此，我们使用 `commit` 命令来保存容器中的更改：

```
# docker commit -m <message> --author <author_info> <container> [<repo>[:<tag>]]
docker commit -m "Install packages" --author "elonz" ubuntu ubuntu:latest
```

列出所有的镜像，查看是否提交成功：

```
docker image ls
```

```
REPOSITORY        TAG       IMAGE ID       CREATED              SIZE
ubuntu            latest    a5d22784e35b   About a minute ago   108MB
```

可以删除指定的镜像：

```plaintext
# <image> 可以是上面的 REPOSITORY(image_name) 或 IMAGE ID
docker image rm <image> 
```

### 删除容器

```
# docker rm <container>
docker rm ubuntu
```

查看当前所有容器，确认是否删除成功：

```
docker container ls --all
```

之后，重新启动容器

```
# docker run -it --name <container> <image>
docker run -it --name ubuntu ubuntu 
```

到这里为止，我们就完成了所有的环境安装过程。

### 退出容器

如果需要退出容器，可以在容器内执行：

```
exit
```

### 再次启动容器
{: #docker-start}

如果容器未启动 (Exited)，执行 `start` 命令：

```
# docker start -i <container>
docker start -i ubuntu
```

如果容器已启动 (Up)，执行 `exec` 命令 (本文暂时用不到)：

```
docker exec -it <container> /bin/bash 
```

## 应用层

当我们通过诸如 `http.Get("http://www.baidu.com/")` 这样的 API 向服务器发送请求时，其底层实现无非以下几个过程：

1. 通过 DNS 协议将域名解析为 IP 地址 [→]({% post_url 2020-02-26-what-happens-when-you-type-in-a-url %}#dns)
2. 通过操作系统提供的[系统调用]({% post_url 2020-07-08-tech-interview %}#socket)创建一个 socket 连接，这实际上是完成了 [TCP 的三次握手过程]({% post_url 2020-07-08-tcp-shake-wave %}#three-shake)
3. 通过 socket 连接以文本形式向服务端发送请求，在代码层面实际上是在向一个 socket 文件描述符写入数据，写入的数据就是一个 [HTTP 请求]({% post_url 2020-08-22-http %}#request-body)

我们可以直接在终端实现这个过程，只需要以下三行命令：

```
exec 3<> /dev/tcp/www.baidu.com/80
printf "GET / HTTP/1.1\r\nHost: www.baidu.com\r\n\r\n" 1>& 3
cat <& 3
```

接下来将详细解释这三行命令。

### 建立连接

首先[进入容器](#docker-start)，查看当前系统中的文件描述符：

```
cd /dev/fd && ll
```

```
total 0
dr-x------ 2 root root  0 May 18 13:06 ./
dr-xr-xr-x 9 root root  0 May 18 13:06 ../
lrwx------ 1 root root 64 May 18 13:06 0 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 13:06 1 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 13:06 2 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 13:06 255 -> /dev/pts/0
```

系统当前只有 `/bin/bash` 这一个进程，上面列出了该进程的 0、1、2、255 四个文件描述符。

>  什么是文件描述符？文件描述符与 socket 的关系？可以查看[这篇文章]({% post_url 2020-02-27-select-poll-epoll %}#file-descriptor)。

执行以下命令，建立一个连接：

```
exec 3<> /dev/tcp/www.baidu.com/80
```

这个命令创建了一个指向 `tcp://www.baidu.com:80` 的可读写的 socket，绑定到当前进程的 3 号文件描述符。

* `exec {fd}< file`：以只读的方式打开文件，并绑定到当前进程的 fd 号描述符；相应的，`{fd}>` 是以只写的方式打开文件。[[1](https://stackoverflow.com/questions/39881089/why-does-exec-fdfile-assign-file-descriptor-of-file-to-fd)] [[2](https://www.oreilly.com/library/view/learning-linux-shell/9781788993197/f0acba13-468e-4454-a6aa-906e80b2a379.xhtml)]
* 打开 `/dev/tcp/$host/$port` 文件实际上是建立连接并返回一个 socket。Linux 中一切皆文件，所以可以对这个 socket 读写。[[1](https://tldp.org/LDP/abs/html/devref1.html)] [[2](https://www.linuxjournal.com/content/more-using-bashs-built-devtcp-file-tcpip)]

执行以下命令，可以看到我们已经和 `www.baidu.com` 成功建立了 socket 连接：

```
cd /dev/fd && ll # 或者：ll /proc/$$/fd
```

```
total 0
dr-x------ 2 root root  0 May 18 13:06 ./
dr-xr-xr-x 9 root root  0 May 18 13:06 ../
lrwx------ 1 root root 64 May 18 13:08 0 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 13:08 1 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 13:08 2 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 13:11 255 -> /dev/pts/0
lrwx------ 1 root root 64 May 18 17:25 3 -> 'socket:[54134]' # 绑定在 3 号描述符
```

### 发送请求

向 `www.baidu.com` 发送一个 GET 请求，只需要向 3 号文件描述符写入请求报文 ([格式]({% post_url 2020-08-22-http %}#request-body))：

```
printf "GET / HTTP/1.1\r\nHost: www.baidu.com\r\n\r\n" 1>& 3
```

> `> 3`：重定向到名为 `3` 的文件；`>& 3`：重定向到 3 号文件描述符。

### 读取响应

读取 `www.baidu.com` 返回的响应：

```
cat <& 3
```

```
<!DOCTYPE html>
<!--STATUS OK--><html>
...
</html>
```

### 关闭连接

```
# 关闭输入连接：exec {fd}<&-；关闭输出连接：exec {fd}>& -
exec 3<&- && exec 3>&-
```

这样我们就在 bash 中实现了 `http.Get("http://www.baidu.com/")`。

## 传输层

客户端使用 [socket()](https://man7.org/linux/man-pages/man2/socket.2.html), [connect()](https://man7.org/linux/man-pages/man2/connect.2.html) 等系统调用来和远程主机进行通信。在底层，`socket()` 负责分配资源，`connect()` 实现了 TCP 的三次握手过程。

Socket 通过 \<源 IP、源 Port、目的 IP、目的 Port> 的四元组来区分 (实际上还有协议，TCP 或 UDP)，只要有一处不同，就是不同的 socket。因此，尽管 TCP 支持的端口号最多为 [65535 ](https://www.pico.net/kb/what-is-the-highest-tcp-port-number-allowed)个，但是每台机器理论上可以建立无数个 socket 连接 —— 比如 HTTP 服务器只消耗一个 80 端口号，但可以和不同 IP:Port 的客户端建立连接 —— 实际受限于操作系统的内存大小。

使用 `netstat` 命令可以查看当前系统中的所有 socket：

```
exec 3<> /dev/tcp/www.baidu.com/80 # 在容器中手动创建一个 socket
exec 4<> /dev/tcp/www.bing.com/80  # 同上
netstat -natp
```

```
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 172.17.0.2:36384        110.242.68.4:80         ESTABLISHED 1/bash
tcp        0      0 172.17.0.2:44960        202.89.233.100:80       ESTABLISHED 1/bash
```

进一步了解 socket 系统调用和 TCP 的三次握手过程：

* [面试题汇总 - Socket](({% post_url 2020-07-08-tech-interview %}#socket))
* [TCP 的三次握手和四次挥手]({% post_url 2020-07-08-tcp-shake-wave %})
* [`netstat` 命令 `State` 一列的含义]({% post_url 2020-07-08-tcp-shake-wave %}#state)

## 网络层

网络层的功能是路由与寻址。数据包在网络层是一跳一跳地传输的，从源节点到下一个节点，直到目的节点，形成一个链表式的结构。当数据包到达网络中的一个节点时，该节点会检查数据包的目的 IP 地址，如果不是自己的 IP 地址，就根据路由表决定将数据包发送给哪个网关。

### 路由表

电脑、手机、路由集等都可以视为网络层的一个节点 (或一台主机)，每个节点都有一个**路由表**。网络层的节点通过路由表来选择下一跳地址 (next hop address)。

Ubuntu 系统可以通过以下命令查看路由表：

```
route -n
```

```
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0
```

路由表由一组规则组成，每条规则包含以下字段：


* `Destination`：目的地址，可以是主机地址或网络地址，常见的是网络地址
* `Gateway`：网关地址
* `Genmask`：目的地址的子网掩码
* `Iface`：网卡名
* [Others...](https://www.cyberciti.biz/faq/what-is-a-routing-table/)

**当 `Gateway` 为 0.0.0.0 时，表示没有网关**。这说明目的机器和当前主机位于同一个局域网内，它们互相连接，任何数据包都不需要路由，可以直接发送到目的机器上。

通过 `Destination` 和 `Genmask` 可以计算出目的地址集。例如对于下面的表项，其含义为“所有目的 IP 地址在 192.168.1.0 ~ 192.168.1.255 范围内的数据包，都应该发给 0.0.0.0 网关“。

```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0
```

相应的，`Genmask` 为 255.255.255.255 时，代表这条规则的 `Destination` 不再是一个网络地址，而是一个网络中的一台**特定主机**。这样的规则可能对应一条点对点信道 (Point to Point Tunnel)。

路由表中的规则可以手动指定，也可以使用路由协议来交换周围网络的拓扑信息，并动态更新。

### 路由决策过程

当一个节点收到一个数据包时，会根据路由表来找到下一跳的地址。具体而言，系统会遍历路由表的每个表项，然后将目的 IP 和子网掩码 `Genmask` 作**二进制与运算**，判断结果和该表项的网络地址 `Destination` 是否匹配：

* 如果只有一个匹配项，直接将数据包发送给该表项的网关 `Gateway`
* 如果有多个匹配项，则选择子网掩码最长的那个规则，然后发送给对应的网关
* 如果没有匹配项，则将数据包发送给默认网关

上面最后一种情况实际上不会出现，因为路由表中包含了下面这条规则：

```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
```

任何目的 IP 和全 0 的 `Genmask` 作与运算，一定会得到全 0 的 `Destination`，这保证了所有未知的目的 IP 都会发送给当前局域网的默认网关 (比如路由器)，由后者决定下一跳的地址。

### 案例分析

1. `ping www.baidu.com` 的路由决策过程
2. `ping <局域网的另一台主机>` 的路由决策过程
3. 对于以下的路由表，路由器会如何转发目标 IP 为 `128.75.43.16` 和 `192.12.17.10` 的数据包？

   ```
   Destination    Gateway    Genmask	   
   128.75.43.0 	  A          255.255.255.0
   128.75.43.0 	  B          255.255.255.128
   192.12.17.5 	  C          255.255.255.255
   default 	  	  D          0.0.0.0
   ```

{% details 答案 %}

1. 目标 IP 位于外部网络，默认会发给本局域网的路由器。路由器连接了外部网络，知道该如何转发数据包。
2. 同局域网的主机交换数据不需要网关或路由器，直接发给交换机，交换机根据 Mac 地址发送到对应的主机，见下一节。
3. A and D。`128.75.43.16` 匹配了前两条规则，相应的 `Destination` 均为 `128.75.43.0`，数据包会发送给具有最长子网掩码的网关。`192.12.17.10` 没有匹配任何 `Destination`，数据包发送给默认网关。

{% enddetails %}

## 数据链路层

上文说到 Gateway 为 0.0.0.0 时直接发到特定主机

当网络层选择了一个特定 IP 作为下一跳时，如何将数据包正确的发送给该主机？如果直接修改目的地址

这里是在数据包外面再包一层

## 



## 参考资料

* [What is a routing table](https://www.cyberciti.biz/faq/what-is-a-routing-table/)

