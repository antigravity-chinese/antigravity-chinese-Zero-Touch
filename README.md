# Antigravity 界面无损动态汉化包

<p align="center">
  <strong>基于 Chrome DevTools Protocol (CDP) 的全平台无损热注入汉化引擎</strong><br>
  无需解包 asar · 不修改系统文件 · 永不白屏 · 天然免疫官方更新 · 毫秒级后台保活
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-brightgreen?style=flat-square" alt="Platform" />
  <img src="https://img.shields.io/badge/Python-3.8%2B-blue?style=flat-square" alt="Python" />
  <img src="https://img.shields.io/badge/Version-v1.3.5-blue?style=flat-square" alt="Version" />
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="License" />
  <img src="https://img.shields.io/badge/Safety-100%25%20Zero--Touch-success?style=flat-square" alt="Safety" />
</p>

---

## 📖 项目简介

本工具通过 Chrome DevTools Protocol (CDP) 协议，将经过严格校对的中文词典无损动态注入 Google Antigravity 前端界面。

**无需重新打包、不修改二进制与 asar 文件、无需重启应用，即刻享受 100% 沉浸式中文界面。**

---

## ✨ 核心特性

- ⚡ **无损热注入（Zero-Touch Injection）**：
  完全在内存运行时注入，磁盘上的 Antigravity 应用程序保持 100% 官方原版字节，安全合规，绝无被系统拦截或损坏的风险。
- 🛡️ **双引擎保活·永不掉汉化（核心特性）**：
  - **内核级新文档注入**：注册 CDP `Page.addScriptToEvaluateOnNewDocument`，在 Chromium 渲染新页面前自动生效。无论是刷新页面（`Ctrl+R` / `Cmd+R` / `F5`）、切换对话列表还是路由跳转，告别刷新闪回英文！
  - **智能心跳守护**：后台常驻守护服务毫秒级检测多窗口与新建工作区，全自动补注，并轻量维护异步加载的 React 下拉菜单、设置面板与弹窗。
- 💬 **对话与代码绝对安全（Context-Safe）**：
  内置智能作用域过滤器，严格跳过消息列表正文（`role="log"`）、Monaco / CodeMirror 代码编辑器、终端输出、Markdown 渲染块及输入框，**绝不篡改代码正文与聊天 Prompt**。
- 🔄 **词典实时热重载（Live Hot-Reload）**：
  随手编辑保存 `zh-CN.json`，守护进程 2 秒内自动感知更新并热刷新所有窗口，无需重启应用或守护进程。
- 🎯 **4140+ 深度精炼词条 + 240 条动态正则**：
  基于 Antigravity **2.33.0** 官方前端 bundle 深度提取与去重校对，全面覆盖菜单栏、侧栏、设置面板（含快捷键方案 Keybinding Scheme / 安全与权限预设 / 外观 / 通用 / 浏览器与浏览数据 Browsing Data & Cookies by Site / 界面与对话布局）、SSH 远程主机（SSH Host）与环境配置脚本、移动端与跨设备远程接力（Remote Control）、上下文窗口与模型配额指示器、旁路提问（Side Question / `/btw` 与选区插入）、插件包管理与审查（Plugin Bundles）、协调者与蜂群协作看板（Coordinators & Swarm Board `plugin://` 视图）、CEL 表达式参考、插件市场与连接器（Marketplace & Connectors）、定时自动化（Automations）、GitHub 权限策略、语音听写模式、快捷键提示、Web 预览、云端/Cog 工作区、幕僚长画布；内置 240 条动态正则规则，完美匹配耗时统计、配额与上下文占用比例、插件包安装/审查提示、旁路提问动态标题、后台任务与系统提示。
- 🔧 **原生适配 Antigravity 2.33.0+（全平台免手动敲命令）**：
  Antigravity 2.33.0 起默认关闭了本地 CDP 调试端口（仅在启动参数包含 `--remote-debugging-port` 时生成 `DevToolsActivePort`）。本版本在安装时**绝不修改任何官方程序文件、`.app` 签名或 `app.asar`**：
  - **Windows / Linux**：自动为原版快捷方式 / `.desktop` 启动器附加 `--remote-debugging-port=19222`（卸载时自动还原）；Windows 采用**免管理员提权**的三重独立常驻架构（`schtasks` 普通用户计划任务 / WMI 系统服务托管 / `CREATE_BREAKAWAY_FROM_JOB` + `HKCU\...\Run` 与 Startup 双重自启），在含空格路径与普通用户权限下均可 100% 脱离客户端进程树独立存活，退出客户端绝不中断守护。
  - **macOS**：LaunchAgent 后台守护进程内置**首启自动带参接管**（4 重安全锁：仅在客户端刚启动 1~15 秒、无 CDP 端口时触发，带 6 秒短冷却、连续失败 3 次后 60 秒熔断，CDP 存活后立即清零，绝不打断正在使用的对话），用户照常点击官方原版图标即可自动完成汉化，**永远无需手动敲终端命令**（如需关闭可设 `ANTIGRAVITY_ZH_NO_TAKEOVER=1`）。
- 🖥️ **Windows / macOS / Linux 全平台支持**：
  - **Windows**：双击 `install.bat` 极速安装，自动配置开机静默后台守护。
  - **macOS**：一键脚本自动配置 `launchd` 用户守护服务（LaunchAgent）。
  - **Linux**：一键脚本自动配置 `systemd --user` 与桌面 autostart 服务。

---

## 🚀 快速上手

### 1. 下载或克隆仓库

- **方式 A (Git 克隆)**：
  ```bash
  git clone https://github.com/antigravity-chinese/antigravity-chinese-Zero-Touch.git
  cd antigravity-chinese-Zero-Touch
  ```
- **方式 B (ZIP 下载)**：
  在 GitHub 页面点击 **Code -> Download ZIP**（或在 Releases 页面下载 `antigravity-chinese-Zero-Touch-v1.3.5.zip`），解压到任意目录。

---

### 🤖 懒人模式：让 Antigravity AI 帮你一键装（最推荐）

既然您正在使用 Antigravity，完全可以让 AI 智能体自己帮自己汉化！

  在 Antigravity 对话框中直接发送：
  ```bash
请帮我执行一键安装https://github.com/antigravity-chinese/antigravity-chinese-Zero-Touch,运行系统对应的安装脚本（Windows 运行 install.bat，macOS/Linux 运行 install.sh），启动后台守护进程并立即完成界面汉化。
  ```

AI 智能体将全自动识别操作系统、在终端为您执行安装并立即热更新汉化，全程无需手动敲命令！

---

### 🛠️ 手动安装与配置指南

#### 🪟 Windows 用户
1. 确保电脑已安装 Python 3（安装时勾选了 `Add Python to PATH`）。
2. 在解压后的目录中，直接**双击运行 `install.bat`**。
3. 脚本将自动安装依赖、注入当前窗口，并将静默守护程序加入 Windows 计划任务与开机自启项。
4. 安装完成后，无需任何额外快捷方式，日常照常双击原版 Antigravity 图标启动，后台服务将自动完成中文翻译！

#### 🍎 macOS & 🐧 Linux 用户
在终端中进入项目目录，执行：

```bash
bash install.sh
```

**脚本将自动为您完成：**
1. 检查 Python 3 环境并自动安装轻量依赖 `websockets`。
2. 配置后台守护服务并设置开机自启（macOS `LaunchAgent` / Linux `systemd`）。
3. 自动探测当前打开的 Antigravity 窗口并立即执行汉化。

---

## 💡 日常使用

### 全自动生效（推荐）
平时正常打开或使用 Antigravity 即可，后台守护进程在检测到窗口就绪后会在 1~2 秒内自动完成汉化替换，全程静默无感。

### 手动重刷汉化
如果临时想手动重刷当前界面：
- **Windows**: 双击运行 `apply_chinese.bat`
- **macOS / Linux**: 在终端执行 `./apply_chinese.sh`

---

## ✏️ 自定义与扩充词典

所有翻译对照均保存在明文文件 [`zh-CN.json`](zh-CN.json) 中，格式清晰直观：

```json
{
  "translations": {
    "New Conversation": "新建对话",
    "Settings": "设置",
    "你的英文原文": "你想显示的中文"
  }
}
```

> 💡 **提示**：
> - 键名需与界面上的英文**完全一致**（区分大小写与标点符号）。
> - 保存文件后，后台守护服务会自动感知并秒级热重载，无需任何额外命令！

---

## 📁 目录结构

```text
antigravity-chinese/
├── antigravity_zh.py    # 核心注入与守护程序（CDP 交互 / DOM 监听 / 热重载）
├── zh-CN.json           # 4141 条官方高精提取词典（适配 Antigravity 2.33.0）
├── install.bat          # Windows 一键安装与开机自启脚本
├── apply_chinese.bat    # Windows 手动单次热注入入口
├── uninstall.bat        # Windows 干净卸载脚本
├── install.sh           # macOS / Linux 一键安装脚本
├── apply_chinese.sh     # macOS / Linux 手动单次热注入入口
├── uninstall.sh         # macOS / Linux 干净卸载脚本
├── watch_inject.sh      # 后台守护进程启动入口
├── auto_inject.sh       # 单次轮询启动脚本
├── requirements.txt     # Python 依赖清单
├── LICENSE              # MIT 开源协议
└── README.md            # 项目说明文档
```

---

## 🗑️ 一键卸载

如果您希望卸载汉化或恢复纯英文原版界面：
- **Windows**: 双击运行 `uninstall.bat`
- **macOS / Linux**: 在终端执行 `bash uninstall.sh`

卸载脚本会安全停用并清理后台守护服务，重启 Antigravity 后界面将完全恢复为原生英文，系统不留任何残留。

---

## ❓ 常见问题 (FAQ)

### Q1: 为什么 Antigravity 启动后没有自动变成中文？
- **Antigravity 2.33.0+ 特别说明**：2.33.0 起官方默认关闭了 CDP 调试端口（需携带 `--remote-debugging-port=19222` 启动参数才会生成 `DevToolsActivePort`）：
  - **Windows / Linux**：安装脚本已自动为现有快捷方式 / `.desktop` 启动器添加该参数；若安装前已打开客户端，请**完全退出（含系统托盘）后重新打开**即可在 2 秒内自动汉化。
  - **macOS**：后台守护进程已开启「首启自动带参接管」（不破坏官方 `.app` 签名）。若安装前已打开客户端，只需按 `Cmd+Q` 完全退出，再**照常点击程序坞/启动台里的官方原版图标**打开，守护进程会自动带参拉起并在 2 秒内完成汉化，无需手动输入任何命令。
- 请确认后台守护进程是否正常运行：
  - **Windows**: 打开任务管理器，查看是否有 `pythonw.exe` 进程在运行。
  - **macOS**: 执行 `launchctl list | grep antigravity` 查看状态。
  - **Linux**: 执行 `systemctl --user status antigravity-zh-watch.service` 查看状态。
- 您也可以随时执行 `apply_chinese.bat` 或 `./apply_chinese.sh` 进行手动热注入（支持 `--port <端口>` 或 `ANTIGRAVITY_CDP_PORT` 环境变量）。

### Q2: 对话正文里的英文代码会被误翻译吗？
不会。本汉化包内置严格的作用域选择器，会主动跳过所有会话消息列表（`role="log"`）、代码块与富文本输入区，绝不会影响代码与 prompt 原文。

### Q3: 官方 Antigravity 软件升级后需要重新安装吗？
完全不需要！因为本项目不修改应用程序文件，官方客户端随时可自由升级。升级完成后，后台守护服务会自动识别新版本并继续提供汉化。

---

## 📄 开源许可

本项目采用 [MIT 许可证](LICENSE)。欢迎提交 PR 或 Issue 共同完善汉化词典！ 


## 固定端口与接管、首屏监听修复

- 全平台默认 CDP 端口为 `19222`；优先探测 CLI `--port` / `ANTIGRAVITY_CDP_PORT`，再探测默认端口，最后探测各配置目录的 `DevToolsActivePort`，每步均验证存活。固定端口减少对端口文件覆写竞态的依赖。
- Windows 快捷方式与 Linux `.desktop` 自动升级旧 `=0` 参数，卸载兼容清理 `=0` 与 `=19222`。第三方代理启动脚本（如 `launch.ps1`）或代理快捷方式需自行添加 `--remote-debugging-port=19222`。
- macOS 对刚启动 1~15 秒且未带调试参数的进程接管：6 秒短冷却，连续失败 3 次后冷却 60 秒；探测到 CDP 存活即清零冷却与失败计数，支持快速退出重开。最多等待旧 PID 退出 5 秒，未退出则取消重新拉起。
- NewDocument 阶段即使 body 尚未创建，也会在 DOMContentLoaded 和后续补扫中幂等挂载或迁移 MutationObserver。首屏就绪要求已翻译内容或可见文本超过 40 字符，并检查监听器存在，避免脚本/样式文本造成假就绪。


### macOS 重启边界补充修复

安装器的“立即重启”与后台自动接管共用重启流程：退出命令成功后，最多轮询等待旧 PID 退出 5 秒，确认消失才使用 `--remote-debugging-port=19222` 启动。进程查询失败、超时或退出失败时取消本次重启并提示，不再将查询失败当作进程已退出；安装器仅在流程成功返回后显示重启成功。


### Python 3.8–3.11 语法兼容修复

将 Windows WMI 启动命令中的嵌套 f-string 提取为独立变量，消除旧版 Python 的 `f-string expression part cannot include a backslash` 编译错误。该错误原先也会阻止 macOS/Linux 启动整个脚本。命令内容及路径转义行为不变，继续支持 Python 3.8+。已在 Windows 上使用真实 CPython 3.8.10、3.9.6、3.10.11、3.11.9、3.12.10 执行语法、导入与模拟回归测试；macOS 实机重启及界面端到端验收尚未完成。
