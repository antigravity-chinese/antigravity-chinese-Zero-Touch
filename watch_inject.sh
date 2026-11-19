#!/usr/bin/env bash
# Antigravity 汉化守护进程（持续侦测与保活）
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="$DIR/.venv/bin/python3"
[ -x "$PYTHON_BIN" ] || PYTHON_BIN="python3"
exec "$PYTHON_BIN" -u "$DIR/antigravity_zh.py" --watch
