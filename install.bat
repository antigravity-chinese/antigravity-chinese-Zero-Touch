@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ===========================================
echo   Antigravity 界面汉化一键安装程序 (Windows)
echo ===========================================
echo 当前路径: %~dp0
echo.

REM 1. 检查 Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到 Python，请先安装 Python 3 并勾选 "Add Python to PATH"！
    echo 官网下载: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM 2. 检查依赖
echo [1/3] 检查 Python websockets 依赖...
python -c "import websockets" >nul 2>&1
if errorlevel 1 (
    echo 正在安装 websockets 模块...
    pip install websockets
)
echo [OK] 运行环境已就绪。

REM 3. 一键配置开机自启、启动后台守护进程并立即热注入当前界面
echo.
echo [2/3] 配置后台静默守护服务与自启动...
echo [3/3] 正在检测并汉化当前打开的 Antigravity 窗口...
python antigravity_zh.py --setup

echo.
echo ===========================================
echo [*] 安装与守护配置完成！
echo.
echo 说明：
echo    1. 未在桌面添加任何新图标，已自动为官方 Antigravity 原版快捷方式开启零侵入调试参数（适配 2.33.0+）。
echo    2. 若安装前已打开 Antigravity 且界面尚未变中文，请完全退出（含托盘）后重新打开，约 2 秒内自动全中文汉化。
echo ===========================================
pause
