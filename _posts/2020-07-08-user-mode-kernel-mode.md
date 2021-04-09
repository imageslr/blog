---
layout: post
title: 📔【操作系统】用户态与内核态
date: 2020/7/7 08:00
permalink: 2020/07/07/user-mode-kernel-mode.html
---

> 更多面试题总结请看：[🗂【面试题】技术面试题汇总]({%post_url 2020-07-08-tech-interview%})

## 为何要区分用户态和内核态
最简单的运行程序的方式是“直接执行”，即直接在 CPU 上执行任意程序。直接执行的问题是：
1. 如何限制代码行为？比如禁止：设置特殊寄存器的值、访问存储器的任意位置、I/O 请求、申请更多系统资源等
2. 在运行这个程序的时候，如何切换到另一个程序？进程调度应该是 OS 才有的权限

因此引入用户态和内核态和两种模式。用户态无法执行受限操作，如 I/O 请求，执行这些操作会引发异常。核心态只能由操作系统运行，可以执行特权操作。用户程序通过**系统调用** system call 执行这些特权操作。OS 执行前会判断进程是否有**权限**执行相应的指令。

区分用户态和核心态的执行机制称为“受限直接执行”（Limited Direct Execution）。

## 什么时候会陷入内核态
系统调用（trap）、中断（interrupt）和异常（exception）。

系统调用是用户进程主动发起的操作。发起系统调用，陷入内核，由操作系统执行系统调用，然后再返回到进程。

中断和异常是被动的，无法预测发生时机。中断包括 I/O 中断、外部信号中断、各种定时器引起的时钟中断等。异常包括程序运算引起的各种错误如除 0、缓冲区溢出、缺页等。

在系统的处理上，中断和异常类似，都是通过中断向量表来找到相应的处理程序进行处理。区别在于，中断来自处理器外部，不是由任何一条专门的指令造成，而异常是执行当前指令的结果。

见[陷阱、中断、异常、信号]({% post_url 2020-07-10-trap-interrupt-exception%})。

## C 访问空指针会不会陷入内核态
会。

访问指针相当于访问一个虚拟地址，硬件会将虚拟地址映射到真实的物理内存。如果映射失败，硬件会抛出一个段错误**异常**（page fault exception），此时会**从用户态转为内核态**进行处理。

OS 会在中断描述符表中，找到处理 page fault exception 的中断向量，执行相应的 handler。一般情况下，OS 会抛出一个 `SIGSEGV` 信号给进程，中止进程，打印出 debug 信息。

> [参考 - StackOverflow](https://stackoverflow.com/questions/12645647/what-happens-in-os-when-we-dereference-a-null-pointer-in-c)  
>  the CPU raises a page fault error which **traps into** a predefined point at the kernel, the kernel examines what happened, and reacts accordingly 

## [🗂 技术面试题汇总]({%post_url 2020-07-08-tech-interview%})