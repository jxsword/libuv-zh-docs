#!/usr/bin/env bash
# merge_po.sh —— 增量合并主工具（计划 §6 / R1-3）：pot 重新抽取后，sphinx-intl update
# 将 pot 与既有 po 合并：
#   - 未变条目 msgstr 自动保留
#   - 变更条目（babel difflib cutoff 0.6 模糊匹配）自动标 fuzzy 并写 #| 旧原文
#   - 新增条目 msgstr 留空
#   - obsolete 条目默认保留（#~），必要时用 --no-obsolete 清理（防 po 膨胀，计划 §6）
# 用法: scripts/merge_po.sh [--no-obsolete]
# 前置: scripts/extract_pot.sh 已运行（pot 已重抽）
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POT_DIR="$REPO_ROOT/workdir/docs/build/locale"
LOCALE_DIR="$REPO_ROOT/locale"

if [ ! -d "$POT_DIR" ] || [ -z "$(find "$POT_DIR" -name '*.pot' 2>/dev/null)" ]; then
    echo "FATAL: 未找到 pot，请先运行 scripts/extract_pot.sh" >&2
    exit 1
fi
if [ -z "$(find "$LOCALE_DIR" -name '*.po' 2>/dev/null)" ]; then
    echo "FATAL: 尚未初始化 po，请先运行 scripts/init_po.sh" >&2
    exit 1
fi

SI="$REPO_ROOT/.venv/bin/sphinx-intl"
[ -x "$SI" ] || SI=sphinx-intl

if [ "${1:-}" = "--no-obsolete" ]; then
    "$SI" update --no-obsolete -p "$POT_DIR" -l zh_CN --locale-dir "$LOCALE_DIR"
else
    "$SI" update -p "$POT_DIR" -l zh_CN --locale-dir "$LOCALE_DIR"
fi

echo "== merge_po 完成（变更条目已标 fuzzy，须比对 #| 旧原文修订后清除，计划 §5 规则4）=="
