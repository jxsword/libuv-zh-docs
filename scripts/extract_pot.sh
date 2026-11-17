#!/usr/bin/env bash
# extract_pot.sh —— 从 workdir 抽取 gettext pot 模板（复用上游 Makefile gettext 目标）
# 用法: scripts/extract_pot.sh
# 前置: scripts/gen_workdir.sh 已运行
# 产物: workdir/docs/build/locale/*.pot（42 个，与 rst 一一对应）
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "$REPO_ROOT/workdir/docs/src/conf.py" ]; then
    echo "FATAL: workdir 未生成，请先运行 scripts/gen_workdir.sh" >&2
    exit 1
fi

# venv sphinx-build 优先（CI 与本地一致）
if [ -x "$REPO_ROOT/.venv/bin/sphinx-build" ]; then
    export PATH="$REPO_ROOT/.venv/bin:$PATH"
fi

make -C "$REPO_ROOT/workdir/docs" gettext

echo "== pot 抽取完成 =="
find "$REPO_ROOT/workdir/docs/build/locale" -name '*.pot' | wc -l | xargs echo "pot 文件数:"
