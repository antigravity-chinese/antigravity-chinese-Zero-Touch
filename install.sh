#!/usr/bin/env bash
# Antigravity 界面汉化一键部署与配置脚本（兼容 macOS 与 Linux）
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

xml_escape() {
    printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

echo "==========================================="
echo "  Antigravity 界面汉化包一键安装程序"
echo "==========================================="
echo "当前操作系统: $OS"
echo "当前汉化包路径: $CURRENT_DIR"

# 1. 检查 Python 环境与依赖（兼容 macOS Homebrew / Ubuntu 24+ PEP 668）
echo ""
echo "[1/4] 检查 Python 运行环境..."
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ 错误: 未检测到 python3，请先安装 Python 3。"
    exit 1
fi

PYTHON_BIN="python3"
if [ -x "$CURRENT_DIR/.venv/bin/python3" ] && "$CURRENT_DIR/.venv/bin/python3" -c "import websockets" >/dev/null 2>&1; then
    PYTHON_BIN="$CURRENT_DIR/.venv/bin/python3"
elif ! python3 -c "import websockets" >/dev/null 2>&1; then
    echo "正在安装缺失的 websockets 模块..."
    if python3 -m venv "$CURRENT_DIR/.venv" >/dev/null 2>&1 && "$CURRENT_DIR/.venv/bin/pip" install --quiet websockets; then
        PYTHON_BIN="$CURRENT_DIR/.venv/bin/python3"
    else
        rm -rf "$CURRENT_DIR/.venv" 2>/dev/null || true
        pip3 install --user websockets 2>/dev/null \
            || python3 -m pip install --user --break-system-packages websockets 2>/dev/null \
            || (command -v apt-get >/dev/null 2>&1 && sudo apt-get update && sudo apt-get install -y python3-websockets) \
            || true
    fi
fi

if ! "$PYTHON_BIN" -c "import websockets" >/dev/null 2>&1; then
    echo "❌ 错误: websockets 模块安装失败，请手动执行: python3 -m pip install websockets"
    exit 1
fi
echo "✅ Python 及 websockets 依赖已就绪 ($PYTHON_BIN)。"

# 2. 赋予脚本执行权限
echo ""
echo "[2/4] 设置脚本执行权限..."
chmod +x "$CURRENT_DIR/antigravity_zh.py"
chmod +x "$CURRENT_DIR/apply_chinese.sh"
chmod +x "$CURRENT_DIR/auto_inject.sh"
chmod +x "$CURRENT_DIR/watch_inject.sh"
chmod +x "$CURRENT_DIR/install.sh"
chmod +x "$CURRENT_DIR/uninstall.sh"
echo "✅ 执行权限已配置。"

# 3. 配置开机与后台自动注入服务
echo ""
echo "[3/4] 配置后台自动注入守护服务..."
if [ "$OS" = "Darwin" ]; then
    PLIST_DIR="$HOME/Library/LaunchAgents"
    PLIST_FILE="$PLIST_DIR/com.antigravity.zh-watch.plist"
    mkdir -p "$PLIST_DIR"

    # 如果已有服务先卸载
    launchctl bootout "gui/$(id -u)" "$PLIST_FILE" 2>/dev/null || launchctl unload "$PLIST_FILE" 2>/dev/null || true

    ESC_WATCH="$(xml_escape "$CURRENT_DIR/watch_inject.sh")"
    ESC_HOME="$(xml_escape "$HOME")"

    cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.antigravity.zh-watch</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$ESC_WATCH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$ESC_HOME/Library/Logs/antigravity-zh-watch.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$ESC_HOME/Library/Logs/antigravity-zh-watch.stderr.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$ESC_HOME/.local/bin</string>
    </dict>
</dict>
</plist>
EOF

    # 载入 LaunchAgent
    launchctl bootstrap "gui/$(id -u)" "$PLIST_FILE" 2>/dev/null || launchctl load -w "$PLIST_FILE"
    echo "✅ macOS LaunchAgent 守护服务已配置并激活 ($PLIST_FILE)。"
else
    SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SYSTEMD_USER_DIR"

    cat > "$SYSTEMD_USER_DIR/antigravity-zh-watch.service" <<EOF
[Unit]
Description=Antigravity 汉化守护进程（自动注入中文词典）
After=graphical-session.target

[Service]
Type=simple
ExecStart="$CURRENT_DIR/watch_inject.sh"
Restart=always
RestartSec=10
StandardOutput=null
StandardError=journal

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable antigravity-zh-watch.service
    systemctl --user restart antigravity-zh-watch.service
    echo "✅ Linux systemd 守护服务已启动并设置开机自启。"

    # 适配 Antigravity 2.33.0+：为用户级 .desktop 启动项附加 --remote-debugging-port=19222（插在 %U/%F 之前）
    USER_DESKTOP_DIR="$HOME/.local/share/applications"
    USER_DESKTOP_FILE="$USER_DESKTOP_DIR/antigravity.desktop"
    for sys_desktop in "$USER_DESKTOP_FILE" "/usr/share/applications/antigravity.desktop" "/usr/local/share/applications/antigravity.desktop"; do
        if [ -f "$sys_desktop" ]; then
            mkdir -p "$USER_DESKTOP_DIR"
            [ "$sys_desktop" != "$USER_DESKTOP_FILE" ] && cp "$sys_desktop" "$USER_DESKTOP_FILE"
            if [ -f "$USER_DESKTOP_FILE" ]; then
                "$PYTHON_BIN" - "$USER_DESKTOP_FILE" <<'PYEOF'
import re, sys
p = sys.argv[1]
with open(p, "r", encoding="utf-8") as f:
    lines = f.readlines()
out = []
for line in lines:
    if line.startswith("Exec="):
        line = re.sub(r"(?<!\S)--remote-debugging-port=0(?=\s|$)", "--remote-debugging-port=19222", line)
    if line.startswith("Exec=") and "--remote-debugging-port" not in line:
        stripped = line.rstrip("\r\n")
        if re.search(r"\s%[uUfF]\b", stripped):
            stripped = re.sub(r"(\s%[uUfF]\b)", r" --remote-debugging-port=19222\1", stripped, count=1)
        else:
            stripped += " --remote-debugging-port=19222"
        out.append(stripped + "\n")
    else:
        out.append(line)
with open(p, "w", encoding="utf-8") as f:
    f.writelines(out)
PYEOF
                echo "✅ 已为 Linux 应用启动器配置零侵入调试参数（适配 Antigravity 2.33.0+）。"
            fi
            break
        fi
    done
fi

# 4. 尝试对当前运行的实例进行即时汉化（实时校验 CDP 端口存活）
echo ""
echo "[4/4] 正在检测当前运行中的 Antigravity 实例..."
INJECTED=0
if "$PYTHON_BIN" "$CURRENT_DIR/antigravity_zh.py" --check-port; then
    echo "检测到活跃的 Antigravity 窗口，正在执行即时注入..."
    if "$PYTHON_BIN" "$CURRENT_DIR/antigravity_zh.py"; then
        INJECTED=1
    fi
else
    if [ "$OS" = "Darwin" ]; then
        echo "✅ macOS 后台守护进程已开启「首启自动带参接管」（零侵入，不改动官方 .app 签名）。"
        echo "提示: 当前 Antigravity 窗口启动时未携带 CDP 参数，后续无需手动输入任何终端命令："
        echo "      请直接按 Cmd+Q 完全退出 Antigravity，再照常点击程序坞/启动台的原版图标打开，约 2 秒内自动全中文汉化！"
        if [ -t 0 ] && pgrep -if "Antigravity.app/Contents/MacOS/Antigravity" >/dev/null 2>&1; then
            read -r -p "是否现在自动重启 Antigravity 以立即生效？[y/N] " REPLY || REPLY=""
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                if "$PYTHON_BIN" "$CURRENT_DIR/antigravity_zh.py" --restart-macos; then
                    echo "✅ 已确认旧进程退出并带参重启 Antigravity，等待后台守护进程完成汉化。"
                else
                    echo "⚠️ 自动重启未完成，请按 Cmd+Q 完全退出后重新打开 Antigravity。"
                fi
            fi
        fi
    else
        echo "提示: 未检测到活跃的 CDP 调试端口。若 Antigravity 已打开，请完全退出后通过应用图标重新启动（2.33.0+ 需通过已更新的启动器启动）。"
    fi
fi

echo ""
echo "==========================================="
if [ $INJECTED -eq 1 ]; then
    echo "🎉 安装完成！Antigravity 界面已汉化。"
else
    echo "🎉 安装与后台守护配置完成！重启客户端后将自动完成全中文汉化。"
fi
echo "若要手动重新注入，随时执行: $CURRENT_DIR/apply_chinese.sh"
echo "==========================================="
