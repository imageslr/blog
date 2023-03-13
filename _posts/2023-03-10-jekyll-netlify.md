---
layout: post
title: 💻【程序员】使用 Netlify + Jekyll 快速搭建个人博客
date: 2023/3/12 12:00
typora-root-url: ../
typora-copy-images-to: ../media/jekyll
---

## 前言

在这篇文章中，我们将学习如何利用 [Netlify](https://www.netlify.com/) + [Github](https://github.com) + [Jekyll](https://jekyllrb.com/)，快速零成本搭建个人博客。

每个技术人都应该有自己的博客。正如 Github Profile 一样，博客也是一张对外展示的名片。Github 展示了你的开源项目和编码水平，博客则展示了你的思考与技术沉淀。

为什么我不建议选择 CSDN、博客园、竹白等平台，或者语雀、飞书文档等个人知识库呢？一方面，每个平台有不同的调性。读者对你的印象，会受到这个平台其他作者的平均值的影响。有的平台虽然 SEO 做得很好、总是出现在搜索引擎的首位，但内容质量属实不敢恭维。出现在这样的平台上，很难保证读者不会给你的文章预设一个较低的分数。另一方面，这些平台不支持自定义主题，大家都使用统一的样式和排版风格，互相之间基本没有区分度，个人符号很难在其中得到展示。最后，有些平台是封闭的，无法被搜索引擎索引到。

所以，我建议申请一个[独特的域名](#domain)，搭建一个专属于你的个人博客。在这里，我们拥有完整的自主权，可以修改主题样式、监控网站数据、分享只属于你的内容、结交志同道合的朋友。

当然，自建博客也有缺点，比如 SEO 差、访客数量少、缺少交互性等。但对我来说，写博客不是为了获得知名度和商业收入，而是想纯粹地记录和分享。我在搜集资料、解决问题的过程中耗费了不少时间，写一篇博客不仅可以帮助自己理清思路，还可以让知识复用。提高文章的信息量、让博客的内容有长期价值、让每位读者都有收获，这便是写作的意义。

总之，博客是一个值得精心打磨的作品。如果一份简历上附有独立博客的链接，我一定会想点进去看一看。如果你也有这样的想法、希望输出有价值的内容、享受书写的乐趣，那就参考下面的步骤，用 10 分钟的时间搭建一个人博客吧。

## Quick Start

这一节我们将直接用  [Netlify](https://www.netlify.com/) + [Github](https://github.com) + [Jekyll](https://jekyllrb.com/) 零成本搭建个人博客。简单介绍一下原理：
* Jekyll 是一个[静态博客生成器](#static)，它可以把 markdown 格式的文本内容转成静态的 HTML 页面。可以修改 CSS 来配置博客的样式和风格，网上有很多现成的[主题](http://jekyllthemes.org/)可以使用。
* 每个 Jekyll 项目是一个文件夹，包含了这个博客的所有内容，如 markdown 文章、图片、CSS 文件、字体资源等。
* Jekyll 构建的产物是纯 HTML 页面。我们把它拖到任何一个静态站点托管服务上，便可以在浏览器中访问。
* Github 提供了 [Github Pages](https://docs.github.com/zh/pages/getting-started-with-github-pages/about-github-pages)。这是一个免费的静态站点托管服务，我们可以直接在某个 Github 仓库里托管 HTML 页面，然后通过  `<username>.github.io` 去访问。
* Jekyll 内置了[对 Github Pages 的支持](https://docs.github.com/zh/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)。我们只需要把 Jellky 项目上传到 Github 仓库，再把该仓库设置为 Github Pages，就可以在每次仓库提交后，自动构建和发布。
* [Netlify](https://www.netlify.com/) 是一个类似于 Github Pages 的静态站点托管服务，界面操作体验更好，构建和访问速度更快。绑定一个 Github 仓库之后，Netlify 会监听该仓库的提交、自动完成构建和发布。普通用户每个月有一定的免费流量额度，作为个人博客来说完全够用了。我们可以通过 Netlify 提供的 `唯一id.netlify.app` 链接来访问网站，但既然是个人博客，最好还是绑定到一个自己的域名上。

### 一、安装 Jekyll 环境

>  参考 Jekyll 的[官方文档](https://jekyllrb.com)。

先安装基本环境 Ruby 和 Ruby Gems，详见 <https://jekyllrb.com/docs/installation/>。

然后安装 jekyll 和 bundler：

```plaintext
gem install jekyll bundler
```

之后创建第一个 Jekyll 项目。你可以从零创建一个默认项目：

```plaintext
jekyll new myblog
```

也可以直接复用 Github 上[公开的主题](https://github.com/topics/jekyll-theme)，比如 [jasper](https://github.com/jekyllt/jasper)：

```bash
git clone https://github.com/jekyllt/jasper
```

最后构建网站，这会在 `_site` 目录下生成 HTML 页面，同时以 HTTP 方式提供服务：

```bash
# cd jasper
# bundle add webrick
# bundle install
bundle exec jekyll serve --livereload
```

访问 <http://localhost:4000>，便可以看到我们的博客首页：

![image-20230312151902964](/media/jekyll/image-20230312151902964.png)

💡  给  serve 命令添加 --livereload 选项，可以在源文件有任何改变时自动刷新页面。
{: .ant-alert .ant-alert-info}

💡 亲测 MacOS 安装 Jekyll 环境比较麻烦，可以考虑使用现成的 docker 镜像，参考[这篇文章](https://dev.to/stankukucka/install-jekyll-on-your-mac-with-docker-compose-file-everything-you-need-to-get-going-2alf)。
{: .ant-alert .ant-alert-info}

### 二、创建 Github 仓库

这里我们需要把上一步创建的 Jekyll 项目上传到 Github 仓库。比较基础，就不再赘述了。

### 三、配置 Github Pages (可选)

💡 这一节只是为了演示 Github Pages 的功能，不建议使用它部署个人博客，推荐使用 Netlify + 自定义域名。
{: .ant-alert .ant-alert-warning}

Github Pages 的[官方文档](https://docs.github.com/zh/pages/getting-started-with-github-pages/creating-a-github-pages-site)有详细教程，下面是摘要：

1. 创建一个名为 `<username>.github.io` 的代码仓库：

   ![创建存储库字段](/media/jekyll/create-repository-name-pages-20230312153656322.png)

2. 上传 Jekyll 项目到该仓库：

   ```bash
   # cd jasper
   # git remote add origin git@github.com:imageslr/imageslr.github.io.git
   git push
   ```

3. 进入 Github 仓库 → Settings → Pages，配置 Jekyll Actions，如下图 ①~④：

   ![image-20230312154812471](/media/jekyll/image-20230312154812471.png)

   >  如果有独立域名，也可以在上图 ⑤ 配置。

4. 等待几分钟，就可以通过 [https://username.github.io](https://username.github.io) 访问博客了。

   > 如果你使用的是 jasper 主题，需要按照下图修改 `_config.yml`，才能正常加载到 CSS 资源：
   >
   > ![image-20230312160345749](/media/jekyll/image-20230312160345749.png)

### 四、配置 Netlify 项目

1. 访问 <https://app.netlify.com>，直接使用 Github 账号登录。

2. 选择从 Github 导入项目 → 授予 Netlify 权限 → 安装 Netlify 应用 →  导入博客项目：

   ![image-20230312161113686](/media/jekyll/image-20230312161113686.png)

   ![image-20230312161205048](/media/jekyll/image-20230312161205048.png)

3. 等待项目首次构建完成：

   ![image-20230312161406530](/media/jekyll/image-20230312161406530.png)

4. 然后便可以使用 Netlify 提供的 `唯一id.netlify.app` 链接来访问博客了。

<br>

Netlify 部分功能说明：

* 部署状态：

  ![image-20230312161849257](/media/jekyll/image-20230312161849257.png)

* 域名管理：Site settings → Domain management

  ![image-20230312164404305](/media/jekyll/image-20230312164404305.png)

### 五、申请独立域名

{: #domain}

为什么要申请独立域名？一方面，域名是我们在互联网上的符号。相比于 Github Pages 的 `github.io` 和 Netlify 的 `netlify.app`，个性化的域名有更强的个人色彩，便于读者记忆和分享。另一方面，域名是一个方便的网站定位器。当我们想要从 Netlify 迁移到其他平台时，只需要修改域名的指向记录，而不需要读者重新保存一个新的链接。

申请域名非常简单，只需要选择一个域名服务商、搜索喜欢的域名是否已经被注册、付费。国内的域名服务商有阿里云、腾讯云等，国外的有 GoDaddy 等。域名付费一般以年为单位，首年费用较低，但后续续费价格可能增加。国内注册域名需要备案。

注册域名后，可以参考上面的步骤，将域名指向 Netlify 的博客项目。

## 深入讨论

### 博客框架

#### 静态博客 vs 动态博客

{: #static}

**静态博客**生成器 (Static Site Generator) 不依赖数据库，所有博客内容都以文件的形式存储。静态博客生成器的作用是把 Markdown 格式的文本内容转成静态的 HTML 页面，需要我们自行部署。优点是轻量、易用、访问速度快、可以在本地缓存页面后离线查看。缺点是发布内容慢，需要更新本地文件 → 上传 → 部署，以及插件数量少，需要自行编码集成。

**动态博客**依赖数据库，博客内容是数据库里的一个条目。优点是使用简单，能在线编写文章，有丰富的插件，自带管理后台。缺点是需要运行在服务器上，部署和维护较为繁琐。一个知名的动态博客框架是 [WordPress](https://wordpress.com/zh-cn/?aff=27964)。

💡 我个人推荐使用静态博客框架，原因是上手简单、成本低、好维护、文章能够本地存档。
{: .ant-alert .ant-alert-info}

#### 静态博客框架对比

以下对比了几个知名的静态博客生成器。


<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**Jekyll**：<https://jekyllrb.com>

* Ruby 实现的老牌博客框架。
* 优点：网上有丰富的教程和主题；原生支持 Github Pages；支持 Sass；支持 Liquid 语法，某些语法糖很好用。
* 缺点：装环境比较麻烦；构建速度相比于其他框架较慢；近期迭代较少。

</div>

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**Hexo**：<https://hexo.io/zh-cn>
* Node 实现的博客框架。
* 优点：主题众多；安装简单；构建速度快；支持 Github Pages；HTML + CSS + JS 友好；插件众多；良好的中文文档和社区支持；快速迭代。
</div>


<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**Hugo**：<https://gohugo.io>
* Golang 实现的博客框架。
* 优点：轻便，构建速度快；无需安装环境，整个工具是一个二进制文件。
* 缺点：主题使用 Go 模板开发，需要熟悉 Go。
</div>

<div class="outline-box outline-box-hoverable mb-8 px-3 py-3" markdown="1">
**VuePress**：<https://vuepress.vuejs.org/zh/>
* Vue 驱动的静态网站生成器。非常适合用于 Wiki、API 文档等网站类型。
* 优点：安装简单；构建速度快；可以使用 Vue 实现自定义组件，网站的动态性更强。
* 缺点：主题较少。
</div>

💡 我最终选择了 Jekyll，只是因为喜欢它的主题。从易用性来说，我更推荐 Hexo。
{: .ant-alert .ant-alert-info}

### 使用 Markdown 编写


Markdown 是一种用来写作的轻量级标记式语言，它使用简洁的纯文本格式来编写文档，可以转换成有效的 HTML 或 PDF 文档。Markdown 的语法十分简单，常用的标记符号不超过十个，几分钟就能掌握。可以通过这篇文章学习：[少数派：认识与入门 Markdown](https://sspai.com/post/25137)。

基本上所有的静态网站生成器都是用 Markdown 写的。许多网站也支持 Markdown 语法，如 Github、少数派、石墨文档、飞书文档等。

我最初使用 VS Code 编辑博客的 `.md` 文件，同时打开浏览器预览效果。后来换到了 Typora，粘贴图片会更方便，也支持所见即所得。最后开发了一个和博客样式一致的 Typora 主题，就不需要再打开浏览器了。

### 博客优化

#### 博客插件

以下是我的博客使用的插件。大部分插件都提供了傻瓜式的安装方法，某些插件需要有一定前端基础。这些插件都是免费的。

* [不蒜子](https://busuanzi.ibruce.info/)：极简网页计数器，两行代码搞定 PV、UV 统计。

* [giscus](https://giscus.app/zh-CN)：由 GitHub Discussion 驱动的评论系统。

* [Google Analytics](https://analytics.google.com/analytics/web/provision/#/provision)：Google 提供的站点统计工具，可以分析流量来源、所在国家、每个页面的阅读人次等。类似的工具还有[百度网站统计](https://tongji.baidu.com/web5/welcome/basic)。

* [Algolia](https://www.algolia.com/)：网站搜索工具。本身是一个付费服务，但对开源社区提供了免费额度，需要发邮件申请，一般三个工作日会回复。申请通过后，algolia 会定时给你的网站建索引，之后在网站上添加一个搜索按钮，接入其 SDK，就可以搜索全站内容了。但如果博客的 SEO 做得不错，直接通过 `site: xxx.com` 在 Google 搜索就足够了。

  <img src="/media/jekyll/image-20230312205507859.png" alt="image-20230312205507859" style="width:500px;margin:0" />

💡 建议在开发环境下关闭这些插件，避免不必要的数据污染。
{: .ant-alert .ant-alert-info}



#### SEO 优化

因为 Netlify 的服务器在国外，一开始百度无法索引到我的博客内容。解决办法是在[百度站长平台](https://ziyuan.baidu.com/linksubmit/index)中主动推送网站的 sitemap：

![image-20230312205009660](/media/jekyll/image-20230312205009660.png)

我使用的是 jekyll，需要安装  [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) 插件，这会在构建博客时生成一个 [sitemap 文件](https://imageslr.com/sitemap.xml)。之后把这个链接提交到上图的输入框中，过十几天就可以在百度搜索到网站内容了。验证方法是在百度搜索 [site: imageslr.com](https://www.baidu.com/s?wd=site%3A%20imageslr.com)。

除此之外，我的博客就没有做过 SEO 优化了，也没有主动推广过。目前来看，Google 的搜索效果最好、流量最多，百度聊胜于无。每天大约 80 UV。

#### 性能优化

1. 获取自动优化建议。通过 [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)、[Web Page Test](https://www.webpagetest.org/) 等工具。

   ![16333641783878](/media/jekyll/16333641783878.jpg)

2. 用 CDN 加速。比如从 CDN 加载 JS、CSS 文件，而不是放在博客的 `assets` 目录下。图片也可以上传到 CDN，许多 markdown 编辑器都支持配置图床，比如 Typora：

   <img src="/media/jekyll/image-20230312211016537.png" alt="image-20230312211016537" style="width:500px;margin:0" />


3. 减少加载的文件大小。比如使用 `.min.js` 文件、去除用不到的 CSS、使用 [ImageOptim](https://github.com/ImageOptim/ImageOptim) 优化图片大小等。
4. 提升特定地区的访问速度。可以通过[访问速度测试工具](https://ping.chinaz.com)，检测网站在不同国家和地区的访问速度。如果某些地区访问延迟很高或者 ping 不通，考虑在该地区部署一台实例。
5. 如果自己部署了服务器，打开 gzip 选项。

### Jeklins 自动部署 (可选)

去年我把博客部署在了腾讯云服务器上，但因为访问量较少，就没再续费了。期间参考[这篇文章](https://itiandong.com/2021/automating-blog-deployment-with-jenkins-and-gitee/)配置了基于「Gitee + Jenkins + 飞书机器人」的自动部署流程，记录下来，以备不时之需。

最终效果：我只需要往 Github 推送最新的提交，服务器就会自动拉取最新代码并构建，部署成功或失败都会给我发送一条飞书消息。

![image-20230312213846047](/media/jekyll/image-20230312213846047.png)

具体实现：

1. 因为国内服务器无法访问 Github，需要创建一个 Gitee 仓库，然后参考[这篇文章](https://zhyoch.netlify.app/2021-4/)，配置 Github 仓库自动同步到 Gitee。我的实现在[这里](https://github.com/imageslr/blog/commit/3d7717fdfbb94d296329a7a0acf3782f689c60d5)。
2. 在[飞书开放平台](https://open.feishu.cn/)，申请一个飞书机器人，参考[这篇文档](https://open.feishu.cn/document/ukTMukTMukTM/ucTM5YjL3ETO24yNxkjN)获取机器人的 webhook 地址。之后就可以通过 curl 命令来给自己发送飞书消息了。
3. 服务器安装 Jenkins，创建 CI 任务。我的实现在[这里](https://github.com/imageslr/blog/blob/master/scripts/deploy.sh)，里面集成了发送飞书消息的功能。
4. 把 Jekins 的 Webhook 地址添加到 Gitee 仓库的 WebHooks 中。参考[这篇文章](https://itiandong.com/2021/automating-blog-deployment-with-jenkins-and-gitee/)。

## 结语

最后我想说，搭建博客是成本最低的操作，持续输出才是最难的。要多写精品文章、写原创内容。不要发一些可以很容易检索到的内容。提高博客文章的信息量、让博客的内容有长期价值、让每位读者都有收获。





