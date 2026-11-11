# 陈亦航 · 个人作品集

一个从零手写的静态作品集站点：**纯 HTML + CSS + JavaScript**，没有框架、没有构建步骤、没有后端。
直接双击 `index.html` 就能看，托管在 GitHub Pages 上。

> **上线前请先做两件事**：把 `chen.yihang@example.com` 换成你的真实邮箱，把 `github.com/swdlawa` 换成你的账号（如果你的账号不是这个）。搜索 `example.com` 即可全部找到，共 3 处：页脚、联系页、`js/main.js` 里的 `data-mailto`。

---

## 1. 页面结构

```
portfolio-site/
├── index.html              首页：Hero、精选项目、工作原则、技能、CTA
├── work.html               项目列表：可按类型筛选（全部 / LLM / 全栈 / 前端）
├── project-dsh.html        项目复盘：大模型智能体本地部署
├── project-qqbot.html      项目复盘：QQ 智能对话机器人
├── project-web.html        项目复盘：AI 辅助的网站开发
├── about.html              关于：自述、时间线、技能自评表、接下来
├── contact.html            联系：邮箱、GitHub、留言表单、FAQ
├── 404.html                找不到页面时的兜底
├── manifest.webmanifest    Web App Manifest（应用图标、主题色）
├── css/
│   └── styles.css          全部样式：设计变量 + 响应式 + 深色模式
├── js/
│   └── main.js             主题切换、移动菜单、项目筛选、复制、表单校验、滚动动画
├── assets/
│   ├── favicon.svg         站点图标（矢量，优先使用）
│   ├── favicon.png         64×64 兜底
│   ├── apple-touch-icon.png 180×180 iOS 主屏图标
│   ├── icon-192.png        192×192 manifest 图标
│   ├── icon-512.png        512×512 manifest 图标（同时声明 maskable）
│   ├── og-image.png        1200×630 社交分享图
│   ├── cover-dsh.svg       原创插图：Agent → 网关 → 模型
│   ├── cover-qqbot.svg     原创插图：聊天窗口与守护进程
│   ├── cover-web.svg       原创插图：浏览器 / API / 数据库
│   └── desk.svg            原创插图：书桌俯视图
├── scripts/
│   ├── generate-images.ps1 重新生成 OG 图、favicon、应用图标
│   ├── serve.mjs           本地预览服务器（零依赖）
│   └── shoot.mjs           本地截图脚本（开发用，不参与站点）
├── .nojekyll               告诉 GitHub Pages 不要跑 Jekyll
└── README.md
```

---

## 2. 七条要求对照

| 要求 | 这个站怎么做的 |
| --- | --- |
| **Pages** — 至少四页，导航可用 | 8 个页面。页头主导航 + 页脚导航；当前页有 `aria-current="page"`；项目页有面包屑和上一篇/下一篇 |
| **Content** — 自己的文字与图片 | 文案基于本人的三个真实项目重写；所有插图是用 SVG 手绘的原创图，不涉及第三方版权 |
| **Structure** — 语义化 HTML | `header / nav / main / article / section / aside / figure / figcaption / time / dl / table / form / footer`；表格有 `caption` 与 `th scope`；标题层级不跳级 |
| **Layout** — 手机上可用 | `clamp()` 流式字号、Grid 自适应卡片、780px 以下折叠菜单、表格横向滚动；在 390px 宽度逐页检查过 |
| **Behaviour** — 响应用户操作 | 深色模式切换、移动菜单、**项目筛选**、一键复制邮箱、表单校验与邮件草稿、滚动出现动画、回到顶部 |
| **Live** — 真实地址 | GitHub Pages：`https://swdlawa.github.io/portfolio/` |
| **History** — 按周增长的提交记录 | 见 §6。**注意：仓库是新建的，历史只能从建立那天开始积累**，无法凭空出现前几周的记录 |
| **Identity** — OG 图、favicon、应用图标 | `og-image.png` 1200×630、`favicon.svg` + `favicon.png`、`apple-touch-icon.png`、`icon-192/512.png` + `manifest.webmanifest`，每页都有完整的 OG/Twitter meta |

无障碍：跳转链接、可见焦点框、`aria-live` 结果区、`aria-expanded`/`aria-pressed` 状态、键盘可操作的筛选按钮、`prefers-reduced-motion` 支持。

---

## 3. 本地预览

```bash
# 方式一：直接打开 index.html

# 方式二：起一个本地服务器（推荐，路径和线上一致）
node scripts/serve.mjs 8080
# 然后访问 http://localhost:8080
```

---

## 4. 改成一个“你的”站点

1. **姓名 / 站点名**：全局搜索 `陈亦航`，替换。`Yihang Chen` 出现在 OG 图和 `<title>` 里。
2. **邮箱**：搜索 `example.com`，共 3 处。
3. **项目内容**：`project-*.html` 是复盘正文；`work.html` 里是卡片列表。改成你自己真实做过的事，别保留你不理解的描述。
4. **时间线**：`about.html` 的 `<ol class="timeline">`，日期请按真实情况改。
5. **配色**：`css/styles.css` 顶部的 `:root` 变量，一处改全站生效。
6. **身份图**：改 `scripts/generate-images.ps1` 顶部的参数，运行：

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/generate-images.ps1
   ```

   会重新生成 `og-image.png`、`favicon.png`、`apple-touch-icon.png`、`icon-192.png`、`icon-512.png`。

---

## 5. 图片版权

- `assets/*.svg` 与 `assets/*.png` 全部为本站原创（手写 SVG / 脚本生成），可以自由修改。
- 如果你之后加入真实照片，请用自己拍的，或使用可商用授权的图库（Unsplash、Pexels、Openverse），并在 `<figcaption>` 里写明作者与来源。

---

## 6. 关于 Git 历史（重要）

评审要求“能看到站点一周一周长起来”。诚实的做法是**从现在开始按周提交**，而不是一次性提交、再把提交日期改到过去——那是在伪造记录。

当前仓库的提交按功能拆分，每一步都能单独打开、都能工作：

1. `docs: 项目说明和结构规划`
2. `feat: 首页与共享页头页脚`
3. `feat: 响应式样式与深色模式`
4. `feat: 项目列表与筛选交互`
5. `feat: 三个项目复盘页与关于页`
6. `feat: 联系页与表单校验`
7. `feat: OG 图、favicon 与应用图标`
8. `docs: 上线地址与使用说明`

如果课程还剩下几周，建议每周做一件小事再提交一次（补一个项目、加一篇笔记、改一次文案），让 `git log` 自然形成时间线：

```bash
git log --oneline --reverse --date=short --pretty=format:"%ad  %s"
```

---

## 7. 部署到 GitHub Pages

```bash
git init
git add .
git commit -m "feat: 个人作品集初始版本"
git branch -M main
git remote add origin https://github.com/<你的用户名>/portfolio.git
git push -u origin main
```

然后在仓库里 **Settings → Pages → Source: Deploy from a branch → `main` / `(root)` → Save**。
一两分钟后访问 `https://<你的用户名>.github.io/portfolio/`。

> `og:image` 必须是绝对地址，所以每页 `<head>` 里的 `og:url` / `og:image` 已经写成 `https://swdlawa.github.io/portfolio/...`。
> 如果你换了用户名或仓库名，记得全局替换这一串。

`.nojekyll` 已经加好，避免下划线开头的文件被 Jekyll 忽略。

---

## 8. 浏览器支持

使用的是 2023 年以后浏览器都支持的 CSS（`clamp()`、`color-mix()`、Grid、逻辑属性）。
`color-mix()` 在极旧的浏览器里会失效，但只是背景透明度的细微差别，不影响内容与布局。
