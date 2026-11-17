#!/usr/bin/env bash
# build_zh.sh —— 构建中文 HTML 站（language=zh_CN 已由 conf.py overlay 固化）
# 用法: scripts/build_zh.sh [--keep-doctrees]
#   空译文的 po 会回退英文（P0 占位站即此状态）；译文经 locale/zh_CN/LC_MESSAGES/*.po → .mo 注入
# 产物: workdir/docs/build/html
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "$REPO_ROOT/workdir/docs/src/conf.py" ]; then
    echo "FATAL: workdir 未生成，请先运行 scripts/gen_workdir.sh" >&2
    exit 1
fi

# .mo 预编译（po → mo）：使用 msgfmt（gettext）；.mo 是 Sphinx 运行时读取的格式
MO_DIR="$REPO_ROOT/locale/zh_CN/LC_MESSAGES"
if [ -d "$MO_DIR" ]; then
    echo "== msgfmt 编译 .mo（排除空译文条目与 fuzzy）=="
    find "$MO_DIR" -name '*.po' -print0 | while IFS= read -r -d '' po; do
        mo="${po%.po}.mo"
        msgfmt -o "$mo" "$po"
    done
fi

if [ -x "$REPO_ROOT/.venv/bin/sphinx-build" ]; then
    export PATH="$REPO_ROOT/.venv/bin:$PATH"
fi

echo "== sphinx html 构建（language=zh_CN）=="
make -C "$REPO_ROOT/workdir/docs" html

echo "== 构建完成: workdir/docs/build/html =="
