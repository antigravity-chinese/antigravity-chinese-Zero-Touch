#!/usr/bin/env bash
# Antigravity 界面汉化一键卸载脚本
set -euo pipefail

OS="$(uname -s)"

echo "==========================================="
echo "  Antigravity 界面汉化包卸载程序"
echo "==========================================="

# 1. 停止并移除守护服务
if [ "$OS" = "Darwin" ]; then
    PLIST_FILE="$HOME/Library/LaunchAgents/com.antigravity.zh-watch.plist"
    if [ -f "$PLIST_FILE" ]; then
        echo "[1/2] 正在卸载 macOS LaunchAgent 守护服务..."
        launchctl bootout "gui/$(id -u)" "$PLIST_FILE" 2>/dev/null || launchctl unload "$PLIST_FILE" 2>/dev/null || true
        rm -f "$PLIST_FILE"
        echo "✅ LaunchAgent 服务已移除。"
    else
        echo "[1/2] 未发现 LaunchAgent 配置文件，跳过。"
    fi
    rm -f "$HOME/Library/Logs/antigravity-zh-watch"* 2>/dev/null || true
else
    echo "[1/2] 正在卸载 Linux systemd 守护服务..."
    systemctl --user stop antigravity-zh-watch.service 2>/dev/null || true
    systemctl --user disable antigravity-zh-watch.service 2>/dev/null || true
    rm -f "$HOME/.config/systemd/user/antigravity-zh-watch.service"
    systemctl --user daemon-reload 2>/dev/null || true
    USER_DESKTOP_FILE="$HOME/.local/share/applications/antigravity.desktop"
    if [ -f "$USER_DESKTOP_FILE" ] && grep -q -- '--remote-debugging-port=0' "$USER_DESKTOP_FILE"; then
        sed -i 's| --remote-debugging-port=0||g' "$USER_DESKTOP_FILE"
    fi
    echo "✅ systemd 守护服务已移除。"
fi

# 2. 终止残留后台进程
echo "[2/2] 正在清理后台注入进程..."
pkill -f "antigravity_zh.py" 2>/dev/null || true

echo ""
echo "==========================================="
echo "🎉 卸载完成！后台守护服务已停止。"
echo "提示：重启 Antigravity 客户端后界面将完全恢复为原生英文。"
echo "==========================================="
