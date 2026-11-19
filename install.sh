#!/usr/bin/env bash
# Antigravity 界面汉化一键部署与配置脚本（兼容 macOS 与 Linux）
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

echo "==========================================="
echo "  Antigravity 界面汉化包一键安装程序"
echo "==========================================="
echo "当前操作系统: $OS"
echo "当前汉化包路径: $CURRENT_DIR"

# 1. 检查 Python 环境与依赖
echo ""
echo "[1/4] 检查 Python 运行环境..."
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ 错误: 未检测到 python3，请先安装 Python 3。"
    exit 1
fi

if ! python3 -c "import websockets" >/dev/null 2>&1; then
    echo "正在安装缺失的 websockets 模块..."
    pip3 install websockets 2>/dev/null || python3 -m pip install websockets 2>/dev/null || (command -v apt-get >/dev/null 2>&1 && sudo apt-get update && sudo apt-get install -y python3-websockets)
fi
echo "✅ Python 及 websockets 依赖已就绪。"

# 2. 赋予脚本执行权限
echo ""
echo "[2/4] 设置脚本执行权限..."
chmod +x "$CURRENT_DIR/antigravity_zh.py"
chmod +x "$CURRENT_DIR/apply_chinese.sh"
chmod +x "$CURRENT_DIR/auto_inject.sh"
chmod +x "$CURRENT_DIR/watch_inject.sh"
chmod +x "$CURRENT_DIR/install.sh"
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
        <string>$CURRENT_DIR/watch_inject.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/antigravity-zh-watch.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/antigravity-zh-watch.stderr.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin</string>
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
ExecStart=$CURRENT_DIR/watch_inject.sh
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

    # 适配 Antigravity 2.33.0+：为用户级 .desktop 启动项附加 --remote-debugging-port=0
    USER_DESKTOP_DIR="$HOME/.local/share/applications"
    USER_DESKTOP_FILE="$USER_DESKTOP_DIR/antigravity.desktop"
    for sys_desktop in "$USER_DESKTOP_FILE" "/usr/share/applications/antigravity.desktop" "/usr/local/share/applications/antigravity.desktop"; do
        if [ -f "$sys_desktop" ]; then
            mkdir -p "$USER_DESKTOP_DIR"
            [ "$sys_desktop" != "$USER_DESKTOP_FILE" ] && cp "$sys_desktop" "$USER_DESKTOP_FILE"
            if ! grep -q -- '--remote-debugging-port' "$USER_DESKTOP_FILE"; then
                sed -i 's|^Exec=\(.*\)$|Exec=\1 --remote-debugging-port=0|' "$USER_DESKTOP_FILE"
                echo "✅ 已为 Linux 应用启动器配置零侵入调试参数（适配 Antigravity 2.33.0+）。"
            fi
            break
        fi
    done
fi

# 4. 尝试对当前运行的实例进行即时汉化
echo ""
echo "[4/4] 正在检测当前运行中的 Antigravity 实例..."
PORT_FOUND=0
for pf in "$HOME/Library/Application Support/Antigravity/DevToolsActivePort" "$HOME/.config/Antigravity/DevToolsActivePort"; do
    if [ -f "$pf" ]; then
        PORT_FOUND=1
        break
    fi
done

if [ $PORT_FOUND -eq 1 ]; then
    echo "检测到活跃的 Antigravity 窗口，正在执行即时注入..."
    python3 "$CURRENT_DIR/antigravity_zh.py" || true
else
    if [ "$OS" = "Darwin" ]; then
        echo "✅ macOS 后台守护进程已开启「首启自动带参接管」（零侵入，不改动官方 .app 签名）。"
        echo "提示: 当前 Antigravity 窗口启动时未携带 CDP 参数，后续无需手动输入任何终端命令："
        echo "      请直接按 Cmd+Q 完全退出 Antigravity，再照常点击程序坞/启动台的原版图标打开，约 2 秒内自动全中文汉化！"
        if [ -t 0 ] && pgrep -if "Antigravity.app/Contents/MacOS/Antigravity" >/dev/null 2>&1; then
            read -r -p "是否现在自动重启 Antigravity 以立即生效？[y/N] " REPLY || REPLY=""
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                osascript -e 'tell application "Antigravity" to quit' >/dev/null 2>&1 || true
                sleep 2
                open -a Antigravity --args --remote-debugging-port=0
                echo "✅ 已自动重启 Antigravity，后台守护进程将在 2 秒内完成汉化。"
            fi
        fi
    else
        echo "提示: 未检测到 CDP 调试端口。若 Antigravity 已打开，请完全退出后通过应用图标重新启动（2.33.0+ 需通过已更新的启动器启动）。"
    fi
fi

echo ""
echo "==========================================="
echo "🎉 安装完成！Antigravity 界面已汉化。"
echo "若要手动重新注入，随时执行: $CURRENT_DIR/apply_chinese.sh"
echo "==========================================="
