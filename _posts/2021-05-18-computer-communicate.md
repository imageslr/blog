---
layout: post
title: 📔【计算机网络】两台主机的通信过程 🆕
date: 2021/5/23 22:00
last_modified_at: 2021/5/25
typora-root-url: ../
typora-copy-images-to: ../media
---

> 更多面试题总结请看：[🗂【面试题】技术面试题汇总]({%post_url 2020-07-08-tech-interview%})



## 前言

本文通过在 Docker 容器中执行命令，来深入了解两台主机之间的通信过程。阅读完本文，我们将熟悉以下内容：
* Docker 的基本操作
* 创建 socket 并发送 HTTP 请求
* 路由表、路由决策过程
* ARP 协议、ARP 表更新过程

本文也是[输入一个 URL 到页面加载完成]({% post_url 2020-02-26-what-happens-when-you-type-in-a-url %})的另一个角度的回答，我们将解决以下两个问题：
* 不同局域网的两台主机之间的通信过程
* 同局域网内的两台主机之间的通信过程

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

如果有多余的无用镜像，可以删除：

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

之后，重新启动容器：

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

如果容器已启动 (Up)，执行 `exec` 命令：

```
docker exec -it <container> /bin/bash 
```

容器是否启动，可以通过 `docker container ls --all` 查看。

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
exec 4<> /dev/tcp/www.bing.com/80  # 同上，只是为了演示
netstat -natp
```

```
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 192.168.1.2:36384       110.242.68.4:80         ESTABLISHED 1/bash
tcp        0      0 192.168.1.2:44960       202.89.233.100:80       ESTABLISHED 1/bash
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

当 `Destination` 为 0.0.0.0 时，其 `Gateway` 为当前局域网的路由器 / 网关的 IP 地址。

当 `Gateway` 为 0.0.0.0 时，表示目的机器和当前主机位于同一个局域网内，它们互相连接，任何数据包都不需要路由，可以直接通过 MAC 地址发送到目的机器上。[→](#link-layer)

通过 `Destination` 和 `Genmask` 可以计算出目的地址集。例如对于下面的表项，其含义为“所有目的 IP 地址在 192.168.1.0 ~ 192.168.1.255 范围内的数据包，都应该发给 0.0.0.0 网关“。

```
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0
```

当 `Genmask` 为 255.255.255.255 时，代表这条规则的 `Destination` 不再是一个网络地址，而是一个网络中的一台**特定主机**。这样的规则可能对应一条点对点信道 (Point to Point Tunnel)。

路由表中的规则可以手动指定，也可以通过路由协议来交换周围网络的拓扑信息、动态更新。

### 路由决策过程

当一个节点收到一个数据包时，会根据路由表来找到下一跳的地址。具体而言，系统会遍历路由表的每个表项，然后将目的 IP 和子网掩码 `Genmask` 作**二进制与运算**，得到网络地址，再判断这个地址和表项的 `Destination` 是否匹配：

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
2. `ping 局域网的另一台主机` 的路由决策过程
3. 对于以下的路由表，路由器会如何转发目标 IP 为 `128.75.43.16` 和 `192.12.17.10` 的数据包？

   ```
   Destination    Gateway    Genmask	   
   128.75.43.0    A          255.255.255.0
   128.75.43.0    B          255.255.255.128
   192.12.17.5    C          255.255.255.255
   default        D          0.0.0.0
   ```

{% details 答案 %}

1. 目标 IP 位于外部网络，默认会发给本局域网的路由器。路由器连接了外部网络，知道该如何转发数据包，例如交给更高一级的运营商网关。
2. 同局域网的主机交换数据不需要网关或路由器，直接发给交换机，交换机根据 Mac 地址发送到对应的主机，见[下一节](#link-layer)。
3. A and D。`128.75.43.16` 匹配了前两条规则，相应的 `Destination` 均为 `128.75.43.0`，数据包会发送给具有最长子网掩码的网关。`192.12.17.10` 没有匹配任何 `Destination`，数据包发送给默认网关。

{% enddetails %}

## 数据链路层
{: #link-layer}

### ARP 协议

当网络层选择了一个特定 IP 的主机作为下一跳时，如何将数据包正确的发送给该主机？这里需要在数据包外面加上下一跳的硬件地址 (MAC)。在数据包的整个传输过程中，目的 MAC 地址每一跳都在变，但目的 IP 地址不变。

如何根据 IP 地址找到相对应的 MAC 地址？这需要使用 ARP 协议 (Address Resolution Protocol，地址解析协议)。每台主机都设有一个 ARP 高速缓存表，记录了本局域网内各主机的 IP 地址到 MAC 地址的映射。执行以下命令可以查看主机的 ARP 缓存表：

```
arp -a
```

```
localhost (192.168.1.1) at bc:5f:f6:df:d8:19 on en0 ifscope [ethernet]
localhost (192.168.1.102) at 14:7d:da:32:8d:17 on en0 ifscope [ethernet]
```

ARP 高速缓存是自动更新的。当主机 A 向本局域网的主机 B 发送数据包时，如果 ARP 高速缓存中没有主机 B 的硬件地址，就会自动运行 ARP 协议，找出 B 的硬件地址，并更新高速缓存，过程如下：

1. 主机 A 在局域网内**广播**一个 ARP 请求分组，内容为：“我的 IP 是 IP_A，硬件地址是 MAC_A。我想知道 IP 地址为 IP_B 的主机的硬件地址“；
2. 主机 B 接受到此请求分组后，如果要查询的 IP 地址和自己的 IP 地址一致，就将主机 A 的 IP 地址和 MAC 地址的对应关系记录到自己的 ARP 缓存表中，同时会发送一个 ARP 应答 (**单播**)，内容为：“我的 IP 地址是 IP_B，硬件地址是 MAC_B”；
3. 其他主机的 IP 地址和要查询的 IP 地址不一致，因此都丢弃此请求分组；
4. 主机 A 收到 B 的 ARP 响应分组后，同样将主机 B 的 IP 地址和 MAC 地址的对应关系记录到自己的 ARP 缓存表中。

**注意：**ARP 协议只用于局域网中，不同局域网之间通过 IP 协议进行通信。
{: .ant-alert .ant-alert-info}

### ARP 协议抓包

首先，我们需要另一个终端来监听容器内的网络请求。假设已经通过 [docker start](#docker-start) 启动了一个容器，我们使用 `docker exec` 命令来创建一个新的终端会话：

```
docker exec -it ubuntu /bin/bash # 宿主机执行
```

为了便于表示，将一开始 `docker start` 创建的容器终端记为 **A**，`docker exec` 创建的记为 **B**。在终端 B 内执行以下命令，监听网络请求：

```
tcpdump -nn -i eth0 port 80 or arp
```

随后，在终端 A 中执行以下命令，触发 ARP 协议更新：

```
# arp -d <ip> && ping www.baidu.com
arp -d 192.168.1.1 && ping www.baidu.com
```

其中，`arp -d` 命令可以删除一条 ARP 映射记录。这里需要将 `<ip>` 替换为容器的网关 IP 地址，有许多方法可以获取容器的网关地址：

* [容器内] 执行 `route -n` 命令，查看 `Destination` 为 0.0.0.0 时对应的 `Gateway`

* [宿主机] 执行 `docker network inspect bridge`，查看 `IPAM - Config - Gateway`

在终端 A 中有以下输出，表示 ping 命令执行成功：

```
PING www.a.shifen.com (110.242.68.3) 56(84) bytes of data.
64 bytes from 110.242.68.3 (110.242.68.3): icmp_seq=1 ttl=37 time=19.7 ms
64 bytes from 110.242.68.3 (110.242.68.3): icmp_seq=2 ttl=37 time=22.7 ms
64 bytes from 110.242.68.3 (110.242.68.3): icmp_seq=3 ttl=37 time=21.8 ms
```

在终端 B 中，可以看到 ARP 协议包的内容：

```
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
17:04:43.847963 ARP, Request who-has 192.168.1.1 tell 192.168.1.2, length 28
17:04:43.848058 ARP, Reply 192.168.1.1 is-at 02:43:21:c4:75:58, length 28
17:04:53.009573 ARP, Request who-has 192.168.1.2 tell 192.168.1.1, length 28
17:04:53.009746 ARP, Reply 192.168.1.2 is-at 02:43:ac:11:00:02, length 28
```

可以看到，这里有两次 ARP 请求与应答。第一次是容器 (192.168.1.2) 广播查询网关 (192.168.1.1) 的 MAC 地址，第二次是网关 (192.168.1.1) 广播查询容器 (192.168.1.2) 的 MAC 地址。

## 两台主机的通信过程

### 不同局域网的两台主机

以主机 ping 一个域名为例，过程如下：

1. [主机] [应用层] 通过 DNS 协议获取域名的 IP 地址；
2. [主机] [网络层] 构造 IP 数据包，源 IP 为本机 IP，目的 IP 为域名 IP；
3. [主机] [网络层] 根据路由表，选择下一跳的 IP 地址，即当前局域网的网关；
4. [主机] [链路层] 根据 ARP 表，查找网关 IP 的 MAC 地址；在 IP 数据包外面包一层 MAC 地址；
5. [局域网] 根据 MAC 地址，上一步的报文最终会发送到当前局域网的网关；
6. [网关] [网络层] 网关查看数据包的目的 IP 地址，重复上述 2～3 步，继续发给下一跳；
7. [互联网] 中间经过若干个下一跳主机，最终数据包发送到域名所在的网络中心的网关；
8. [网关] [网络层] 网络中心的网关查看数据包的目的 IP 地址，根据路由表发现目的 IP 对应的 `Gateway` 为 0.0.0.0 ，这表明目的机器和自己位于同一个局域网内；
9. [网关] [链路层] 根据 ARP 表，查找目的 IP 的 MAC 地址，构造链路层报文；
10. [局域网] 根据 MAC 地址，上一步的报文最终会发送到目的主机；
11. [目的主机] [网络层] 目的主机查看数据包中的目的 IP，发现是给自己的，解析其内容，过程结束。

![](/media/05-26-16-38-50.png)

### 同局域网内的两台主机

两台主机通过网线、网桥或者交换机连接，就构成了一个局域网。网桥或交换机的作用是连接多台主机，隔离不同的端口，每个端口形成单独的冲突域。当主机连接到网桥或交换机端口的时候，这些设备会要求主机上报 MAC 地址，并在设备内保存 MAC 地址与端口的对应关系。

同局域网内的两台主机进行通信时，只需要根据 ARP 协议获取目的主机的 MAC 地址，构造链路层报文。报文会经过网桥或交换机，后两者根据目的 MAC 地址，在 MAC 地址表里查询目的端口，然后将报文从目的端口转发给对应的主机。

**注意**：

(1) 交换机是链路层的设备，主要根据 MAC 地址进行转发、隔离冲突域；不具有路由功能，不记录路由表。这类设备也称为**二层交换机**。如果只使用二层交换机、不使用路由器来构建局域网，需要为交换机和每台主机分配同属于一个子网的静态 IP。

(2) 路由器工作在 OSI 的第三层网络层，记录路由表，并以此控制数据传输过程。

(3) 有些交换机也具有路由功能，记录了路由表，能够简化路由过程、实现高速转发。这类设备也称为**三层交换机**。

### 同局域网内的两台主机，目的主机有多个 IP

问题：如果目的主机 B 为自己新增了一个 IP，同局域网的主机 A ping 主机 B 的这个 IP 能 ping 通吗？

答案是不能，原因是主机 A ping 主机 B 时，根据路由表会将报文发给默认网关，但是网关的路由表里并没有主机 B 新增加的 IP 信息。

可以做实验验证一下。分别启动两个容器 A、B：

```
docker run -it --name ubuntu --cap-add NET_ADMIN ubuntu # 容器 A
docker run -it --name ubuntu_2 --cap-add NET_ADMIN ubuntu # 容器 B
```

> 参数 `--cap-add NET_ADMIN`：打开网络配置权限。

在容器 B 内执行以下命令，新增一个 IP 地址 `192.168.1.55`：

```
ifconfig lo:3 192.168.1.55/16
```

查看容器 B 的 IP 配置，可以看到新增了一个 `lo:3` 接口：

```
ifconfig
```

```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500 # 这里是默认 IP
        inet 192.168.1.2  netmask 255.255.0.0  broadcast 192.168.255.255
        ether 02:42:ac:11:00:03  txqueuelen 0  (Ethernet)
        RX packets 9  bytes 726 (726.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo:3: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536 # 这里是新增的 IP
        inet 192.168.1.55  netmask 255.255.0.0
        loop  txqueuelen 1000  (Local Loopback)
```

在容器 A 内尝试 `ping 192.168.1.55`，发现无法 ping 通。

解决办法是修改容器 A 的路由表。执行以下命令，手动新增一条规则：

```
# route add -host <destination> gw <gateway>
route add -host 192.168.1.55 gw 192.168.1.2
```

其中，`destination` 参数是容器 B 新增的 IP 地址；`gateway` 参数是容器 B 的默认 IP 地址，也就是上面 `ifconfig` 命令输出的 `eth0` 接口的 IP 地址。这条规则的含义是“所有目的 IP 是 `192.168.1.55` 的数据包都发给 `192.168.1.2`”。

容器 A 内执行 `route -n`，查看路由表：

```
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
192.168.1.0     0.0.0.0         255.255.0.0     U     0      0        0 eth0
192.168.1.55    192.168.1.2     255.255.255.255 UGH   0      0        0 eth0
```

这个时候再从容器 A 中 ping 容器 B 的新 IP，就可以 ping 通了：

```
ping 192.168.1.55
```

```
PING 192.168.1.55 (192.168.1.55) 56(84) bytes of data.
64 bytes from 192.168.1.55: icmp_seq=1 ttl=64 time=0.589 ms
64 bytes from 192.168.1.55: icmp_seq=2 ttl=64 time=0.291 ms
64 bytes from 192.168.1.55: icmp_seq=3 ttl=64 time=0.669 ms
...
```

如果在执行 ping 命令前，先在容器 B 执行 `tcpdump`，我们会看到如下输出：

```
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
08:36:28.819409 ARP, Request who-has 192.168.1.1 tell 192.168.1.3, length 28
08:36:38.987179 ARP, Request who-has 81b3a9d0f060 tell 192.168.1.3, length 28
08:36:38.987296 ARP, Reply 81b3a9d0f060 is-at 02:43:ac:11:00:03 (oui Unknown), length 28
08:36:38.987537 IP 192.168.1.3 > 192.168.1.55: ICMP echo request, id 17, seq 1, length 64
08:36:38.987585 IP 192.168.1.55 > 192.168.1.3: ICMP echo reply, id 17, seq 1, length 64
08:36:40.019291 IP 192.168.1.3 > 192.168.1.55: ICMP echo request, id 17, seq 2, length 64
08:36:40.019410 IP 192.168.1.55 > 192.168.1.3: ICMP echo reply, id 17, seq 2, length 64
...
```

其中，`192.168.1.1` 是网关 IP，`192.168.1.3` 是容器 A 的 IP，`81b3a9d0f060` 是容器 B 的 `ContainerID`。上面的输出依次表示：容器 A 通过 ARP 协议查询网关的 MAC 地址；容器 A 通过 ARP 协议查询容器 B 的 MAC 地址；容器 B 发出 ARP 应答；容器 A 发送 ICMP 请求、容器 B 应答。

## 总结

Docker：
* 在 Docker 的各个命令中，`<container_id>` 和 `<container_name>`、`<image_id>` 和 `<image_name>` 可以互换
* `docker run` 会重新创建一个新的容器，`docker start` 可以进入已经启动的容器

Socket：
* 每个进程默认都有 0、1、2、255 四个文件描述符
* 系统用 socket 来表示一个连接，socket 会绑定到进程的一个文件描述符，可以使用 `open`、`write` 系统调用来向远程主机发送请求、读取响应
* Socket 通过 <源 IP、源 Port、目的 IP、目的 Port> 的四元组来区分，只要有一处不同，就是不同的 socket
* `netstat -natp`：查看当前系统中的所有 socket
* [`netstat` 命令 `State` 一列的含义](http://localhost:4000/2020/07/07/tcp-shake-wave.html#state)

路由表：
* `route -n`：查看路由表
* `Destination` 为 `0.0.0.0` 时，`Gateway` 为默认网关
* `Gateway` 为 `0.0.0.0` 时，`Destination` 为当前局域网的网络地址
* `Genmask` 为 `255.255.255.255` 时，`Destination` 为一个网络中的一台特定主机

ARP 表：
* `arp -a`：查看 ARP 缓存表
* `arp -d <ip>`：删除一条 ARP 记录

通信过程：
* 不同局域网的主机，数据包会在网络层经过若干个下一跳 (当前局域网的默认网关 - 运营商网关 - 目的主机所在的数据中心网关)，最终发送给目的主机所在的局域网  
  ![](/media/05-26-16-38-50.png)
* 同局域网内的主机，只需要通过 ARP 协议获取目的主机的 MAC 地址，报文在数据链路层经由网桥或交换机转发给目的主机
* 交换机不具有路由功能，属于二层设备；有些交换机为了提升效率而记录路由表，属于三层设备

## 参考资料

* [What is a routing table](https://www.cyberciti.biz/faq/what-is-a-routing-table/)
* [TCP 通信基础](https://www.bilibili.com/video/BV1Af4y117ZK)

