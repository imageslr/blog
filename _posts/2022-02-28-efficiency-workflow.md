---
layout: post
title: ⚙️【方法论】我的效率提升方法论 - 工具使用篇 ⑥
date: 2022/5/1 23:00
last_modified_at: 2023/3/14
toc_h_max: 3
typora-root-url: ../
typora-copy-images-to: ../media
---

## 〇、前言

现在市面上有太多的效率工具，我们很容易陷入一个误区：喜欢体验新鲜的工具，但没有明确的使用目的，仅仅是为了好玩，或者以为能提高生产力，到头来却发现是在浪费时间。因此在选择工具时，我参考了一些通用思维 ([📥 收件箱]({% post_url 2021-08-07-efficiency-01 %}) [🔖 工作区]({% post_url 2021-09-28-efficiency-workspace %}) [🪒 奥卡姆剃刀]({% post_url 2021-08-07-efficiency-01 %}#advice))，先思考自己需要哪些功能，再去寻找提供这些功能的工具，在不同场景下构建了类似的工作流 (Workflow)。这样可以降低系统的复杂度，减轻工具带来的认知负担。

本文分享了我在日常工作场景中使用的一些效率工具，操作系统是 macOS。

> macOS 的初始化可以参考 [💻 从零开始配置高效 Mac 开发环境]({% post_url 2020-03-19-mac-initialization%})。

## 一、浏览器

### 标签页管理

#### 场景

尽管我是一名程序员，但实际上我用浏览器的时间比写代码的时间还长，60% 以上的工作时间都是在 Chrome 浏览器中度过的：

<img src="/media/image-20220227231120572.png" alt="image-20220227231120572" style="zoom:50%;" />

图：Chrome 的使用时间远超写代码的时间
{: .caption}

浏览器已经快成为一个新的操作系统，无论是看文档、查资料、做表格、写周报，都离不开它。这导致我们常常会打开很多个标签页。据我观察，身边大多数同事的 Chrome 浏览器都是这样的：

![image-20220213190712070](/media/image-20220213190712070.png)

同时打开这么多的标签页，带来的问题也很明显：

1. 浏览器占用了大量 CPU 和内存，导致系统运行卡顿。
2. 只能看到图标，看不到标题，无法快速找到特定的标签页。

对于第一个问题，可以安装 [Tab Suspender](https://chrome.google.com/webstore/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh) 插件解决，这个插件可以自动暂停长期未查看的标签页，节省内存。对于第二个问题，我安装过一些标签页搜索插件，Chrome 后来也提供了[内置的标签页搜索功能](https://support.google.com/chrome/answer/10490587?hl=zh-Hans)，但这些方式都需要手动输入标签页的标题，很不方便。

<img src="/media/image-20220308100927844.png" alt="image-20220308100927844" style="width:300px;" />

图：Chrome 内置的标签页搜索功能
{: .caption}

我也尝试过使用 Chrome 自带的标签页分组功能，临时折叠一些标签页。但这个功能有点鸡肋：各个分组默认放在同一个窗口中，分组间的界限不明显，同时展开多个分组时，标签页还是被挤的只剩下个图标，而且 Chrome 关闭后分组信息也没了。

![image-20220308100505029](/media/image-20220308100505029.png)

图：Chrome 内置的标签页分组功能
{: .caption}

#### 方案

我用 [🔖 工作区]({% post_url 2021-09-28-efficiency-workspace %}) 思维解决了「浏览器标签页管理」的问题。

**工作区思维的第一个要点：完成特定任务的场所、一系列关联资源的集合**。我将 Chrome 分成多个窗口，每个窗口是一个“工作区”，包含和某项工作相关的全部标签页。通过将不同工作的上下文独立开来，可以减少混乱、提升注意力。

但是多窗口也带来一个问题：不同窗口间切换比较麻烦。Mac 系统的 `Command + Tab` 快捷键无法在相同应用间切换，``Command + ` `` 快捷键可以在同一个应用的不同窗口间切换，但没有预览界面。因此只能激活调度中心、肉眼判断每个窗口的内容是什么、然后选择一个窗口。

![Xnip2022-02-27_23-39-51](/media/Xnip2022-02-27_23-39-51.jpg)

图：Mac 触控板四指上划，打开调度中心，在多个 Chrome 窗口间切换
{: .caption}

安装 [AltTab](https://alt-tab-macos.netlify.app/) 插件可以完美地解决上述问题。这是一个即装即用的 Mac 窗口切换增强工具，按下 `Command + Tab` / `` Command + ` `` 切换窗口时可以显示缩略图。详细配置方法见[这里]({% post_url 2021-09-28-efficiency-workspace %}#alt-tab)。

![image-20220313233854266](/media/image-20220313233854266.png)

图：安装 AltTab 之后，按下 ``Command+` `` 切换窗口时，会显示缩略图
{: .caption}

**工作区思维的第二个要点：自动保存、用完即走、一键恢复**。上面这套工作流的问题在于：Chrome 退出后，所有分组信息会全部消失。我习惯在周末关闭工作相关的窗口，周一再重新打开。有没有一个工具，能够自动保存我每个窗口的页面、在关闭后也能一键恢复？

经过一番搜寻，我找到了 [Workspaces](https://chrome.google.com/webstore/detail/workspaces/hpljjefgmnkloakbfckghmlapghabgfa) 插件。尽管这是一个比较小众的插件，但是它和工作区思维完美契合：允许将多个标签页创建为一个工作区、**自动保存**当前工作区中打开的标签页、在重新打开工作区时**自动恢复**。

我将常用的场景、进行中的工作都保存成了工作区：

<img src="/media/image-20220502000307963.png" alt="image-20220502000307963" style="zoom:50%;" />

图：我的工作区列表
{: .caption}

有了这个插件，我不需要再同时打开很多个标签页或窗口，而是可以根据当前关注的事项，**按需打开工作区**。当我需要处理某项工作时，打开对应的工作区；处理完之后，直接关闭整个窗口。**随用随开、用完即走**，这极大限度地降低了干扰，减少了上下文切换的开销。


#### 总结

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**推荐的工作流：**
{: .mb-1}
1. 安装 [Workspaces](https://chrome.google.com/webstore/detail/workspaces/hpljjefgmnkloakbfckghmlapghabgfa) 插件：
  * 按照「场景」或「项目」划分工作区。
  * 随时关闭某个不使用的工作区窗口，用的时候再打开。
  * 激活 Workspace 插件的快捷键是 `Alt + w`。
2. 安装 [AltTab](https://alt-tab-macos.netlify.app/) 插件，通过快捷键 ``Cmd + ` `` 快速切换窗口。
3. 安装 [TabSuspender](https://chrome.google.com/webstore/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh) 插件，暂停长期不使用的标签页，节省内存。
4. <details class="mb-0"><summary style="margin-bottom:0">安装 <a href="https://github.com/imageslr/chrome-tab-modifier">TabModifier</a> 插件，为标签页提供一个有辨识度的标题。</summary>下图左面两个标签页是不同的微服务，但使用了相同的标题；右面两个标签页则使用 TabModifier 插件修改了标题，更容易区分：<img src="/media/image-20220403233646549.png"></details>
5. <details class="mb-0"><summary style="margin-bottom:0">将窗口命名为工作区名称，切换或选择时会更具辨识度。</summary>
下面是默认的表现，每个窗口的名称是当前打开的标签页标题：<div>
<img width="45%" src="/media/image-20220404172500460.png" >
<img width="45%" src="/media/image-20220404172455221.png" ></div>
下面是修改窗口名称后的表现：<div>
<img width="45%" src="/media/image-20220404173002939.png" >
<img width="45%" src="/media/image-20220404173047815.png" ></div>
操作方式：在标签栏空白区域右键 - 为窗口命名，或者菜单栏 - 窗口 - 为窗口命名。</details>

</div>

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**用 [📥 收件箱]({% post_url 2021-08-07-efficiency-01 %}) 和 [🔖 工作区]({% post_url 2021-09-28-efficiency-workspace %}) 思维管理标签页和窗口：**
{: .mb-1}
1. 打开一个 Inbox 窗口。Inbox 窗口是一个收件箱，放在这里的标签页全是**待处理**的，例如“待阅读”“待填写”“待评审”等。处理完后关闭。
2. 控制工作区窗口的数量。人的注意力是有限的，最多同时处理 2~3 件事。因此，最多同时打开三个工作区，当前不用的工作区通通关闭，减少分神。
2. 每个打开的标签页，都需要**定期整理**：要么移动到 Inbox 窗口，表示待处理；要么分配到特定的工作区窗口，持久保存；要么关闭。
3. 不需要每打开一个标签页就立刻整理。可以先进行手头的工作，等闲下来之后再整理。

</div>

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**如何在地址栏搜索标签页：**
{: .mb-1}

输入标题或 url 的内容，点击“切换到标签页”：

![image-20220407000918703](/media/image-20220407000918703.png)

</div>


### 书签管理

书签管理也是浏览器一个很重要的话题。我们会把任何可能有用的、或者感兴趣的网页存成书签，但往往是收藏的时候很顺手，想用的时候却找不到。下面是我解决这个问题的方法。

#### (1) 为书签设置一个有意义的名称

**Chrome 的地址栏支持搜索书签和历史记录**。输入**标题**或 **url** 中的关键字，会加粗显示：

![image-20220415000222673](/media/image-20220415000222673.png)

图：在地址栏搜索关键字，会在标题和 url 中加粗显示
{: .caption}

因此，可以为每个书签设置一个有意义的名称。当需要查找一个书签时，直接在地址栏输入几个关键字，比先思考它属于哪个类别、再去查找对应的文件夹要更方便。

我采用`[平台]名称` 的命名方式，比如 `[Gitlab]imageslr/blog`、`[TCC]ad.engine.api`。这里可以配合 [TabModifier](https://github.com/imageslr/chrome-tab-modifier) 插件，使标签页的标题和书签名称一致。

书签名还可以添加一些辅助搜索的 **SEO 短语**，比如 `性能平台-云服务` 可以修改为 `性能平台-云服务|golang pprof|profile|服务性能优化|内存泄露排查`：

![image-20220410234734913](/media/image-20220410234734913.png)

图：添加一些描述页面功能的、合乎直觉的、在搜索时很容易能回想起来的短语
{: .caption}

当书签名足够有信息量时，我们甚至不需要书签栏，直接在地址栏搜索关键字就能打开想要的书签。事实上，我在使用浏览器时，书签栏就始终是隐藏状态。

💡 这里再推荐一个 Chrome 插件：[Holmes](https://chrome.google.com/webstore/detail/holmes/gokficnebmomagijbakglkcmhdbchbhn)。安装后，在地址栏输入 `*` 再按 `Tab`，就能搜索书签了。
{: .ant-alert .ant-alert-info}

#### (2) 使用文件夹管理书签

不要把书签直接保存在书签栏上，而是要放在文件夹里。书签的标题会占用书签栏的空间。

不需要创建层层嵌套的文件夹。一般来说，在书签命名良好的情况下，我们可以很快搜索到想要的内容。因此，书签的文件夹只需要简单的划分，粒度可以粗一些，层级可以扁平一些。[附录](#bookmark)是我的书签分类方式。

#### (3) 将参考资料移动到别处

许多书签实际上是”参考资料“ —— 或者是对某项工作有用的参考文档，或者是一些学习资料，又或者是一些感兴趣的文章。我们需要定期整理书签栏，将这些”参考资料“移动到别处：

* 某项工作的参考文档：移动到这项工作的项目文档。
* 学习资料：移动到学习笔记，或者移动到任务清单，作为一个 TODO。
* 感兴趣的文章：移动到稍后读工具。

总之，”参考资料“应当移动到特定的*上下文* 中，而不是放在书签栏里石沉大海。书签栏只保留那些需要经常打开的、真正有用的页面，减少干扰，易于维护。

## 二、Alfred

Spotlight 是 Mac 系统内置的一个快速搜索工具。市面上有一些类 Spotlight 工具，提供了不输于原生 Spotlight 的搜索功能、丰富的效率工具、以及高度的自定义能力。最常见的是 [Alfred](https://www.alfredapp.com/)、[uTools](https://u.tools/)、[Raycast](https://www.raycast.com/)，网上有很多介绍这三个工具的文章，此处不再赘述。

个人认为，这类工具提升效率的关键在于：**(1) 多用键盘，少用鼠标；(2) Don't Repeat Yourself**，通过自定义配置，减少重复操作。下面会举例说明。

我使用的是 Alfred。它的功能很全，插件丰富，就算不折腾，默认功能也已经足够好用。下面罗列了一些我常用的功能。

💡 在 2023 年的今天，我更推荐使用 [Raycast](https://www.raycast.com/)。它涵盖了 Alfred 的几乎所有功能，但界面更美观、更易用。[附录](#raycast)是 Raycast 和 Alfred 的对比。
{: .ant-alert .ant-alert-info}

### 基本设置

* 快捷键：双击 `Alt`。这样一只手就能激活 Alfred。
* 关闭 `Shift` 预览：Preferences - Features - Previews - Quick Look (取消勾选)。这个预览功能其实没啥用，还很容易误触。

### 打开 / 切换 App

<div class="ant-alert ant-alert-info" markdown="1">
👎&nbsp;&nbsp;&nbsp;鼠标移动到 Dock 栏，点击图标。  
👍&nbsp;&nbsp;&nbsp;激活 Alfred，输入 App 拼音的前几个字母，回车。
</div>


操作鼠标是一个很低效的动作。每次都需要右手先离开键盘、找到鼠标、移动和点击、再把手放回键盘，重新校准手指位置；这个过程中，眼睛还必须配合鼠标指针的移动。

建议使用 Alfred 充当 App 启动器。输入 App 名称 (拼音或首字母) 即可启动，双手不需要离开键盘，速度更快、更方便。

<img src="/media/image-20220413231612708.png" alt="image-20220413231612708" style="zoom:33%;" />

图：使用 Alfred 查找 App，按 `Cmd + n` 打开
{: .caption}

此外，还可以为常用的 App 配置**全局快捷键**，便捷切换可见状态。配置方法见 Preferences - Workflows - 右下角加号 - Getting Started - Hotkeys。比如我把 `Alt+Q`、`Alt+E`、`Alt+F` 分配给了提醒事项、飞书和微信。

<img src="/media/image-20220413230408023.png" alt="image-20220413230408023" style="zoom: 25%;" />

图：配置一个简单的 workflow，就可以通过快捷键显示 / 隐藏 App
{: .caption}

### 剪贴板历史 / Snippets

<div class="ant-alert ant-alert-info" markdown="1">
👎&nbsp;&nbsp;&nbsp;使用两个工具，分别管理剪贴板历史和代码片段，资源占用大、操作流程长。  
👍&nbsp;&nbsp;&nbsp;使用 Alfred 解决所有问题。
</div>



Alfred 内置了剪贴板历史工具，非常好用，且资源占用小。我用它替换了 iPaste。配置方式：

* Preference - Features - Clipboard History，我的快捷键是 `Cmd + Shift + V`
* 勾选上 `Keep Plain Text`、`Keep Images` 和 `Keep File List` 以同时保存文本和文件
* 在“Advanced”里勾选 `Auto-paste on return`，这样按下回车后就会自动粘贴

这之后就可以通过快捷键查看历史记录了。上下键选择某条记录，回车粘贴，也可以通过 **`Cmd + 数字`** 直接选择；支持输入关键字搜索。

![Clipboard History](/media/clipboard-viewer.png)

Alfred 剪贴板工具的最赞之处在于能够**和 Snippets 联动**。

Alfred 内置了一个 Snippets 管理工具，可以创建多个清单来管理自己的代码片段：

![Snippets Prefs](/media/snippets-prefs.png)

我把经常执行的一些命令保存成了代码片段，这之后就可以直接在剪贴板历史里查看了，也可以根据关键字搜索代码段的名称或内容：

![Snippets Viewer](/media/snippet-viewer-this-land.png)

**剪贴板历史的内容，可以直接保存到 Snippets 里**。只需要呼出剪贴板历史工具，选中一行，然后按 `Cmd + S` 快捷键。强烈推荐使用这个功能，大幅降低录入成本。

Snippets 的详细使用说明见 [Alfred 官网](https://www.alfredapp.com/help/features/snippets/)。

### 搜索文件

<div class="ant-alert ant-alert-info" markdown="1">
👎&nbsp;&nbsp;&nbsp;在 Finder 中手动查看每个文件夹，或者使用 Finder 的搜索功能。  
👍&nbsp;&nbsp;&nbsp;激活 Alfred，输入文件名，回车。
</div>


Alfred 的搜索功能很强大。只需记住这两个命令：
* `空格 + 文件名`：按文件名搜索，支持拼音。
* `in + 字符串`：按文件内容搜索。

<img src="/media/image-20220413232520845.png" alt="image-20220413232520845" style="zoom:33%;" />

图：空格 + 文件名，搜索文件
{: .caption}

<img src="/media/image-20220413232728058.png" alt="image-20220413232728058" style="zoom:33%;" />

图：in + 文件名，搜索文件内容
{: .caption}

选中搜索结果后，按 `Enter` 打开文件，按 `Command + Enter` 打开文件所在的文件夹。

此外，还可以自定义<b>搜索过滤器</b>，获得更精确的搜索结果。比如我经常会搜索自己的笔记，格式都是 markdown，于是便配置了一个只搜索 <code>.md</code> 文件的 workflow。配置方法见[附录](#file-filter)。

<img src="/media/image-20220414000949319.png" alt="image-20220414000949319" style="zoom:33%;" />

图：自定义 Workflow，只搜索 markdown 文件，既能搜索文件名，也能搜索文件内容
{: .caption}

### Web Search
{: #web-search}

<div class="ant-alert ant-alert-info" markdown="1">
👎&nbsp;&nbsp;&nbsp;打开浏览器 - 进入搜索页 - 点击搜索栏 - 输入搜索内容 - 回车  
👍&nbsp;&nbsp;&nbsp;激活 Alfred - 输入搜索内容 - 回车
</div>


Web Search 是 Alfred 的一大特色功能。在 Alfred 输入要搜索的内容、回车，就可以立刻打开搜索结果页。

Alfred 内置了很多搜索引擎 (Preferences - Features - Web Search)：

<img src="/media/web-search-prefs.png" alt="Web Searches" />

使用时，需要输入搜索引擎的 `Keyword`，然后在空格后输入要搜索的内容，例如 `google something`、`gmail something`。

**可以将常用的搜索引擎设置为默认结果**，这样就不需要输入关键字了。配置路径在 Preferences - Features - Default Results - Fallbacks - Setup fallback results：

<img src="/media/image-20220417003831536.png" alt="image-20220417003831536" />

图：新增默认搜索结果
{: .caption}

我设置的 fallback results 是 **Google** 和**公司内网搜索**：

<img src="/media/image-20220417001602114.png" alt="image-20220417001602114" style="zoom:33%;" />

图：输入任何内容，都可以在 Google 或内网搜索，回车或 Command+2 打开结果页
{: .caption}

**Alfred 还可以自定义 Web Search**。我们每天除了使用 Google 等搜索引擎，还会在公司的许多内部平台搜索，比如搜索代码库、搜索机器 IP、搜索内网等。这些平台的搜索功能都可以配置为自定义 Web Search，从而省去和浏览器的交互。配置方法见[附录](#web-search-config)。

**格式固定的 url 也可以配置为 Web Search**。比如：

* github 的链接格式是 `github.com/用户名/仓库名`，我配置了一个 Web Search：`https://github.com/{query}`。之后在 Alfred 中输入 `github vuejs/vue`，就可以直接打开 [https://github.com/vuejs/vue](https://github.com/vuejs/vue)。
* 公司内部服务平台的链接格式是 `https://cloud.xxx.net/service/服务名`，我也配置成了 Web Search：`https://cloud.xxx.net/service/{query}`，这样连搜索的步骤都省下了。

最后，**尽量通过 Alfred 执行搜索操作**。只需专注于内容本身，完全不需要任何浏览器操作。

💡&nbsp;&nbsp;&nbsp;字节跳动的同学可以在内网搜索“Alfred Web Search 合集”，获取我整理的十余个内部 Web Search 配置。
{: .ant-alert}

### Workflow
{: #workflow}

Workflow 是 Alfred 的核心功能。Workflow 类似于 iOS / Mac 的「快捷指令」，通过可视化的方式串联一系列操作，之后用一个命令直接执行整个流程。很多工作中的重复性操作都可以配置为 Workflow，节省时间，提高效率。

网络上有许多 Alfred Workflow 资源：

* [https://www.alfredapp.com/workflows/](https://www.alfredapp.com/workflows/)
* [https://github.com/alfred-workflows/awesome-alfred-workflows](https://github.com/alfred-workflows/awesome-alfred-workflows)

我常用的是这几个：

* [有道翻译](https://github.com/wensonsmith/YoudaoTranslator)
* [Lark 云文档搜索](https://bytedance.feishu.cn/docs/doccnk9WQ7yWlOLcpAbT072A5ve)
* [MWeb 文档搜索](https://github.com/tianhao/alfred-mweb-workflow)

**Don't Repeat Yourself**。多观察自己有哪些重复的操作，尝试把它配置成 workflow。举个例子，我经常需要执行一个命令，里面包含了 `1.0.1` 这样的版本号，版本号每次执行都不一样。一开始，我是手动填充版本号。后来配置了一个 Workflow，只需要输入版本号，就能自动拼接完整命令，并复制到剪贴板，非常方便。

<img src="/media/image-20220417161324541.png" alt="image-20220417161324541" />

图：输入 curl_code，再输入版本号，就能将命令复制到剪贴板，可以直接去粘贴运行
{: .caption}

Alfred Workflow 的配置教程可以在 [Alfred 官网](https://www.alfredapp.com/help/workflows/) 查看。Alfred 中也内置了许多示例教程，见 Preferences - Workflows - 左下角加号 + 。

## 三、个人知识库

每个人都需要一个知识库。知识库最大的意义是充当大脑外存，帮助我们管理知识，并在需要的时候快速查阅。一方面，我们学习的新知识，如果不经常使用，很快就会忘记，因此需要整理在知识库里，以便日后复习。另一方面，我们总是会遇到各种问题，每次都去 Google 无疑会浪费时间，如果记录在知识库里，下次就可以直接在知识库检索，事半功倍。

在大一时，我就开始有意识地搭建个人知识库，至今已经积累了 1200 多篇笔记。尽管这些笔记里有很多都是偶尔才会打开，但因为都是用自己熟悉的方式记录的，所以往往扫一眼就能回想起完整的上下文，节省了从许多原始资料中筛选重点内容的时间。

我的知识库管理应用是 [MWeb]({%- post_url 2020-03-19-mac-initialization -%}#mweb)。下面是我的一些使用心得。

### All In Markdown
{: #markdown}

Markdown 是一种用来写作的轻量级标记式语言，它使用简洁的纯文本格式来编写文档，可以转换成有效的 HTML 或 PDF 文档。Markdown 最重要的设计是易读易写 —— 语法轻量化；纯文本格式也能够直接在字面上被阅读。

Markdown 不需要像 Word 那样先选中文字、再点击工具栏的图标，常见的排版都可以用键盘完成。使用 Markdown 写作，我们可以专注于内容本身，更流畅地表达自己的思路。

每个程序员都应该学习 Markdown、使用 Markdown。Markdown 的语法十分简单，常用的标记符号不超过十个，几分钟就能掌握。目前许多网站都支持 Markdown 语法，如 Github、少数派、石墨文档、飞书文档等。我的博客也是用 Markdown 写的。

我会优先选择支持 Markdown 完整语法的笔记应用。目前，我使用 [MWeb]({%- post_url 2020-03-19-mac-initialization -%}#mweb) 管理自己的所有笔记；当需要输出长文时，我会配合使用 [Typora](https://typoraio.cn/)。

> [少数派：认识与入门 Markdown](https://sspai.com/post/25137)

### 随手记

**知识的输入**是构建个人知识库的重要一环。我们经常会在各种场景下遇到**碎片化**的信息：或者是与同事交流时，了解到一个业务背景；或者是看某篇文档时，发现一个名词解释；或者是查一个问题时，学到一个新的工具...... 这些知识都是有用的，但我们很少有时间可以停下手头的工作，去整理这些内容。这时，一个**触手可得**的随手记工具就显得尤为重要。

随手记工具是**知识的缓冲区、收件箱**。任何时候，只要遇到有用的知识，就随手记录下来。每隔一段时间，再把随手记的内容整理到个人知识库中。将知识管理分为「收集」和「整理」两步，可以简化知识录入的成本，在不打断当前工作心流的前提下，捕捉每个重要信息。

随手记工具的核心在于**快速**。我使用的是 MWeb 的 [快速笔记](https://zh.mweb.im/15303794142935.html) 功能，按下快捷键，就可以记录 Markdown 内容。随手记工具也可以是和知识库分开的，比如你也可以使用 Mac 的 [快速备忘录](https://support.apple.com/zh-cn/guide/notes/apdf028f7034/4.9/mac/12.0)，或者 Drafts 等任何趁手的工具。重点在于**定期整理**、定期清空随手记中的内容。

💡&nbsp;&nbsp;&nbsp;进一步阅读：[📥 收件箱思维 - 信息管理]({% post_url 2021-08-07-efficiency-01%}#information)
{: .ant-alert}

### 可搜索性

个人知识库的可搜索性很重要。如果每次查阅时都很不方便，那么知识库就失去了作为大脑外存的意义。可以从以下几点来提升知识库的可搜索性：(1) 结构；(2) 标题和内容；(3) SEO 关键词。

#### 结构

当我们在图书馆查找一本书时，可以根据图书分类法，很快定位到一本图书。同理，为知识库设置合理的文件夹层级，也可以帮助我们快速定位一篇笔记。

知识库的结构没有统一的规范，符合个人认知即可。下面是一个示例：

* 工作记录
  * XX 项目开发
  * XX 工具调研
* 源码分析
* 运维手册
* 学习笔记
  * C++
  * Golang
* 个人
  * 面试求职
  * 双月计划
* ...

这里我的建议是：**如非必要，勿增实体**。不要在一开始就设置非常详细的层级结构，这样只会加重选择困难。前期最好只设置必要的文件夹，层级尽量扁平，比如「工作」「个人」「学习」等。之后当笔记的数量积累到一定程度时，再拆分成更细粒度的分组。总之，渐进式地迭代我们的知识库系统，而不是追求一步到位。

#### 标题和内容

1. 标题要有信息量，方便在搜索结果中定位。标题中可以附带一些关键词。
2. 合并内容重复的、相似的笔记，减少搜索结果中的干扰项。

#### SEO 关键词

当我们搜索一篇笔记时，往往想到的都是一些离散的关键词，而不是一句连续的话。因此，可以在正文中添加一些辅助搜索的 [SEO](https://zh.wikipedia.org/wiki/%E6%90%9C%E5%B0%8B%E5%BC%95%E6%93%8E%E6%9C%80%E4%BD%B3%E5%8C%96) 关键词。思考一下，当你看到这篇笔记时，最先想到的是哪些词语，这些词语就可以作为它的关键词。

关键词的格式要特殊一些，以便和正文内容区分，比如我设置的是 `[XXX]`：

<img src="/media/image-20220501211734069.png" alt="image-20220501211734069" style="zoom:50%;" />

图：笔记示例，上面的 `[文件描述符]` `[stderr]` 等就是 SEO 关键词
{: .caption}

搜索时，可以组合搜索关键词和正文内容：

<img src="/media/image-20220501212415500.png" alt="image-20220501212415500" style="zoom:33%;" />

图：使用 [mweb alfred workflow](https://github.com/tianhao/alfred-mweb-workflow) 搜索 MWeb 中的笔记
{: .caption}

### 知识库应用

最后，我们讨论应该如何选择一款知识库应用。

我的知识库应用是 [MWeb]({%- post_url 2020-03-19-mac-initialization -%}#mweb)。对我来说，它的优点是：

* 支持完整的 Markdown 语法，包括 LaTex 公式、流程图等 *(语法完整)*{: .text-gray-400}
* 可以直接在编辑器中粘贴图片，会自动转换为 Markdown 语法 *(写作流畅)*{: .text-gray-400}
* 无限层级的文件夹；文档支持自定义排序 *(文档管理能力)*{: .text-gray-400}
* 开发式文档库，可以使用其他工具编辑、搜索  `.md` 文件 *(可扩展性)*{: .text-gray-400}
* 内置的「快速笔记」功能 *(输入 → 整理 → 输出一条龙)*{: .text-gray-400}
* Mac 原生应用，也有 iOS App *(比网页响应速度更快)*{: .text-gray-400}
* 支持自定义主题

缺点是：

* 不支持所见即所得 *(但可以使用 Typora 写作、MWeb 专注于文档管理)*{: .text-gray-400}
* 搜索能力一般，不支持正则表达式 *(可以自己开发一个 alfred workflow，但成本较高)*{: .text-gray-400}
* 因为文档在 Mac 本地存储，使用 iCloud 同步，所以 iOS 加载文档的速度较慢 *(但我几乎不使用 iOS 查看笔记)*{: .text-gray-400}
* 不支持双向链接

类似的知识库应用还有[思源笔记](https://b3log.org/siyuan/download.html)， 支持本地文档库、双向链接、所见即所得。此外还有 Web 版的知识库应用，如[飞书云文档](https://www.feishu.cn/product/docs)、[Notion](https://www.notion.so/zh-cn) 等。这些应用都支持 Markdown 语法，功能上各有优劣，请按实际需求选用。如果读者有推荐的知识库应用，也欢迎评论区补充。

## 四、理念

### 如非必要，勿增实体

* 使用一组简单的工具，完成不同的需求；而不是使用一个复杂的工具，完成全部的需求。
* 使用一个复杂的工具时，前期只使用必要的功能。不要强行迎合软件，而是要根据实际需求，渐进式地选用新功能。

### Don't Repeat Yourself

* 经常需要复制粘贴的内容 (如地址、邮箱、发票抬头、工号等)，存成 Snippet。电脑上可以使用 [Alfred Snippet](https://sspai.com/post/46034)；手机上可以使用备忘录，或者在输入法中配置快捷短语。
* 重复性操作，配置成 [快捷指令](https://support.apple.com/zh-cn/guide/shortcuts-mac/apd163eb9f95/mac) 或 [Alfred Workflow](#workflow)。

### 善用 SEO 关键词

SEO 关键词可以增加信息量，提升检索效率。下面这些位置可以添加 SEO 关键词：

* Chrome 书签标题
* 笔记标题、笔记内容
* 文件名
* *... (所有要查找的位置)*{:. text-gray-400}

### 多用键盘，少用鼠标

1. 使用 Alfred 作为 App 启动器；使用 Alfred 搜索文件；配置 [Alfred Web Search](#web-search)。
2. **学会这几个文本操作快捷键**，适用于任何文本编辑的场景：
    * 移动光标：
      * 移动一个字符：`←`、`→`
      * 移动一个单词：`Alt + ←`、`Alt + →`
      * 移动到行首 / 行尾：`⌘Cmd + ←`、`Cmd + →`，或者 `Ctrl + a`、`Ctrl + e`
    * 选中文本：
      * 选中一个字符：`Shift + ←`、`Shift + →`
      * 选中一个单词：`Shift + Alt + ←`、`Shift + Alt + →`
      * 选中到行首 / 行尾：`Shift + Cmd + ←`、`Shift + Cmd + →`
    * 删除文本：
      * 删除一个字符：`← Backspace`
      * 删除一个单词：`Alt + ← Backspace`
      * 删除到行首：`Cmd +  ← Backspace`
    * 你会发现其中的一些模式：`Alt` 操作单词、`Cmd` 操作整行、`Shift` 选中文本。
3. 一些有用的快捷键：
  * `Cmd + A` (全选)、 `Cmd + Z` (撤销)、`Cmd + Shift + Z` (重做)
  * 文本编辑器： `Cmd + B` (加粗)、`Cmd + I` (斜体)、`Cmd + U` (下划线)
  * Chrome 左 / 右切换标签页：`Cmd + Shift + [` 、`Cmd + Shift + ]`
  * Mac 切换应用窗口 (建议配合 [AltTab](https://alt-tab-macos.netlify.app/) 使用)：
    * 不同应用程序：`Cmd + Tab`、`Cmd + Shift + Tab`
    * 相同应用程序：`` Cmd + ` ``
4. **不同的软件快捷键可以配置成一样的，便于记忆**。比如：
  * 我经常使用飞书云文档、MWeb 和 Typora 编写 Markdown 文件。因为飞书云文档不支持自定义快捷键，所以我把其他两个软件的 Markdown 编辑快捷键都配置成和飞书云文档一样的。
  * Chrome、iTerm2 都可以按 `Cmd + n` (n=1,2,3...) 来切换标签页，我给 VS Code 也配置了同样的快捷键，按 `Cmd + n` 可以切换当前打开的源文件。

💡&nbsp;&nbsp;&nbsp;Mac 的某些应用程序没有提供快捷键配置入口，这种情况下可以在系统偏好设置中更改，详见[附录](#shortcut-config)。
{: .ant-alert .ant-alert-warning}

## 五、我日常使用的工具列表

>  [💻 从零开始配置高效 Mac 开发环境]({%- post_url 2020-03-19-mac-initialization -%})

* 写作：[Typora](https://typoraio.cn/)
* 知识库：[MWeb]({%- post_url 2020-03-19-mac-initialization -%}#mweb)
* 截图：[Xnip](https://zh.xnipapp.com/)
* Mac 应用切换增强插件：[AltTab](https://alt-tab-macos.netlify.app/)，切换应用时显示缩略图
* Mac 窗口布局工具：[Rectangle](https://rectangleapp.com/)
* 划词翻译：[Bob](https://github.com/ripperhe/Bob)
* 稍后阅读：[Cubox](https://cubox.pro/)
* 待办事项管理：[OmniFocus](https://www.omnigroup.com/omnifocus/) *(个人)*{: .text-gray-400}、[滴答清单](https://dida365.com/) *(工作)*{: .text-gray-400}
* 番茄钟：[Stretchly](https://hovancik.net/stretchly/downloads/)
* Alfred 常用 Workflow：
  * [有道翻译](https://github.com/wensonsmith/YoudaoTranslator)
  * [Lark 云文档搜索](https://bytedance.feishu.cn/docs/doccnk9WQ7yWlOLcpAbT072A5ve)
  * [MWeb 文档搜索](https://github.com/tianhao/alfred-mweb-workflow)
* VS Code 常用插件：
  * [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager)：工作区管理
  * [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
* Chrome 常用插件：
  * [Workspaces](https://chrome.google.com/webstore/detail/workspaces/hpljjefgmnkloakbfckghmlapghabgfa)：工作区管理
  * [Tab Suspender](https://chrome.google.com/webstore/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh)：自动暂停长期不活动的选项卡，节省内存
  * [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb)：使用 vim 快捷键操作网页
  * [Open Tabs Next to Current](https://chrome.google.com/webstore/detail/open-tabs-next-to-current/gmpnnmonpnnmnhpdldahlekfofigiffh?hl=zh-CN)：按下 `Cmd + T` 时，在当前标签页的右边新建标签页
  * [GoFullPage](https://chrome.google.com/webstore/detail/gofullpage-full-page-scre/fdpohaocaechififmbbbbbknoalclacl)：网页滚动截图



## 六、附录

### 书签文件夹示例
{: #bookmark}

* 快速入口：经常浏览的网站，比如工作日报、Github Trending、文档库首页等。
* Inbox：待整理的内容。
* Workspace：里面是一些子文件夹，每个子文件夹是一项具体的工作。
* 📒：常用的参考手册、知识库链接。
* ☁️：公司内部的云平台链接，比如代码库、微服务、动态配置中心等。
* Metrics：常用的 metrics 打点。
* Monitor：各种监控大盘。
* Tool：常用的工具，比如 JSON 格式化、DAG 可视化、正则表达式测试等。
* Archive：归档。

<img src="/media/image-20220404211219820.png" alt="image-20220404211219820" />


### Alfred 搜索过滤器配置方法
{: #file-filter}

1. 根据模板创建 Workflow：Preferences - Workflows - 右下角加号 - Examples - Simple File Search。
    ![image-20220414000257947](/media/image-20220414000257947.png)
2. 双击修改 File Filter。
3. 只搜索 `.md` 文件。这里可以把一个 `.md` 文件拖进去，会自动设置文件类型：
    <img src="/media/image-20220413235656912.png" alt="image-20220413235656912" />  
4. 只搜索指定目录：
    ![image-20220414000450840](/media/image-20220414000450840.png)
5. 不仅搜索文件名，也搜索文件内容：
    ![image-20220414000609625](/media/image-20220414000609625.png)

### Alfred Web Search 配置方法
{: #web-search-config}

配置 Web Search 的方法很简单。以 github 为例，首先在搜索框中输入内容，回车：

<img src="/media/image-20220417005255179.png" alt="image-20220417005255179" style="zoom:40%;" />

然后观察搜索结果页的 URL，是否包含了输入的搜索内容 `imageslr/blog`：

```text
https://github.com/search?q=imageslr%2Fblog
```

把 `imageslr/blog` 替换为占位符 `{query}`：

```text
https://github.com/search?q={query}
```

在 Alfred 中新增自定义搜索 (Preference - Features - Web Search - Add Custom Search)：

![image-20220417010021237](/media/image-20220417010021237.png)

然后就可以使用了：

<img src="/media/image-20220417010218015.png" alt="image-20220417010218015" style="zoom:33%;" />

同理，百度搜索的 Search URL 是：

```
https://www.baidu.com/s?wd={query}
```

Google 的 Search URL 是：

```
https://www.google.com/search?q={query}
```

评论区里会不断更新我日常使用的 websearch 配置。

{: #raycast}
### Raycast vs Alfred

本文提到的所有 Alfred 的功能，[Raycast](https://www.raycast.com/) 都有：

1. 打开 App：Raycast 可以直接给某个 App 绑定快捷键。
2. Web Search：在 Raycast 里是 Quicklinks，可以直接粘贴 Alfred 的 Web Search 配置。可以设置 Fallback Result。但不支持重复的 Alias (Keyword)。
3. 剪贴板历史：支持保存文本、图片、文件。按 Cmd + S 同样能保存 Snippets。但 Snippets 不支持分类保存。

其他方面：

1. 快捷键和 Alfred 基本一致，比如按 Cmd + 1、Cmd + 2 等可以快速选择。配置方式和 Alfred 也基本一致，但体验更佳。
2. 快捷笔记 Floating Notes 功能使用很方便，代替了系统的便签。
3. 界面现代，交互丝滑。扩展市场应用丰富，安装简便。新手教程友好。
4. 个人使用完全免费。

因此，建议使用 Raycast 代替 Alfred。

---

Raycast 也可以直接替换某些系统插件：

* [Rectangle](https://rectangleapp.com/)：窗口布局工具。Raycast 提供了完全一致的功能 (Window Management)，且可以直接导入 Rectangle 的快捷键 (Presets)。

### Mac 系统自定义快捷键配置方法

{: #shortcut-config}

以 Typora 为例。点击菜单栏，可以看到这样的操作列表，每个操作标题后面都有对应的快捷键：

<img src="/media/image-20220501232842330.png" alt="image-20220501232842330" style="zoom:50%;" />

进入「系统偏好设置 - 键盘 - 快捷键」，选中「App 快捷键」：

<img src="/media/image-20220501232927238.png" alt="image-20220501232927238" style="zoom:50%;" />

点击 + 号，选择应用程序，输入菜单中的操作标题，输入自定义快捷键，就可以覆盖应用程序的默认快捷键了：

<img src="/media/image-20220501233111588.png" alt="image-20220501233111588" style="zoom:50%;" />

### Tips

* 搜狗输入法：打开“中英文自动输入空格”
* 建议自己申请一个工作专用的 Google 账号，而不是使用公司分配的账号。后者在离职后会被回收。
* 富文本如何转为 Markdown：粘贴到 Typora，再复制成 Markdown 即可。
* 网页如何转为 Markdown：同上。


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
