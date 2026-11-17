#!/usr/bin/env python3
"""term_check.py —— 术语一致性机器扫描（计划 §4 / §8）。

数据源: glossary.md §5.1 禁用译名黑名单（一行一条，机器可读）。

检查项:
  1. 黑名单词出现在任何非空 msgstr → ERROR（术语违规）
  2. 标识符保留: msgid 中的 UV_* 宏 / uv_* 函数与类型 / SIG* 信号名，
     在 msgstr 中必须逐一保留（计数对等）→ ERROR（规则 3「不译」的机器执行）
  3. 白名单豁免: obsolete 条目（#~）与空译文跳过

用法:
  python3 scripts/term_check.py [po文件...]      # 缺省扫描 locale/zh_CN 全部 .po
"""

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
GLOSSARY = REPO_ROOT / "glossary.md"
LOCALE_DIR = REPO_ROOT / "locale" / "zh_CN" / "LC_MESSAGES"

sys.path.insert(0, str(Path(__file__).resolve().parent))
from check_markup import parse_po  # 复用极简 po 解析器

# 标识符保留模式（STYLE_GUIDE §2 / glossary §4 不译清单的机器执行）
IDENT_PATTERNS = [
    re.compile(r"\bUV_[A-Z0-9_]+\b"),
    re.compile(r"\buv_[a-z0-9_]+\b"),
    re.compile(r"\bSIG[A-Z0-9]+\b"),
]


def load_blacklist() -> list:
    """从 glossary.md §5.1 提取黑名单（### 5.1 与下一个 ### 之间的非注释行）。"""
    text = GLOSSARY.read_text(encoding="utf-8")
    m = re.search(r"### 5\.1 .*?\n(.*?)(?=\n### |\n## |\Z)", text, re.DOTALL)
    if not m:
        print("ERROR: glossary.md 缺少 §5.1 黑名单数据块")
        sys.exit(2)
    terms = []
    for line in m.group(1).splitlines():
        line = line.strip()
        if line and not line.startswith("#") and not line.startswith(">"):
            terms.append(line)
    return terms


def main() -> int:
    blacklist = load_blacklist()
    files = [Path(a) for a in sys.argv[1:]] or sorted(LOCALE_DIR.rglob("*.po"))
    if not files:
        print("term_check: 未找到 po 文件（合法，P0 前）")
        return 0

    errors = 0
    checked = 0
    for po in files:
        if not po.exists():
            print(f"ERROR: 文件不存在: {po}")
            errors += 1
            continue
        for idx, e in enumerate(parse_po(po)):
            if e["obsolete"] or not e["msgstr"].strip() or e["msgid"] == "":
                continue
            checked += 1
            where = f"{po} #{idx}"

            for term in blacklist:
                if term in e["msgstr"]:
                    errors += 1
                    print(f"ERROR [{where}] 术语违规: 译文含禁用词「{term}」")
                    print(f"    msgstr: {e['msgstr'][:80]}")

            for pat in IDENT_PATTERNS:
                src_tokens = pat.findall(e["msgid"])
                dst_tokens = pat.findall(e["msgstr"])
                if src_tokens and src_tokens != dst_tokens:
                    errors += 1
                    print(f"ERROR [{where}] 标识符丢失/篡改: msgid={src_tokens} msgstr={dst_tokens}")

    print(f"term_check: {len(files)} 文件，{checked} 条译文，黑名单 {len(blacklist)} 词")
    print(f"term_check: {errors} error")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
