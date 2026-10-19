# Antigravity 界面无损动态汉化包

<p align="center">
  <strong>基于 Chrome DevTools Protocol (CDP) 的全平台无损热注入汉化引擎</strong><br>
  无需解包 asar · 不修改系统文件 · 永不白屏 · 天然免疫官方更新 · 毫秒级后台保活
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-brightgreen?style=flat-square" alt="Platform" />
  <img src="https://img.shields.io/badge/Python-3.8%2B-blue?style=flat-square" alt="Python" />
  <img src="https://img.shields.io/badge/Version-v1.3.0-blue?style=flat-square" alt="Version" />
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
- 🎯 **1770+ 深度提取词条 + 动态正则**：
  基于官方前端 bundle 深度提取，菜单栏、侧栏、设置面板（含安全预设/权限预设）、快捷键提示全覆盖；内置动态正则规则，完美匹配耗时统计（`Thought for 15s` / `Worked for 2m`）、模型状态与系统提示。
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
  在 GitHub 页面点击 **Code -> Download ZIP**（或在 Releases 页面下载 `antigravity-chinese-v1.1.0.zip`），解压到任意目录。

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
├── zh-CN.json           # 1200+ 官方高精提取词典
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
- 请确认后台守护进程是否正常运行：
  - **Windows**: 打开任务管理器，查看是否有 `pythonw.exe` 进程在运行。
  - **macOS**: 执行 `launchctl list | grep antigravity` 查看状态。
  - **Linux**: 执行 `systemctl --user status antigravity-zh-watch.service` 查看状态。
- 您也可以随时执行 `apply_chinese.bat` 或 `./apply_chinese.sh` 进行手动热注入。

### Q2: 对话正文里的英文代码会被误翻译吗？
不会。本汉化包内置严格的作用域选择器，会主动跳过所有会话消息列表（`role="log"`）、代码块与富文本输入区，绝不会影响代码与 prompt 原文。

### Q3: 官方 Antigravity 软件升级后需要重新安装吗？
完全不需要！因为本项目不修改应用程序文件，官方客户端随时可自由升级。升级完成后，后台守护服务会自动识别新版本并继续提供汉化。

---

## 📄 开源许可

本项目采用 [MIT 许可证](LICENSE)。欢迎提交 PR 或 Issue 共同完善汉化词典！ 
