---
layout: post
title: 📈【Go 实践】实现一个简单的多人聊天室
date: 2019/11/18 18:00
---

## 简介
[Github 地址](https://github.com/imageslr/go-chat-server-practice)

本文使用 go 实现了一个多人聊天室，参考文章为 [Writing a Chat Server in Go](https://medium.com/@nqbao/writing-a-chat-server-in-go-3b61ccc2a8ed)，点击查看[中文翻译版](https://juejin.im/post/5dafb4435188256290692f05)。

本文的特点在于：将原始项目分为自底向上的若干个阶段，新手可以一步步地实现系统的不同模块，逐渐掌握相应知识点。[源码](https://github.com/imageslr/go-chat-server-practice)里有详细的注释，引导你在不看源代码的情况下自己实现相应代码。

本文假设你：
* 了解 go 语言的基本语法
* 了解 git 的使用

完成本项目，你将学会这些内容：
* Reader 方法的基本使用
* 使用 `net` 包实现一个 tcp 服务器：监听端口、建立连接、提供服务
* sync 加锁
* goroutine 与 channel
* gob 的基本使用

## 运行
运行环境：go 1.13.1
1. 打开 `GO111MODULE`，运行 `go mod download` 安装依赖
2. 启动 server：`server/cmd` 目录下运行 `go run main.go`
4. 启动 client：`tui/cmd` 目录下运行 `go run main.go -server=localhost:3333`，可以在多个窗口启动不同的客户端

## 学习方法
本项目共有 5 个分支，对应 4 个阶段。这 5 个分支依次为：
1. `v0-template-code`：模板代码，包含详细的注释，但未实现相应的方法
2. `v1-protocol-reader-writer`：实现了基于字符串方式的协议的编解码
3. `v2-server-implementation`：实现了服务端
4. `v3-client-implementation`：实现了客户端
5. `v4-gob-protocol`：使用 gob 作为通信协议

对应的阶段为：
1. 实现基于字符串的通信协议：v0 -> v1
2. 实现服务端：v1 -> v2
3. 实现客户端：v2 -> v3
4. 使用 gob 作为通信协议：v3 -> v4

建议从 v0 开始，根据注释内容依次实现每个模块。如果实在摸不着头脑，可以查看 [master 分支下的代码](https://github.com/imageslr/go-chat-server-practice)获得提示。

## 步骤简介
### 1. 实现协议
运行：
```
git checkout v0-template-code
```

在这一步我们要实现通信协议。TCP 传输的都是无格式的字节流，我们需要定义这些字符串的格式，以在客户端和服务端能解析出相应的命令与参数。

客户端与服务端通过 TCP 传输的是字符串，因此需要规定一个将字符串解析为命令的协议。

约定一条命令的格式如下所示：
```
[命令类型] [参数1] [参数2] ... [参数n]\n
```
每条命令以换行符结尾。

命令一共有三种：
* `NAME`：客户端设置用户名
* `SEND`：客户端发送聊天消息
* `MESSAGE`：服务端广播聊天消息给其他用户

比如客户端发送聊天消息的命令为：
```
SEND somemessage\n
```
服务端广播消息给其他用户的命令为：
```
MESSAGE username somemessage\n
```

`protocol/command.go` 中定义了命令的类型。需要实现 `protocol/reader.go` 与 `protocol/writer.go` 中的相应方法。

### 2. 实现服务端
运行：
```
git checkout v1-protocol-reader-writer
```

在这一步我们要实现服务端。服务端接受客户端的连接请求，并保存所有连接以在之后向客户端发送数据。

服务端的工作流程为：
1. Listen：启动一个服务器，监听一个端口
2. Accept & Serve：与客户端建立一个连接，并为其提供服务
3. Remove：在客户端退出连接后，删除该客户的的连接
4. Close：停止监听端口，关闭服务器

服务端与客户端的交互有：
1. 接受客户端发来的消息，并广播（broadcast）给其他客户端
2. 设置某个客户端的名称

`server/server.go` 将服务端的行为定义为一个接口，`server/tcp_server.go` 为相应的实现。

### 3. 实现客户端
运行：
```
git checkout v2-server-implementation
```

在这一步我们要实现客户端。客户端其实比较简单，只需要连接到服务端，然后向服务端发送消息或接收服务端的消息。这部分的工作主要在于 UI 的实现，不过我没有单独抽离它。感兴趣的读者可以查看 [tui/](https://github.com/imageslr/go-chat-server-practice/tree/master/tui) 目录下的源码。

### 4. 使用 gob 作为通信协议
运行：
```
git checkout v3-client-implementation
```

在这一步我们要使用 gob 作为通信协议，替换原来的基于字符串的协议。只需要修改 `protocol/reader.go` 和 `protocol/writer.go` 的 `Read()` 和 `Write()` 方法，涉及到 gob 的两组方法：`NewEncoder/Encoder`、`NewDecoder/Decode`。是不是很方便！

## 下一步优化
这个项目还可以进一步优化，欢迎感兴趣的读者提交你的 PR！
1. 使用 RPC 调用而不是 TCP 调用，如 grpc
2. 数据持久化：使得后加入聊天室的人也能看到之前的聊天记录，数据存储方式可以为 gob 编码
3. 服务端支持多个聊天室
4. 高阶内容：支持断线重连，可以查看[这篇文章](https://my.oschina.net/tuxpy/blog/1645030)

---
参考资料：
* [Writing a Chat Server in Go](https://medium.com/@nqbao/writing-a-chat-server-in-go-3b61ccc2a8ed)
* [[译]用 Golang 编写一个简易聊天室](https://juejin.im/post/5dafb4435188256290692f05)