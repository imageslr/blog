---
layout: post
title: 🔖【方法论】我的效率提升方法论 - 通用思维篇 ③ 工作区
date: 2021/10/4 12:00
last_modified_at: 2022/2/13
toc_h_max: 3
typora-root-url: ../
typora-copy-images-to: ../media
---

## 前言

工作区是进行一类工作、完成一项任务的特定场所。工作区在现实生活中随处可见，比如厨房的灶台、木工、金工的工作台、物理、化学课程的实验桌、工厂车间的操作台等；一个车间、工厂、工业园区也可以看作是大型的工作区。

可以看到，工作区有这样的一些属性：

* **一系列工具的集合 + 完成任务的场所**
  * *灶台：菜刀、案板、燃气灶*
  * *金工工作台：老虎钳、锉刀、铁制长桌*
  * *化学实验桌：试管、内置水槽*
  * *车间：相关联的工序集中放置，流水线布局*
* **提供存放物品的空间**
  * *灶台：壁橱、抽屉、收纳筐*
  * *金工工作台：工具箱、零件盒*
  * *化学实验桌：试管架、柜子*
* **支持定制化，以适应不同的工作需求**
  * *木工 / 金工工作台：可以调节台面高度*
  * *化学实验桌：针对不同类型的实验，可以调整试剂和器皿的组合*

有了工作区，我们便可以在**同一处场所**内完成某项任务，无需频繁变换位置；所有工具触手可得，无需重新整理桌面上的陈列。

---

作为程序员，我们在现实生活中的工作区则要简单得多：一张办公桌、一台电脑、一块显示器、配上鼠标和键盘，就构成了一个工作区。

程序员的日常工作更多是在电脑上展开。我们经常需要**多线程地处理不同工作** —— 例如，写代码时，线上出了问题，需要优先处理；改完代码编译需要很久，可以先去做另一件事，等等。**每次切换工作，也意味着要切换到不同的「上下文」**。这里的上下文，既包括大脑中的工作记忆 *(例如代码中的变量含义、重要接口作用等)*，又包括桌面上打开的应用 *(例如相关的网页、文档、代码等)*。

同计算机中的[上下文切换](https://zh.wikipedia.org/wiki/%E4%B8%8A%E4%B8%8B%E6%96%87%E4%BA%A4%E6%8F%9B)一样，我们每次切换手头的工作时，也会有一定的「开销」。我们的大脑可以保存一段时间内的工作记忆，但在任务切换后，需要花费很大的精力才能重新恢复；当我们从一项任务切换到另一项任务时，也需要重新打开相关的网页、文档和代码文件，找到上次浏览 / 编辑的位置，才能继续推进。在大脑和桌面应用上切换工作上下文的频率越高，浪费的时间就越多，效率也就越低。

针对这个问题，我们可以：**为每个任务设置单独的*虚拟工作区*，尽可能减少工作上下文切换的开销，从而提高工作效率**。这就是「工作区」思维。

许多软件都有「工作区」的概念。本文首先介绍几个常见软件的工作区功能、以及它们可以如何提高工作效率，然后分享一些工作场景中的实践经验。

## 软件中的工作区

### 代码开发

许多 IDE 都提供了「工作区 (workspace) 」功能，例如 [VS Code](https://code.visualstudio.com/docs/editor/workspaces)、[Eclipse](https://www.runoob.com/eclipse/eclipse-workspaces.html)。在这些软件中，工作区是**一个或多个文件夹的集合**，允许用户将各种源代码文件和资源收集在一起，并将它们作为一个有凝聚力的单元进行处理。在复杂的项目中，这样的工作区很有用。

除了汇总文件夹资源，IDE 中的工作区功能还可以：
{: .mb-0}

* 仅针对该工作区的偏好设置 (如主题、字号、快捷键等)。
* 仅针对该工作区有选择地启用或禁用扩展。
* 仅在该工作区上下文中有效的任务和调试器配置。
* 自动保存当前打开的文件和编辑位置，并在下次打开工作区后恢复。

<div class="ant-alert" markdown=1>
💡 提高效率的特性：
{: .mb-1}
  * 一系列资源的集合
  * 针对不同工作需求的个性化定制
  * 自动保存和恢复工作上下文
</div>


### 操作系统

多个工作区在类 Unix 操作系统上很普遍，比如 [Ubuntu 的工作区](http://people.ubuntu.com/~happyaron/ubuntu-docs/precise-html/shell-workspaces.html)、[MacOS 的空间](https://support.apple.com/zh-cn/guide/mac-help/mh14112/mac)等，Windows 10 也引入了[任务视图](https://windows10.pro/win10-multi-desktop-tasks-view/)。

操作系统中的工作区，实际上就是**多个应用程序的集合**。通过将一套关联的应用程序放在单独的桌面中，可以减少混乱，易于切换工作上下文。

常见的桌面工作区划分：

* 通信软件，如电子邮件、聊天程序等。
* 工作软件，如相关网页、文档、IDE 等。
* 写作软件，如思维导图、文本编辑器、参考资料等。

其中，工作软件还可以按照项目进一步划分为多个工作区。

<div class="ant-alert" markdown=1>
💡 提高效率的特性：关联程序集中放置
</div>

### 团队协作

[Trello](https://trello.com/zh-Hans/guide/enterprise/understanding-workspaces#manage-workspace-settings)、[Slack](https://slack.com/intl/zh-cn/) 等团队协作软件，提供了面向团队的工作区。每个工作区是一个单独的页面，就像是一个虚拟的办公室，既提供了交流讨论的场所，也提供了**汇总资源的空间**  *(文档、链接、待办事项、看板等)*，减少了不必要的工作上下文切换。

<div class="ant-alert" markdown=1>
💡 提高效率的特性：提供存放资源的空间，所有资源触手可得
</div>


### 其他软件

简单举几个例子：

* [PhotoShop 的工作区](https://helpx.adobe.com/cn/photoshop/using/workspace-basics.html)：自定义面板、栏以及窗口的排列方式。

* [阿里云工作区](https://help.aliyun.com/document_detail/214467.html)：云桌面工作环境配置的集合。
* Chrome 工作区：每个窗口可以作为一个工作区，包含一组关联的标签页。
* ...

总之，**工作区是一系列资源的集合，目的是完成一项特定的任务，好处是减少切换 / 恢复工作上下文的开销**。

## 如何划分工作区

工作区的目的是完成一项特定的任务，因此每个工作区最好是一个具体的任务 / 项目 (例如新人串讲、第二版需求开发等)。当项目完成后，工具区便可以归档 (archive)。

💡 感兴趣的读者，可以进一步了解 [P.A.R.A 方法](https://sspai.com/post/61459) 中的项目划分原则。
{: .ant-alert}

工作区还可以进一步划分到不同的**分区** (section) 中。这里是一些例子：

* 工作 *#section*{: .text-gray-300}
  * 新人串讲 *#workspace*{: .text-gray-300}
  * XX 模块重构 *#workspace*{: .text-gray-300}
  * XX 需求开发 *#workspace*{: .text-gray-300}
* 个人 *#section*{: .text-gray-300}
  * 毕业旅行 *#workspace*{: .text-gray-300}
  * 稍后阅读 *#workspace*{: .text-gray-300}

可以用添加前缀的方式来实现分区，形如：

* 个人 - 毕业旅行
* 工作 - 新人串讲
* 【个人】毕业旅行
* 【工作】新人串讲

这也是 Slack 推荐的[工作区命名方式](https://slack.com/help/articles/217626408-创建频道命名准则)，使其便于搜索且目的明确。下图是 Slack 中罗列的一些团队协作场景下最常用的前缀：

<img src="/media/image-20210930133510114.png" alt="image-20210930133510114" style="zoom:50%;" />

## 工作区的实践指南

### VS Code

VS Code 自带了[工作区功能](https://code.visualstudio.com/docs/editor/workspaces)，每个工作区可以包含一个或多个关联的文件夹。工作区保存成一个后缀为 `.code-workspace` 的文件。可以个性化配置各个工作区：
* 看代码时，使用深色主题、字号小一点；写作时，使用浅色主题、字号大一点。
* 只开启该工作区必需的插件、关闭无用插件，减少内存占用与快捷键冲突。

推荐安装 [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager) 扩展，可以将任意文件夹 (包括远程服务器的文件夹) 或工作区保存为一个项目 Project。安装后，可以在侧边栏看到所有项目，单击可以直接打开，并且上次关闭时的标签页和浏览位置都会**自动恢复**。

<img src="/media/image-20220213175427261.png" width="400px" />

日常开发时，我会把自己常用的代码库都保存在 Project Manager 中。每次想要查看代码时，通过 Project Manager 一键打开，不需要再去 Finder 中查找文件夹。看完后，直接关闭整个窗口。下次再打开时，又会自动定位到我上次查看的位置。

💡 用完即走，一键恢复。
{: .ant-alert .ant-alert-warning}



### 浏览器
{: #browser}

#### Chrome

浏览器中的工作区，实际上是一组关联的标签页。

Chrome 自带了标签页分组功能，但是默认都在同一个窗口中，不是很方便。推荐一个轻量好用的插件 [Workspaces](https://chrome.google.com/webstore/detail/workspaces/hpljjefgmnkloakbfckghmlapghabgfa)，可以为不同的标签页组创建工作区、**自动保存**当前工作区中的标签页、并在重新打开工作区时**自动恢复**、不同工作区之间可以**快速切换**。

<img src="/media/image-20220213183753158.png" width="200px"/>


工作中，我会把各项工作相关的网页都保存为 Workspaces 插件中的工作区 (见上图)。需要查看时，打开某个工作区；用完后，直接关闭整个窗口；下次打开时，所有标签页又会自动恢复。**用完即走，一键恢复**，有效解决了以下问题：

![image-20220213190712070](/media/image-20220213190712070.png)


Workspaces 插件还可以和以下工具配合使用：

* [AltTab](https://alt-tab-macos.netlify.app/)：强烈推荐的 Mac 插件，切换窗口时可以显示缩略图。安装即用。如果经常需要打开多个浏览器或 VS Code 窗口，那么这个工具非常有用。快捷键和 Mac 系统一致：`Command + Tab` 切换不同应用，`` Command + ` `` 切换当前应用的不同窗口。详细配置方法见[附录](#alt-tab)。
* [Tab Suspender](https://chrome.google.com/webstore/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh)：Chrome 插件，自动暂停长期不活动的选项卡，节省内存。
* 将 Chrome 的窗口命名为工作区名称，切换窗口时更容易区分。具体操作：
  1. 转到想命名的窗口
  2. 右键点击顶部的“打开新的标签页”图标旁边的空白处，然后选择“为窗口命名”。
  3. 或者，依次选择右上角的“更多”图标 - 更多工具 - 命名窗口
  4. 为窗口输入一个名称

最后，可以使用一个单独的窗口作为收件箱[[?](({% post_url 2021-08-07-efficiency-01 %}))]，存放所有新打开的标签页；定时整理这些页面，没用的直接关闭、有用的分配给现有的工作区，或者创建一个新的工作区。

<details markdown="1">
<summary><span markdown="1">Chrome 下还有一个类似的插件 [Workona](https://workona.com/)，功能更丰富，但是现在开始收费了，免费用户最多只能创建 5 个工作区，所以不作推荐。其他的标签页管理插件如 [OneTab](https://chrome.google.com/webstore/detail/onetab/chphlpgkkbolifaimnlloiipkdnihall)、[tabExtend](https://www.tabextend.com/)，本质上都是书签管理器，无法自动保存、自动恢复、快速切换，同样不作推荐。</span></summary>

Workona 插件的主要功能 [[少数派介绍文章](https://sspai.com/post/53985)]：
{: .mb-2}

* 为不同的标签页组创建不同的工作区。
* 自动保存当前打开的标签页，并在重新打开工作区时自动恢复。
* 多个工作区之间可以快速切换。
* 每个工作区中可以保存关联的网页链接、笔记、文件等，关键信息触手可得。

![image-20211027233928088](/media/image-20211027233928088.png)

Chrome 提供了自带的标签页分组功能，所有分组默认都会放置在同一个窗口中。我一般会配合 Workona 使用这个功能，将工作区下的标签页进一步划分为不同的分组：

![image-20211106114044799](/media/image-20211106114044799.png)

</details>


#### Safari

本文撰于 2021 年 9 月。在 10 月更新的 macOS Monterey 系统中，Safari 浏览器也增加了标签页分组功能，这是工作区思维的直接体现。

Safari 的标签页分组功能，整体布局和 Chrome Workona 插件类似，左侧边栏列出了所有工作区，不同工作区之间互相独立，点击即可快速切换。

如果读者日常使用的是 Safari 浏览器，不妨试试这个新增的功能。

![image-20211027234050684](/media/image-20211027234050684.png)


### 桌面

关联的应用可以放在一个桌面，例如：
* 开发项目时的*网页* 和*代码开发工具*
* 写博客时的*参考资料* 和*文本编辑器*
* 聊天工具

这里可以配合窗口调整工具 (例如 [Rectangle](https://rectangleapp.com/))，通过快捷键快速调整应用的大小和位置。

也有一些软件可以帮助管理桌面级的工作区。[Workspaces](https://www.apptorium.com/workspaces) 可以将一系列关联的文件、笔记、网页和应用程序等资源保存成一个*工作区*，随时一键启动，或在不同工作区之间快速切换。[Moom]({% post_url 2020-03-19-mac-initialization%}#moom) 可以保存将桌面各个应用的大小和布局存成一个快照 (Snapshot)，随时一键恢复。

### 终端

如果你在远程服务器上开发，那么对 [tmux](https://www.ruanyifeng.com/blog/2019/10/tmux.html) 应该不陌生。tmux 可以自动保存执行过的命令和会话上下文，即使网络断线，再次登录后还是可以一键恢复。tmux 还可以将终端窗口水平 / 垂直划分为多个区域，以便同时查看各种信息。tmux 就是命令行场景下的工作区插件。


{::comment}
#### 书签

书签也可以用工作区思想来管理。可以创建一个和工作区同名的书签文件夹，用于保存和某项工作相关的网页链接。

> Chrome Workona 插件可以直接在工作区界面保存书签 / 文件等相关资源。

{:/comment}


## 总结

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**工作区的特性：**
{: .mb-2}
<ul class="mt-0 mb-2">
<li>一系列关联工具的集合。</li>
<li>完成特定任务的场所。</li>
<li>提供存放资源的空间。</li>
<li>支持定制化，以适应不同的工作需求。</li>
<li>能够缓存之前的工作状态，并在重新打开工作区时恢复。</li>
<li>不同工作区之间能够快速切换。</li>
</ul>
其中，前四个特性保证了当我们聚焦于某项工作时，可以高效率地推进；后两个特性可以减少工作上下文切换的开销，是多线程工作的关键。

</div>

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**使用工作区的好处：**
{: .mb-0}
* 紧密：相关联的内容、工具放置在一处，触手可得。
* 不打断心流：
  * 即使是最简单的工作，也需要不断地切换标签、窗口和关注点。
  * 使用工作区，可以缩短上下文切换的时间。

</div>

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**一些 Tips：**
{: .mb-0}
* 为工作区命名时，可以采用添加前缀的方式来实现层级结构。
* 每个软件 (Chrome, VS Code 等) 都提供了自己的「工作区」功能，将这些软件放置到同一个桌面，就构成了一个更大的工作区。
</div>



## 附录

{: #alt-tab}
### AltTab 配置方法

AltTab 是 Mac 系统下的一个窗口切换软件，强烈推荐，切换窗口时可以显示缩略图。

按 `Command + Tab` 时，系统的默认效果：

<img src="/media/mac_task_switcher.png" alt="How to Alt+Tab to Switch Windows on a Mac" style="zoom:50%" />

配置好 AltTab 之后的效果：

![img](/media/frontpage.jpg)


安装方法：<https://alt-tab-macos.netlify.app> 直接 Download。

快捷键默认是 `Alt + Tab`，我们把它配置成`Command + Tab` 切换不同应用，`` Command + ` `` 切换当前应用的不同窗口。请参考下面这几张图，勾选上对应的选项：

<img src="/media/image-20230622003428922.png" alt="image-20230622003428922" style="width:48%;display:inline" />
<img src="/media/image-20230622003359057.png" alt="image-20230622003359057" style="width:48%;display:inline" />

参考如下设置，简化外观 (左图)；此外，可以把不需要的应用在 AltTab 里隐藏掉 (右图)：

<div style="display:flex;align-items:center;margin-bottom:20px">
<img src="/media/image-20230622003532521.png" alt="image-20230622003532521" style="width:40%" />
<img src="/media/image-20230622003614015.png" alt="image-20230622003614015" style="width:50%" />
</div>


<div class="ant-alert ant-alert-blue" markdown=1>
**效率提升方法论系列**
{: .mb-2}

* [📥【方法论】我的效率提升方法论 - 通用思维篇 ① 收件箱]({% post_url 2021-08-07-efficiency-01 %})
* [🕖【方法论】我的效率提升方法论 - 通用思维篇 ② 定期回顾]({% post_url 2021-08-13-efficiency-02 %})
* [🔖【方法论】我的效率提升方法论 - 通用思维篇 ③ 工作区]({% post_url 2021-09-28-efficiency-workspace %})
* [🎯【方法论】我的效率提升方法论 - 目标管理篇 ④ OKR]({% post_url 2021-10-28-efficiency-okr %})
* [🔘【方法论】我的效率提升方法论 - 任务管理篇 ⑤ GTD]({% post_url 2021-12-13-efficiency-gtd %})
* [⚙️【方法论】我的效率提升方法论 - 工具使用篇 ⑥ Workflow]({% post_url 2022-02-28-efficiency-workflow %})

</div>

