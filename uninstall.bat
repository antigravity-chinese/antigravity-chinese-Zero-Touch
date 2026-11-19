@echo off
chcp 65001 >nul
echo ===========================================
echo   Antigravity 界面汉化卸载清理程序
echo ===========================================
echo.

echo [1/2] 正在清理快捷方式参数、启动项与计划任务...
python "%~dp0antigravity_zh.py" --restore-shortcuts >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item ([Environment]::GetFolderPath('Desktop') + '\Antigravity (中文秒开版).lnk') -ErrorAction SilentlyContinue" 2>nul
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item ([Environment]::GetFolderPath('Startup') + '\Antigravity-ZH.lnk') -ErrorAction SilentlyContinue" 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Antigravity-ZH" /f >nul 2>&1
schtasks /delete /tn "Antigravity-ZH-Daemon" /f >nul 2>&1
echo [OK] 快捷方式与计划任务已清理。

echo [2/2] 正在终止后台可能残留的注入进程...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process | Where-Object { $_.Name -like 'python*' -and $_.CommandLine -like '*antigravity_zh.py*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }" 2>nul
echo [OK] 残留进程已清理。

echo.
echo ===========================================
echo [*] 卸载完成！
echo ===========================================
pause
