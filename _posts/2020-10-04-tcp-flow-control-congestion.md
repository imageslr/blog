---
layout: post
title: 📔【计算机网络】TCP 的流量控制与拥塞控制
date: 2020/11/3 14:00
---

> 更多面试题总结请看：[🗂【面试题】技术面试题汇总]({%post_url 2020-07-08-tech-interview%})

## 流量控制 Flow Control

流量控制的目的是控制发送端的发送速度，使其按照接收端的数据处理速度来发送数据，避免接收端处理不过来，产生网络拥塞或丢包。

TCP 实现流量控制的关键是滑动窗口（Sliding Window）。发送端和接收端均有一个滑动窗口，对应一个缓冲区，记录当前发送或接收到的数据。接收端会在返回的 ACK 报文中包含自己**可用于接收数据**的缓冲区的大小，在 TCP 的报文首部里用 `window` 表示（或者叫 `AdvertisedWindow`，16 bit，最多 65535 字节）。发送端发送的数据不会超过 `window` 的大小。

![](/media/16019669956427.jpg)

为了说明 `window` 字段是如何计算出来的，首先看一下发送端和接收端的滑动窗口示意图：

![](/media/16042843490197.jpg)
> [图片来源](https://coolshell.cn/articles/11609.html#TCP%E6%BB%91%E5%8A%A8%E7%AA%97%E5%8F%A3)

对于发送端来说：
* `LastByteAcked` 指向被接收端 ACK 的最后一个位置
* `LastByteSent` 指向已发送但还未收到 ACK 的最后一个位置
* `LastByteWritten` 指向上层应用写入但还未发送的最后一个位置

对于接收端来说：
* `LastByteRead` 指向 TCP 缓冲区中读到的位置
* `NextByteExpected` 指向收到的连续包的最后一个位置
* `LastByteRcvd` 指向收到的包的最后一个位置

因此，接收端返回给发送端的 ACK 报文中的 `window` 字段等于：

$$AdvertisedWindow = MaxRcvBuffer – LastByteRcvd – 1$$

即只能在收到的包的最后一个位置之后继续接收。尽管 `NextByteExpected` 和 `LastByteRcvd` 中间还有一段数据空白区，但这些数据可能发送端已经发送，只是还未到达接收端，因此不能将这段空白区大小计入 `window`。

发送端在收到这个 ACK 报文后，下一个报文的大小是：

$$Size=AdvertisedWindow-(LastByteSent-LastByteRcvd)$$

这就是用滑动窗口进行流量控制的基本原理。

### 零窗口
如果接收端处理过慢，那么 `window` 可能变为 0，这种情况下发送端就不再发送数据了。如何在接收端 `window` 可用的时候通知发送端呢？

TCP 使用来 ZWP（Zero Window Probe，零窗口探针）技术。具体是在发送端引入一个计时器，每当收到一个零窗口的应答后就启动该计时器。每间隔一段时间就主动发送报文，由接收端来 ACK 窗口大小。若接收者持续返回零窗口（一般是 3 次），则有的 TCP 实现会发送 RST 断开连接。

### Nagle 算法
如果接收端处理过慢，每次 `window` 只能接收几个字节，那么当发送端每次都发送这几个字节时，会有大量带宽浪费在 TCP 和 IP 的首部上。因此 Nagle 提出了 [Nagle 算法](https://zh.wikipedia.org/wiki/%E7%B4%8D%E6%A0%BC%E7%AE%97%E6%B3%95)。Nagle 算法的工作方式是「缓存/累积」要发送的小数据，直到 `window >= MSS` 时再一并发送，避免对小的 `window` 作出响应。
> MSS：Max Segment Size，TCP 报文段一次可传输的最大分段大小


## 发送端如何调节发送速率
发送端的发送速率受到多个因素的影响：
* 接收端将自己的可接收大小通过 `window` 字段发送给发送端，发送端据此作出调整（流量控制）
* 当发送端监测到网络出现拥塞时，通过各种协同工作的机制来解决拥塞（拥塞控制），通过一个状态变量 `cwnd` 控制发送速率

发送端的发送速度是上述两个变量的较小值。

## 拥塞控制

当等待接收端的 ACK 超时、或者收到乱序包时，说明网络出现了拥塞。TCP 通过各种协同工作的机制来解决网络拥塞。

发送端维持一个叫做拥塞窗口 `cwnd`（congestion window）的状态变量。拥塞窗口的大小取决于网络的拥塞程度，并且动态地在变化。下面用报文段个数作为 `cwnd` 的值进行说明，实际的 `cwnd` 是以字节为单位的。

![](/media/16043876917313.jpg)


### 慢启动
* 连接建立时，初始化 cwnd = 1，表示可以传一个 MSS 大小的数据
* 每收到一个 ACK 包，cwnd++
* 每经过一个 RTT，cwnd 会翻倍（指数增长）

当 cwnd >= ssthresh (slow start threshold) 时，进入拥塞避免阶段。

### 拥塞避免
* 每收到一个 ACK 包，cwnd = cwnd + 1/cwnd
* 每经过一个 RTT，cwnd = cwnd + 1（加性增）

### 超时重传
如果发送端超时还未收到 ACK 包，就可以认为网络出现了拥塞，需要解决拥塞：
1. 把 sshthresh 设为当前拥塞窗口的一半（乘性减）
2. cwnd 重置为 1，重新开始**慢启动**过程

### 快速重传 / 快速恢复

快速重传：接收端收到乱序包时，会发送 duplicate ACK 通知发送端。当发送端收到 3 个 duplicate ACK 时，就立刻开始重传，而不必继续等待到计时器超时。快速重传会配合快速恢复算法：
1. 把 sshthresh 设为当前拥塞窗口的一半（乘性减）
2. cwnd 重置为 sshthresh，重新开始**拥塞避免**过程

为什么快速重传不需要像超时重传那样，将 cwnd 重置为 1 重新开始慢启动呢？因为它认为如果网络出现拥塞的话，是不会收到好几个重复的 ACK 的，所以现在网络可能没有出现拥塞。

## 总结
流量控制是接收端控制的，拥塞避免是发送端控制的。最终都是控制发送端的发送速率。

## [🗂 技术面试题汇总]({%post_url 2020-07-08-tech-interview%})

---

参考资料：
* [TCP 的那些事儿（下）](https://coolshell.cn/articles/11609.html)
* [The TCP/IP Guide](http://www.tcpipguide.com/)
