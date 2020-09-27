---
layout: post
title: 📔【操作系统】进程的同步与互斥、常见的同步问题 🆕
date: 2020/9/26 19:00
---

## 基本概念
* 临界资源：一次仅允许一个进程使用的共享资源，也就是互斥资源
* 临界区：程序中访问临界资源的那段代码，也称危险区、敏感区
* 互斥：多个程序片段，同一时刻仅有一个能进入临界区
* 同步：若干程序片断运行必须严格按照规定的某种先后次序来运行。同步是一种更复杂的互斥：互斥不会限制程序对资源的访问顺序，即访问是无序的；而同步必须要按照某种次序来运行

## 临界区管理原则
  * 任何两个进程不能同时处于其临界区
  * 不应对 CPU 的速度和数量作任何假设
  * 临界区外运行的进程不得阻塞其他进程
  * 不得使进程无限等待进入临界区
  
当我们实现一个锁的时候，需要满足上述 4 个条件，才是一个正确的锁。

## 信号量和 P / V 操作
信号量是一种特殊的变量，对它的操作都是原子的。对信号量的操作分为 `down` 和 `up`，分别对应 P 操作和 V 操作。P、V 来自于荷兰语：Probeer (try)、Verhoog (increment)。V 操作会增加信号量 S 的数值，P 操作会减少它。

* 执行 `down` 操作时，如果信号量值为 0，会使这个进程睡眠，否则，将信号量减 1
* 执行 `up` 操作时，如果这个信号量上有正在睡眠的进程，就唤醒它，信号量值不变；否则，将信号量加 1

如果信号量只有二进制的 0 或 1，称为二进制信号量（binary semaphore）。二进制信号量可以用来实现一个互斥锁（Mutex）。

## 常见的同步问题及其伪码实现

### (1) 生产者与消费者问题

也称有限缓冲问题。生产者和消费者共享固定大小的缓冲区，生产者向缓冲区写入数据，消费者从缓冲区读出数据，生产者不能在缓冲区满时加入数据，消费者也不能在缓冲区空时消耗数据。

要解决该问题，就必须让生产者在缓冲区满时休眠，等到下次消费者消耗缓冲区中的数据的时候，生产者才能被唤醒，开始往缓冲区添加数据。消费者同理。

这里如果直接使用操作系统提供的 `sleep()` 和 `wakeup()`，可能发生**死锁**，原因在于：「判断是否要休眠（缓冲区空/满）」和「执行 `sleep()`」不是一个**原子操作**，有可能在执行 `sleep()` 之前被切换到另一个程序，导致 `wakeup()` 信号丢失，最后两者都进入休眠（见[维基百科-生产者消费者问题][wiki_producer_consumer]）。

使用**信号量**可以解决上述问题。只有 `down` 操作会使进程休眠，所以要分别使用两个信号量：
* 空槽数 `empty`：`empty` 为 0 时消费者进入休眠，不再消费
* 满槽数 `full`：`full` 为 0 时生产者进入休眠，不再生产

在多个生产者和消费者的情况下，有可能出现两个或以上的进程同时读或写同一个缓冲区槽的情况，因此再用一个**二值信号量 `mutex`** 实现一个锁。

完整代码如下：

```c
#define N 100             // 缓冲区槽数目
typedef int semaphore;    // 定义信号量这个数据类型
semaphore mutex = 1;      // 只能是 0 或 1，实现对临界区的互斥访问
semaphore full = 0;       // 满槽数
semaphore empty = N;      // 空槽数

void producer() {
  while (true) {
    down(&empty);         // 空槽数目减 1，如果空槽数为 0，睡眠，等待 up 操作唤醒
    down(&mutex);         // 如果空槽数不为 0，进入临界区
    produce();
    up(&mutex);           // 离开临界区
    up(&full);            // 满槽数目加 1
  }
}

void consumer() {
  while(true) {
    down(&full);          // 满槽数目减 1，如果满槽数为 0，睡眠，等待 up 操作唤醒
    down(&mutex);         // 如果满槽数不为 0，进入临界区
    consume();
    up(&mutex);           // 离开临界区
    up(&empty);           // 空槽数目加 1
  }
}
```

### (2) 读者写者问题
* 允许多个进程同时读数据库
* 有进程在读数据库的时候，不允许写数据库
* 如果有一个进程正在写数据库，则不允许其他任何进程访问数据库

```C
typedef int semaphore;      // 定义信号量这个数据类型
semaphore database = 1;     // 控制对数据库的互斥访问
semaphore mutex = 1;        // 控制对 rc 的互斥访问
int rc = 0;                 // readerCount, 当前数据库中的读者数量

void reader() {
  while (true) {
    // 准备读取
    down(&mutex);           // 获取对 rc 的访问权限
    rc++;                   // 读者加 1
    if (rc == 1)            // 如果是第一个读者，那么它首先需要取得数据库的访问权限，否则直接进入
      down(&db);            
    up(&mutex);             // 释放对 rc 的访问权限
    read();
    // 读取完毕
    down(&mutex);           // 获取对 rc 的访问权限
    rc--;                   
    if (rc == 0)            // 如果是最后一个读者，释放对数据库的访问权限
        up(&db);       
    up(&mutex);             // 释放对 rc 的访问权限
  }
}

void writer() {
  while (true) {
    down(&db);              // 获取数据库的访问权限
    write();
    up(&db);                // 释放对数据库的访问权限
  }
}
```

<details markdown="1">
<summary>Personal Notes</summary>

因为允许多个读者同时访问数据库，只有修改完 `rc` 后才知道是否应该获取数据库访问权限，所以读者程序中先 `down(&mutex)` 再判断是否要 `down(&db)`。

在整个读取 `rc` 的阶段都需要持有 `rc` 的锁。下面这种写法有问题：

```c
down(&mutex);           // 获取对 rc 的访问权限
rc++;                   // 读者加 1
up(&mutex);             // 释放对 rc 的访问权限
// 这里可能切换到其他读者
if (rc == 1)            // 如果是第一个读者，那么它首先需要取得数据库的访问权限，否则直接进入
  down(&db);            
```
</details>


### (3) 浴室洗澡问题

一个浴室，当有一个女生在浴室里，其他女生可以进入，但是男生不行，反之亦然。

```C
typedef int semaphore; 
semaphore mutex = 1;             // 控制对浴室的互斥访问
semphore boymutex = 1;           // 控制对男生数量的互斥访问
semaphore girlmutex = 1;         // 控制对女生数量的互斥访问
int boyCount = 0, girlCount = 0; // 男生的数量与女生的数量

void boy () {
    while (true) {
        P(boymutex);             // 获取男生数量的锁
        if (boyCount == 0)       // 如果是第一个进入澡堂的，则获取浴室的锁
            P(mutex);           
        boyCount++;         
        V(boymutex);            // 释放男生数量的锁
        
        bath();                 
        
        P(boymutex);            // 获取男生数量的锁
        boyCount--;            
        if(boyCount == 0)       // 如果男生已经都走了，释放浴室的锁
            V(mutex);           
        V(boymutex);            // 释放男生数量的锁
    }
}

void girl(){
    while (true) {
        P(girlmutex);         
        if (girlCount == 0)      
            P(mutex);      
        girlCount++;      
        V(girlmutex); 
        
        bath();        
              
        P(girlmutex);        
        girlCount--;        
        if(girlCount == 0)
            V(mutex);
        V(girlmutex);
    }
}
```

### (4) 哲学家就餐问题

假设有五位哲学家围坐在一张圆形餐桌旁，吃饭或者思考。每位哲学家之间各有一根筷子，哲学家必须用两根筷子吃东西。他们只能使用自己左右手边的那两根筷子。

可能有死锁的写法：每个哲学家都拿着左边的筷子，永远都在等右边的筷子。

```c
typedef int semaphore;
semaphore s[N];

void getforks() { 
    down(&s[left(p)]);  // 尝试获取左边的筷子
    down(&s[right(p)]); // 尝试获取右边的筷子
}

void putforks() { 
    up(&s[left(p)]);    // 放下左边的筷子
    up(&s[right(p)]);   // 放下右边的筷子
}
```

至少一个哲学家的获取筷子的顺序要与其他人不同，以**打破环路等待条件**：

```c
void getforks() {
    if (p == 4) { 
        down(&s[right(p)]); 
        down(&s[left(p)]); 
    } else { 
        down(&s[left(p)]); 
        down(&s[right(p)]); 
    }
}
```

---
参考资料：
* [维基百科-生产者消费者问题][wiki_producer_consumer]


[wiki_producer_consumer]: https://zh.wikipedia.org/wiki/%E7%94%9F%E4%BA%A7%E8%80%85%E6%B6%88%E8%B4%B9%E8%80%85%E9%97%AE%E9%A2%98