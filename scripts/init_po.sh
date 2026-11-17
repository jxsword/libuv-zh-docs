#!/usr/bin/env bash
# init_po.sh —— 首次由 pot 生成 po（sphinx-intl update）并统一回填文件头元数据
# （计划 §9 / R3-3：Project-Id-Version / Language / attribution 注释行）
# 用法: scripts/init_po.sh [--force]
#   --force: po 已存在时仍重跑头部规范化（默认 po 已存在即拒绝，防误重置）
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POT_DIR="$REPO_ROOT/workdir/docs/build/locale"
LOCALE_DIR="$REPO_ROOT/locale"
LC_DIR="$LOCALE_DIR/zh_CN/LC_MESSAGES"

if [ ! -d "$POT_DIR" ] || [ -z "$(find "$POT_DIR" -name '*.pot' 2>/dev/null)" ]; then
    echo "FATAL: 未找到 pot，请先运行 scripts/extract_pot.sh" >&2
    exit 1
fi

if [ -n "$(find "$LC_DIR" -name '*.po' 2>/dev/null)" ] && [ "${1:-}" != "--force" ]; then
    echo "FATAL: po 已存在（$LC_DIR）。增量合并请用 scripts/merge_po.sh；" >&2
    echo "       确需重新初始化请加 --force（会先跑 sphinx-intl update 合并既有译文，不会丢译文）" >&2
    exit 1
fi

SI="$REPO_ROOT/.venv/bin/sphinx-intl"
[ -x "$SI" ] || SI=sphinx-intl

echo "== sphinx-intl update（生成/合并 po）=="
"$SI" update -p "$POT_DIR" -l zh_CN --locale-dir "$LOCALE_DIR"

echo "== 回填 po 文件头元数据 + 创建 sphinx.po 占位 =="
"$REPO_ROOT/.venv/bin/python" - "$LC_DIR" <<'PYEOF'
import re
import sys
from pathlib import Path

lc_dir = Path(sys.argv[1])

BASELINE = "1.53.0"

# sphinx.po 占位（0 条目）：Sphinx 内置 zh_CN 界面翻译随 sphinx.mo 自动生效；
# 项目级 sphinx.po 仅作为未来界面字符串覆盖的挂载点（P0 轻量决策，登记 handoff）。
sphinx_po = lc_dir / "sphinx.po"
if not sphinx_po.exists():
    sphinx_po.write_text(
        r"""# Sphinx 界面字符串覆盖占位（sphinx.po）
# Copyright (C) 2014-present, libuv contributors
# 本文件为占位（0 条目）：Sphinx 内置 zh_CN 界面翻译（sphinx/locale/zh_CN）已自动生效。
# 未来如需覆盖个别界面字符串，在此添加条目（msgid 需与 sphinx/locale/sphinx.pot 一致）。
#
msgid ""
msgstr ""
"Project-Id-Version: libuv docs 1.53.0\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: YEAR-MO-DA HO:MI+ZONE\n"
"PO-Revision-Date: 2026-11-18 03:40+0800\n"
"Last-Translator: jxsword <jxsword@users.noreply.github.com>\n"
"Language: zh_CN\n"
"Language-Team: zh_CN <LL@li.org>\n"
"Plural-Forms: nplurals=1; plural=0;\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"
""",
        encoding="utf-8",
    )

ATTRIBUTION = (
    "# 中文译文: libuv-zh-docs <https://github.com/jxsword/libuv-zh-docs> (CC BY 4.0)\n"
    "# 上游原文: libuv documentation v1.53.0 <https://docs.libuv.org/en/v1.x/> "
    "© libuv contributors (CC BY 4.0)\n"
)


def set_field(text: str, key: str, value: str) -> str:
    """替换 po 头部的带引号字段行（如 "Project-Id-Version: ...\\n"）。

    注意: 替换串必须经 lambda 传入——re.sub 的字符串替换是模板语法，
    其中的 \\n 会被 re 解析成真实换行（P0 实测踩坑）。
    """
    pat = re.compile(r'^"' + re.escape(key) + r': .*?\\n"$', re.MULTILINE)
    repl = f'"{key}: {value}\\n"'  # 字符串值: 反斜杠 + n 两个字符
    return pat.sub(lambda m: repl, text, count=1)


changed = 0
for po in sorted(lc_dir.rglob("*.po")):
    text = po.read_text(encoding="utf-8")
    orig = text
    # 1) 去除头部条目的 fuzzy 标志（#, fuzzy 紧邻头部 msgid "" 之前）
    text = re.sub(r"(?:#, fuzzy\n)(msgid \"\"\nmsgstr \"\"\n)", r"\1", text, count=1)
    # 2) 字段规范化
    text = set_field(text, "Project-Id-Version", f"libuv docs {BASELINE}")
    text = set_field(text, "Last-Translator", "jxsword <jxsword@users.noreply.github.com>")
    text = set_field(text, "PO-Revision-Date", "2026-11-18 03:40+0800")
    # 3) attribution 注释行：插在头部条目 msgid "" 之前
    if "中文译文:" not in text:
        text = text.replace(
            'msgid ""\nmsgstr ""',
            ATTRIBUTION + 'msgid ""\nmsgstr ""',
            1,
        )
    if text != orig:
        po.write_text(text, encoding="utf-8")
        changed += 1

print(f"  规范化 {changed}/{len(list(lc_dir.rglob('*.po')))} 个 po 头部")
PYEOF

echo "== init_po 完成 =="
