#!/usr/bin/env bash
# 一键运行 Antigravity 界面汉化注入
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="$DIR/.venv/bin/python3"
[ -x "$PYTHON_BIN" ] || PYTHON_BIN="python3"
exec "$PYTHON_BIN" "$DIR/antigravity_zh.py" "$@"
