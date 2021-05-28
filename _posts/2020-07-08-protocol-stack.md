---
layout: post
title: 📔【计算机网络】计算机网络基础与协议栈
date: 2020/7/7 10:00
permalink: 2020/07/07/protocol-stack.html
---

> 更多面试题总结请看：[🗂【面试题】技术面试题汇总]({%post_url 2020-07-08-tech-interview%})

## OSI 参考模型
OSI 从上到下分为 7 层：
* 应用层：应用层协议定义的是应用进程间的通信和交互的规则，不同的网络应用需要不同的应用层协议
* 表示层：把数据转换为能与接收者的系统格式兼容并适合传输的格式
* 会话层：在数据传输中设置和维护电脑网络中两台电脑之间的通信连接
* 传输层：向两台主机进程之间的通信提供**通用的**数据传输服务
* 网络层：基于网络层地址（IP地址）进行不同网络系统间的路径选择
* 数据链路层：在不可靠的物理介质上提供可靠的传输
* 物理层：在局域网上透明地传送比特，尽可能屏蔽掉具体传输介质和物理设备的差异

## TCP/IP 参考模型
从上到下分为 4 层，对应于 OSI 中的 5 层：
* 应用层：对应于 OSI 参考模型的应用层，为用户提供所需要的各种服务。定义的是应用进程间的通信和交互的规则，不同的网络应用需要不同的应用层协议。协议包括 SMTP、HTTP、FTP 等
* 传输层：对应于 OSI 参考模型的传输层，为应用层实体提供端到端的、**通用的**通信功能，保证了数据包的顺序传送及数据的完整性。“通用的”是指不同的应用可以使用同一个运输层服务。协议包括 TCP、UDP 等
* 网络层（或网际互联层）：对应于 OSI 参考模型的网络层，主要解决主机到主机的路由问题。协议包括 IP、ICMP 等
* 网络接入层：对应于 OSI 参考模型的物理层和数据链路层，负责相邻的物理节点间的可靠数据传输。协议包括 ARP、IEEE 802.2 等

## TCP/IP 参考模型各层常见协议
将“网络接入层”进一步分为“数据链路层”与“物理层”，得到五层协议模型。各层的常见协议如下：

<table class="no-wrap-table">
<thead>
  <tr>
    <th>TCP/IP 协议层</th>
    <th>协议</th>
    <th>作用</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="7">应用层</td>
    <td class="font-bold">HTTP</td>
    <td>超文本传输协议（HyperText Transfer Protocol）</td>
  </tr>
  <tr>
    <td class="font-bold">FTP</td>
    <td>文件传输协议（File Transfer Protocol）用于在客户端和服务器之间进行文件传输</td>
  </tr>
  <tr>
    <td>SMTP</td>
    <td>简单邮件传输协议（Simple Mail Transfer Protocol）是一个在网络上传输电子邮件的标准</td>
  </tr>
  <tr>
    <td>TELNET</td>
    <td>Telnet 是服务器远程登录控制的标准协议与主要方式</td>
  </tr>
  <tr>
    <td class="font-bold">DNS</td>
    <td>域名系统（Domain Name System）是域名和 IP 地址相互映射的分布式数据库</td>
  </tr>
  <tr>
    <td class="font-bold">SSH</td>
    <td>安全外壳协议（Secure Shell）是一种加密的网络传输协议，可在不安全的网络中为网络服务提供安全的传输环境</td>
  </tr>
  <tr>
    <td class="font-bold">DHCP</td>
    <td>动态主机配置协议（Dynamic Host Configuration Protocol）的主要作用是集中管理、动态分配 IP 地址，提升地址的使用率</td>
  </tr>
  <tr>
    <td rowspan="2">传输层</td>
    <td class="font-bold">TCP</td>
    <td>传输控制协议（Transmission Control Protocol）是一种面向连接的、可靠的、基于字节流的传输层通信协议</td>
  </tr>
  <tr>
    <td class="font-bold">UDP</td>
    <td>用户数据报协议（User Datagram Protocol）是一个简单的、无连接的、不可靠的、面向数据报的通信协议</td>
  </tr>
  <tr>
    <td rowspan="6">网络层</td>
    <td class="font-bold">IP</td>
    <td>网际协议（Internet Protocol）是用于分组交换数据网络的一种协议，功能包括寻址、路由、尽最大努力交付数据包</td>
  </tr>
  <tr>
    <td>ICMP</td>
    <td>互联网控制消息协议（Internet Control Message Protocol）用于返回通信环境的错误消息。traceroute 和 ping 都是基于 ICMP 消息实现的，traceroute 是通过发送含有特殊 TTL 的包，然后接收 ICMP 超时消息和目标不可达消息来实现的；ping 则是用 ICMP 的“Echo request (8)”和“Echo reply (0)”消息来实现的</td>
  </tr>
  <tr>
    <td>IGMP</td>
    <td>因特网组管理协议（Internet Group Management Protocol ）管理 IP 协议多播组成员</td>
  </tr>
  <tr>
    <td>RIP</td>
    <td>路由信息协议（Routing Information Protocol）是一种内部网关协议（IGP），是距离向量路由协议的一种实现</td>
  </tr>
  <tr>
    <td>OSFP</td>
    <td>开放式最短路径优先（Open Shortest Path First）是一种内部网关协议（IGP），使用 Dijkstra 算法计算最短路径，是链路状态路由协议的一种实现</td>
  </tr>
  <tr>
    <td>BGP</td>
    <td>边界网关协议（Border Gateway Protocol）是互联网上一个核心的去中心化自治路由协议，属于矢量路由协议。BGP 用于互联网上，将自治系统视作一个整体；每个自治系统使用 IGP（代表实现有 RIP 和 OSPF）进行路由</td>
  </tr>
  <tr>
    <td rowspan="2">数据链路层</td>
    <td class="font-bold">ARP*</td>
    <td>地址解析协议（Address Resolution Protocol）通过 IP 寻找 MAC 地址</td>
  </tr>
  <tr>
    <td>ARQ</td>
    <td>自动重传请求（Automatic Repeat-reQuest）是一种错误纠正协议</td>
  </tr>
  <tr>
    <td>物理层</td>
    <td>IEEE802</td>
    <td>IEEE 802 指 IEEE 标准中关于局域网和城域网的一系列标准，其中最广泛使用的有以太网、令牌环、无线局域网等</td>
  </tr>
</tbody>
</table>

* ARP 协议：ARP 协议应该属于哪一层？一种说法是属于网络层，因为 IP 协议使用 ARP 协议；另一种说法是属于数据链路层，因为 MAC 地址是数据链路层的内容。在 OSI 模型中，ARP 协议属于链路层；而在 TCP/IP 模型中，ARP 协议属于网络层。

## 比较 TCP/IP 参考模型与 OSI 参考模型
共同点：
* 都采用了层次结构的概念
* 都能够提供面向连接和无连接的通信服务机制

不同点：
* OSI 采用了七层模型，而 TCP/IP 是四层
* OSI 是一个在协议开发前设计的、有清晰概念的模型；TCP/IP 是先有协议集然后建立的、事实上得到广泛应用的弱模型，功能描述和实现细节混在一起
* OSI 的网络层既提供面向连接的服务，又提供无连接的服务；TCP/IP 的网络层只提供无连接的网络服务
* OSI 的传输层只提供面向连接的服务；TCP/IP 的传输层即提供面向连接的服务 TCP，也提供无连接的服务 UDP

## 集线器、网桥、交换机、路由器
* 网线是物理层的硬件
* 集线器（Hub）是**物理层**的硬件，连接所有的线路，广播所有信息
* 网桥（Bridge）是**数据链路层**的硬件。网桥隔离两个端口，不同的端口形成单独的冲突域，减少网内冲突。网桥在不同或相同类型的 LAN 之间存储并转发数据帧，根据 MAC 头部来决定转发端口，显然是数据链路层的设备
* 交换机（Switch）是**数据链路层**的硬件，相当于多端口的网桥。交换机内部存储 MAC 表，只会将数据帧发送到指定的目的地址
* 路由器（Router）是**网络层**的硬件，根据 IP 地址进行寻址，不同子网间的数据传输隔离

## 比特、帧、数据包、数据段、报文
PDU：Prtocol data unit，协议数据单元，指对等层协议之间交换的信息单元。PDU 再往上就是数据（data）。

在 OSI 模型里，PDU 和底下四层相关：
* 物理层———**比特（Bit）**
* 数据链路层———**帧（Frame）**
* 网络层———**分组、数据包（Packet）**
* 传输层———**数据段（Segment）**

第五层或以上为**数据（data）**。也有一种说法是，应用层的信息称为**消息、报文（message）**，表示完整的信息。

## MSL、TTL、RTT 是什么？
MSL（Maximum segment lifetime）：报文最大生存时间。它是任何 TCP 报文在网络上存在的最长时间，超过这个时间报文将被丢弃。实际应用中常用的设置是 30 秒，1 分钟和 2 分钟。
* 应用场景：TCP 四次挥手时，需要在 TIME-WAIT 状态等待 2MSL 的时间，可以保证本次连接产生的所有报文段都从网络中消失。

TTL（Time to live）：IP 数据报在网络中可以存活的总跳数，称为“生存时间”，但并不是一个真正的时间。该域由源主机设置初始值，每经过一个路由器，跳数减 1，如果减至 0，则丢弃该数据包，同时发送 ICMP 报文通知源主机。取值范围 1-255，如果设置的 TTL 值小于传输过程中需要经过的路由器数量，则该数据包在传输中就会被丢弃。

RTT（Round trip time）：客户端到服务端往返所花时间。RTT 受网络传输拥塞的变化而变化，由 TCP **动态地估算**。

## [🗂 技术面试题汇总]({%post_url 2020-07-08-tech-interview%})