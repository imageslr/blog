---
layout: post
title: 💻【Mac 相关】从零开始配置高效 Mac 开发环境
date: 2020/3/19 14:00
---

Mac 是大多数程序员的主力机器。如今各个互联网公司都会给员工配备 Mac 电脑，而拿到新电脑不免要鼓捣一番，安装各种环境、插件、软件等，以让自己用着更顺手。

本文记录了我从零开始配置一台新 Mac 的过程，基于我日常的开发习惯。尽管具有一定的主观性，但依然有相当的参考价值，读者可以按需选用。

建议首先完成[系统设置](#system-config)和[科学上网](#terminal-fq)，再进行其他步骤。前者完成 Mac 的一些初步设置，后者提高终端命令如 `brew`、`git clone` 的下载速度。

本文部分内容参考了 [Github - bestswifter/macbootstrap](https://github.com/bestswifter/macbootstrap)。

<div id="system-config"></div>
## 系统设置

### 触控板设置
**开启轻点点按**：“系统偏好设置-触控板-光标与点按-轻点来点按”，打开该选项。这样无需按下触控板即可点击。

**开启三指拖动**：“系统偏好设置-辅助功能-指针控制-触控板选项-启动拖移”，打开该选项，并选择“三指拖移”。这样在移动窗口、拖动选择大片文字等时不需要按下触控板，只需要三指在触控板上拖动即可。

*默认情况下，“左右切换全屏幕窗口”、“显示调度中心”三指/四指均可。开启三指拖动后，这两个操作自动换为四指。*

### 打开 iCloud 同步
在系统偏好设置中登录 Apple ID，打开 iCloud。作用：
1. 在多台设备间共享文件，比如桌面和文稿数据（需要在“iCoud 云盘-选项”中单独打开）
2. 利用 Handoff 在多台设备之间无缝切换，比如我们在旧 Mac 上复制一段文本，可以直接粘贴在新 Mac 里。这在配置新 Mac 环境的时候尤其有用：我们可以在旧 Mac 中查看网页/笔记，复制某一条命令，然后直接粘贴到新 Mac 的终端中执行
3. 下文的许多软件（如 SnippetsLab、Paste、MWeb 等）都可以使用 iCloud 同步。在新 Mac 中下载软件后，可以直接恢复旧 Mac 的数据

### 关闭文件验证、App 验证
跳过打开 DMG 文件时的验证过程：
```
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
```

默认情况下系统禁止安装第三方 App，通过以下代码绕过限制：
```
sudo spctl --master-disable
defaults write com.apple.LaunchServices LSQuarantine -bool false
```

### 禁用文字自动更正
随便打开一个文本编辑框，如“信息”，尝试以下输入会发现：
1. `'` / `"` 被替换为了 `‘` / `“`
2. `sdgs` 被替换为了 `Sdgs`，首字母自动大写
3. `---` 被替换为了 `—`

通过以下命令禁用：
```
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
```

也可以在“系统设置-键盘-文本”中设置。

### 打开全键盘控制
系统经常会出现如下图所示的 Confirm 框，包含“确定”、“取消”两个选项：

![-w444](/media/15846066678989.jpg)
![-w448](/media/15846132021180.jpg)

默认情况下，我们只能通过「回车」选择“确定”，如果想选择“取消”，必须通过鼠标点击。打开全键盘控制后，通过 `Tab` 键切换选项，聚焦到“取消”上，然后按下「空格」，就可以选择“取消”。

在“系统偏好设置-键盘-快捷键”页面下方，打开全键盘控制：
![-w668](/media/15846068903987.jpg)

注意：无论焦点聚焦于哪个选项，按下「回车」都相当于是选择 “确定”。

当然，如果有 Touch Bar，可以直接在 Touch Bar 上完成操作。

### 显示电量百分比
点击状态栏电源图标，选择“显示百分比”。

### 加速 Zoom 动画
双击应用标题栏时，会自动调整窗口大小。下面的代码可以加速调整动画：
```
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
```

下文提到的插件 Moom 也可以快速调整窗口大小。

## 开发环境
### Homebrew
Homebrew 是 Mac 下的软件包管理工具，既可以用来安装开发环境，也可以用来[安装 App Store 应用](https://sspai.com/post/42924)。

安装 Homebrew：
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

如果报错 `Failed to connect to raw.githubusercontent.com port 443: Connection refused`，重开一个终端窗口就可以了。

如果 Homebrew 速度很慢，需要配置[终端科学上网](#terminal-fq)。

### iTerm2
**安装：**
```
brew cask install iterm2
```

**快捷键：**
* 光标移动：
    * `⌃+A/E`：光标移动到开头/结尾
    * `⌃+W/U`：删除光标前一个单词/所有内容
    * `⌥+←/→`：光标左/右移动一个单词（需要配置，见下文）
* Tab 切换：
    * `⌘+T`：新建 Tab
    * `⌘+数字`：选择某一 Tab
    * `⌘+←/→`：左/右切换 Tab
    * 这些快捷键在 Chrome 下也适用
* Pane 相关：
    * `⌘+D` / `⌘+⇧+D`：新建 Pane
    * `⌘+⌥+方向键`：切换 Pane
    * `⌘+⌃+方向键`：调整 Pane 大小
* 文本选择：
    * iTerm2 默认选中即复制，不需要“先选中，再复制”
    * 双击选择单词，三击选择整行，按下 `⌘+⌥` 矩形选择

**如果命令写错怎么办？**
* 简单的方法：`↑`，重新编辑上一条命令
* `^{old}^{new}`：这个命令可以将上一条命令的 `{old}` 部分替换为 `{new}` 重新执行，比如 `vim a.txt` 不小心写成 `vom a.txt`，可以执行 `^vom^vim`
* [thefuck](https://github.com/nvbn/thefuck)：输错一个命令时，直接输入一个 `fuck`，错误自动纠正，瞬间神清气爽
* 对于特别长的命令，可以使用 zsh 提供的快捷键 `Ctrl-x + Ctrl-e` 进入 vim 编辑

**配置“光标左/右移动一个单词”**：“Preferences-Profiles-Keys”，找到快捷键 `⌥←`，双击，弹出如下的对话框，Action 选择“Send Escape Sequence”，`Esc+b` 表示向前移动。双击 `⌥→`，`Esc+` 后面填 `f` 表示向后移动。

![](/media/15846289981455.jpg)

### vim 语法高亮
首先执行 `cp /usr/share/vim/vimrc ~/.vimrc` 复制 vim 配置文件，然后执行 `vim ~/.vimrc`，添加以下内容：
```
syntax on
```

### zsh 插件
Mac 自带了 zsh，执行 `zsh --version` 检查是否安装了 zsh。

**安装 oh-my-zsh：**
```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

当 oh-my-zsh 安装成功后，我们会看到终端的文本不再是单调的白色，而是有了不同的颜色。这是因为 oh-my-zsh 提供了很多主题，可以通过编辑 `~/.zshrc` 中的 `ZSH_THEME` 字段修改，默认是 `robbyrussell`。

**安装 zsh-autosuggestion 与 autojump：**
```
# zsh-autosuggestion
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# autojump
git clone git://github.com/wting/autojump.git
cd autojump
./install.py
```

zsh-autosuggestion 可以根据当前输入的内容，自动提示之前执行过的命令。autojump 可以快速跳转到某个目录，比如当我们执行过 `cd ~/some-file` 后，执行 `j some`、`j so`、`j sf` 都可以跳转到 `~/some-file` 目录下。

安装完后，还需要在 `~/.zshrc` 中加载这两个插件，才能生效。执行 `vim ~/.zshrc`，找到 `plugins=...`，其内容如下所示：
```bash
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
```

改成这样：
```bash
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions autojump)

[[ -s /home/zsh/.autojump/etc/profile.d/autojump.sh ]] && source /home/zsh/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

source $ZSH/oh-my-zsh.sh
```

退出 iTerm2 后重新打开，执行以下命令，验证插件是否安装成功：
1. 验证 autojump：首先执行  `cd ~/Downloads` 跳转到目录 `~/Downloads`，然后只需要输入目录的若干个字符：`j dow`，就可以自动跳转到 `~/Downloads`
2. 验证 zsh-autosuggestions：输入之前执行过的命令的前几个字符，就会自动提示完整命令，按 `→` 可补全

![-w569](/media/15846317408700.jpg)

### Git 配置
`git commit` 要求设置用户名和邮箱，通过以下命令设置，省略 `--global` 只对当前仓库设置：
```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

为常用 git 命令设置更短的别名：
```
[alias]
        last = log -1
        lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow) %d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
        co = checkout
        ci = commit
        st = status
        br = branch
        cp = cherry-pick
```

## 高效插件
### 显示网速：iStat Menus
iStat Menus 可以在状态栏显示网速，有利于判断网络情况：

![-w325](/media/15846130800829.jpg)

### 扩展预览程序：QuickLookPlugins
Mac 的预览程序十分方便，按下空格可以快速预览几乎所有文件，安装插件可以扩展其功能。[Github - sindresorhus/quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins) 提供了一系列可供选用的插件，以及每个插件的介绍、截图、源码。

我选择通过 Homebrew 安装自己需要的几个插件：
```
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize
```

每个插件的功能：
* `qlcolorcode`：增加代码高亮
* `qlstephen`：预览没有后缀名的纯文本文件，如 `README`
* `qlmarkdown`：预览 Markdown 文件，自动渲染
* `quicklook-json`：预览 JSON 文件
* `qlimagesize`：预览图片时，显示图片大小与分辨率

其他插件请在 [Github - sindresorhus/quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins) 自行选用。

### 快速调整窗口大小：Moom
Mac 的一款窗口布局工具，可以快速缩放应用/移动位置，比如将应用布局成以下状态，只需分别点击三下，如果此时将桌面布局保存为一个快照，之后就可以一键恢复布局。

![-w1241](/media/15846201525933.jpg)

默认情况下需要通过鼠标操作，配置全局快捷键后，只用键盘就可以完成全部操作，效率更高：

![-w473](/media/15846215057421.jpg)

我设置的全局快捷键是 `⌘+⇧+M`，`M` 取自 `Moom` 的首字母，方便记忆。

打开“Show cheat sheet”选项，这样在按下快捷键后会显示速查表，功能包括：
1. `Tab`：居中
2. `方向键`：贴合屏幕边缘
3. `⌘+方向键`：调整为屏幕的一半大小，并贴合到屏幕边缘
4. `空格`：最大化
5. `回车`：恢复原始大小和位置
6. `数字键`：自定义布局，在 `Preferences-Custom` 中配置

![](/media/15846215818236.jpg)


### 效率神器：Alfred
Mac 效率神器，不多作介绍。快捷键：
1. `⌥ Alt` + `Space` 打开 Alfred
2. `↑`、`↓` 切换高亮项
3. `⇧ Shift` 使用「预览程序」预览当前高亮项
4. `↩︎ Enter` 选择当前高亮项
5. `⌘ Command` + `数字` 快速选择某一项
6. `⌥ Alt` + `↩︎ Enter`、`⌘ Command` + `↩︎ Enter` 会对当前高亮项执行特殊操作，按下 `⌥` / `⌘` 就会显示功能提示

常见使用场景：
* Google 搜索：`google {query}`
* 计算器
* 有道翻译：[Github - wensonsmith/YoudaoTranslate](https://github.com/wensonsmith/YoudaoTranslate)
* MWeb 文档搜索：[Github - tianhao/alfred-mweb-workflow](https://github.com/tianhao/alfred-mweb-workflow)
* 颜色代码转换：[Github](https://github.com/g1eny0ung/Alfred-Colors-workflow)，16 进制/RGB/HSL 互转，对于前端开发者比较有用

### 代码片段：SnippetsLab
SnippetsLab 可以用来分类整理各个代码片段，在写代码时随时取用。

SnippetsLab 支持 iCloud 同步，这意味着当我们切换到新 Mac 后，可以在 1 秒内立刻恢复所有的代码片段：

![-w517](/media/15846156352773.jpg)

此外，通过 Alfred 插件，可以非常方便地搜索某个代码片段：

![-w577](/media/15846151958103.jpg)

点击查看 [Alfred 插件配置说明/使用方法/下载链接](https://www.renfei.org/snippets-lab/manual/mac/tips-and-tricks/alfred-integration.html)。使用方法：
1. `⌥ Alt` + `Space` 打开 Alfred
2. 输入 `snippet {query}` 查询
3. 快捷键：
    1. `↑`、`↓` 切换选择
    2. `↩︎ Enter` 将当前选择的代码片段复制到剪切板
    3. `⌘ Command` + `数字` 快速选择某一代码片段
    4. `⌥ Alt` + `↩︎ Enter` 在 SnippetsLab 中打开当前选择的代码片段
    5. `⌘ Command` + `↩︎ Enter` 将当前选择的代码片段粘贴到屏幕最前方的应用中


### 记录剪切板历史：Paste
Paste 可以记录剪切板历史。Paste 同样支持 iCloud 同步。
![-w1192](/media/15846159741374.jpg)

快捷键：`⌘ Command` + `⇧ Shift` + `V` 打开 Paste，`⌘ Command` + `数字` 快速复制某一条记录。

<div id="terminal-fq"></div>
### 科学上网
在终端安装 Homebrew、或者执行 `git clone` 时，一般情况下很慢（~100KB/s），需要安装科学上网工具，然后在终端科学上网。

一般互联网公司的 VPN 都自带科学上网功能。如果公司不提供 VPN，可以考虑安装 vxxxy。

<details markdown="1">
1. [Github](https://github.com/Cenmrev/V2RayX) 下载软件并打开
2. “Configure...-Advanced...-Subscription”，粘贴订阅链接（需要自己找）
3. “Server-Update subscription”，选择一个服务器
4. “Load core”，此时浏览器可以科学上网
5. 如果终端需要科学上网：“Copy HTTP Proxy Shell Export Line”，粘贴到终端执行。验证：`curl ip.sb`

</details>

### 微信小助手
[Github - MustangYM/WeChatExtension-ForMac](https://github.com/MustangYM/WeChatExtension-ForMac)

### 快速连接 AirPods：ToothFairy
菜单栏一键连接 AirPods

## 其他软件
### 记笔记：MWeb
MWeb 是一款非常优秀的 Markdown 笔记软件。在尝试过印象笔记、Typora、Bear、Ulysses 等多款软件后，个人认为没有一款软件可以替代 MWeb，后者对 Markdown 与 LaTex 的支持相当完善，同时保持了良好的使用体验。此外，MWeb 也有 iOS 应用，在不内购的情况下可以阅读、编辑笔记，无法新建笔记，足以满足日常需求。

![](/media/15846229381899.jpg)

MWeb 可以通过 iCloud 实现同步，只需要将文档库保存在 iCloud 云盘下即可。每个设备都使用云盘中的文件夹作为 MWeb 的文档库。
![-w619](/media/15846233668366.jpg)

### 待办事项管理：OmniFocus
OmniFocus 是一个 GTD 工具，我使用它来安排我的待办事项。OmniFocus 支持多端同步，数据存储在 OmniFocus 服务器中。

### 每日计划：OmniOutliner
OmniOutliner 是一款简介、专注的大纲制作软件，我使用它来安排我的每日计划。将 OmniOutliner 文件存储在 iCloud 云盘中，可以实现多端同步。

![](/media/15846254446005.jpg)

### 浏览器：Chrome
“系统偏好设置-通用-默认网页浏览器”，选择“Google Chrome”

### PDF 阅读：PDF Expert
PDF 阅读工具

### 代码编辑：VS Code
下载地址: [官网](https://code.visualstudio.com/download)。

下载完成后，打开 VS Code，按下 `⌘ Command` + `⇧ Shift` + `P`，输入 `command`，选择 `Shell Command: Install 'code' command in PATH`。这样就可以在 iTerm2 中，直接打开某个文件夹：
```
code . // 在 VS Code 中打开当前目录
code ~/my-blog // 在 VS Code 中打开 my-blog 目录
code ~/.zshrc // 在  VS Code 中打开 .zshrc 文件，类似于 vim ~/.zshrc
```

## 附件
[百度云](https://pan.baidu.com/s/1SPGJTFN3y6QzzlmAtwgQ1A)，提取码: u4gg