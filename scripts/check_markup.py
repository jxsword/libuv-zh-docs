#!/usr/bin/env python3
"""check_markup.py —— po 条目 msgid ↔ msgstr 内联 rst 标记对等校验（计划 §4 / §8）。

比 msgfmt -c 更强的门禁：msgfmt 只查 po 语法，本脚本保证 rst 内联标记在译文中
不丢失、不变形（计划 §8 风险表第 1 行的对策之一）。

校验项（error，出现即退出码 1）:
  1. role 括注目标逐字相等   :c:func:`uv_run()` / :ref:`basics` / :man:`poll(2)` 等
  2. 双反引号字面量逐字相等  ``literal``
  3. URL 逐字相等            https?://...
  4. 粗体 **…** 数量对等
校验项（warning，仅提示）:
  5. 单反引号 `…` 内容不等（默认 role 内容多为可译文本，存在合法翻译场景）
  6. 斜体 *…* 数量不等
  7. msgstr 行尾空格

用法:
  python3 scripts/check_markup.py [po文件...]      # 缺省扫描 locale/zh_CN 全部 .po
"""

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LOCALE_DIR = REPO_ROOT / "locale" / "zh_CN" / "LC_MESSAGES"

# ---------- 极简 po 解析（无第三方依赖） ----------

STR_RE = re.compile(r'"((?:[^"\\]|\\.)*)"')
ENTRY_RE = re.compile(r'^(msgid|msgstr|msgctxt)\s+"')
OBS_RE = re.compile(r"^#~")


def unescape(s: str) -> str:
    """po 字符串转义反转（\n \t \" \\）。"""
    out = []
    i = 0
    while i < len(s):
        c = s[i]
        if c == "\\" and i + 1 < len(s):
            nxt = s[i + 1]
            out.append({"n": "\n", "t": "\t", '"': '"', "\\": "\\"}.get(nxt, "\\" + nxt))
            i += 2
        else:
            out.append(c)
            i += 1
    return "".join(out)


def parse_po(path: Path):
    """返回条目列表 [{msgid, msgstr, flags:set, obsolete:bool}]；解析失败抛 ValueError。"""
    entries = []
    cur = {"msgid": [], "msgstr": [], "flags": set(), "obsolete": False}
    field = None

    def flush():
        nonlocal cur, field
        if cur["msgid"] or cur["msgstr"]:
            entries.append(
                {
                    "msgid": unescape("".join(cur["msgid"])),
                    "msgstr": unescape("".join(cur["msgstr"])),
                    "flags": cur["flags"],
                    "obsolete": cur["obsolete"],
                }
            )
        cur = {"msgid": [], "msgstr": [], "flags": set(), "obsolete": False}
        field = None

    with path.open(encoding="utf-8") as fh:
        for raw in fh:
            line = raw.rstrip("\n")
            if not line.strip():
                flush()
                field = None
                continue
            if line.startswith("#"):
                if line.startswith("#,"):
                    cur["flags"].update(
                        f.strip() for f in line[2:].split(",") if f.strip()
                    )
                continue
            m = ENTRY_RE.match(line)
            if m:
                if m.group(1) == "msgid" and field in ("msgid", "msgstr"):
                    flush()  # 新条目开始（无空行分隔的容错）
                field = m.group(1)
                val = STR_RE.search(line)
                target = cur["msgid"] if field == "msgid" else cur["msgstr"]
                if field == "msgctxt":
                    field = None
                elif val:
                    target.append(val.group(1))
                continue
            if line.startswith('"') and field:
                val = STR_RE.match(line)
                if val:
                    target = cur["msgid"] if field == "msgid" else cur["msgstr"]
                    target.append(val.group(1))
                continue
            if OBS_RE.match(line):
                cur["obsolete"] = True
                line = line[3:]
                m = ENTRY_RE.match(line)
                if m:
                    field = m.group(1)
                    val = STR_RE.search(line)
                    if field == "msgid" and val:
                        cur["msgid"].append(val.group(1))
                    elif field == "msgstr" and val:
                        cur["msgstr"].append(val.group(1))
                elif line.startswith('"') and field:
                    val = STR_RE.match(line)
                    if val:
                        target = cur["msgid"] if field == "msgid" else cur["msgstr"]
                        target.append(val.group(1))
                continue
            # 无法识别的行：容错跳过
    flush()
    return entries


# ---------- 标记 token 提取 ----------

ROLE_RE = re.compile(r":[\w.:+-]*:`([^`]+)`")
LIT2_RE = re.compile(r"``([^`]+)``")
URL_RE = re.compile(r"https?://[^\s`<>\")]+")
BOLD_RE = re.compile(r"\*\*[^*]+\*\*")
ITAL_RE = re.compile(r"(?<!\*)\*(?!\*)[^*\n]+\*(?!\*)")
LIT1_RE = re.compile(r"`([^`]+)`")


def _strip_spans(text: str, spans) -> str:
    """把已匹配的 span 替换为占位符，避免后续正则重复命中。"""
    for start, end in sorted(spans, reverse=True):
        text = text[:start] + "\x00" + text[end:]
    return text


def extract(text: str) -> dict:
    """提取各类标记 token（role 先提取并抹除，防止 `` ` `` 嵌套误判）。"""
    roles = ROLE_RE.findall(text)
    t = _strip_spans(text, [m.span() for m in ROLE_RE.finditer(text)])
    lits2 = LIT2_RE.findall(t)
    t = _strip_spans(t, [m.span() for m in LIT2_RE.finditer(t)])
    urls = URL_RE.findall(t)
    t = _strip_spans(t, [m.span() for m in URL_RE.finditer(t)])
    bold = BOLD_RE.findall(t)
    ital = [m for m in ITAL_RE.findall(t)]
    rest = _strip_spans(t, [m.span() for m in BOLD_RE.finditer(t)] + [m.span() for m in ITAL_RE.finditer(t)])
    lits1 = LIT1_RE.findall(rest)
    return {"roles": roles, "lits2": lits2, "urls": urls, "bold": bold, "ital": ital, "lits1": lits1}


# ---------- 邻接规则（P1 校对轮引入：内联标记紧邻 CJK/全角开括号 → 渲染损坏） ----------

# docutils 内联标记识别要求起始标记前、结束标记后为 \W 字符（空白/标点/行界）。
# 中文汉字属 \w，紧邻即失效（星号反引号变字面量，部分静默无警告）。
# 全角开括号（【〔 属 openers，允许作起始前缀但不允许作结束后缀（P1 实测 processes.po）。
ADJ_OPENERS = "（【〔｛"


def adjacency_errors(msgstr: str) -> list:
    """检查 msgstr 中所有内联标记的邻接字符，返回问题列表。"""
    errs = []
    token_re = re.compile(
        r"``[^`]+``"          # 双反引号字面量
        r"|\*\*[^*]+\*\*"     # 粗体
        r"|`[^`]+`_"          # 命名引用（含尾部 _）
        r"|:[\w.:+-]*:`[^`]+`"  # role（防被单反引号规则误拆）
        r"|`[^`]+`"           # 单反引号
        r"|\*[^*\n]+\*"       # 斜体
    )
    for m in token_re.finditer(msgstr):
        start, end = m.span()
        tok = m.group(0)
        if start > 0:
            prev = msgstr[start - 1]
            if re.match(r"\w", prev, re.UNICODE):
                errs.append(f"起始标记 …{tok[:10]} 前邻接汉字/字母「{prev}」→ 渲染损坏（补半角空格）")
        if end < len(msgstr):
            nxt = msgstr[end]
            if re.match(r"\w", nxt, re.UNICODE):
                errs.append(f"结束标记 {tok[-10:]}… 后邻接汉字/字母「{nxt}」→ 渲染损坏（补半角空格）")
            elif nxt in ADJ_OPENERS:
                errs.append(f"结束标记 {tok[-10:]}… 后紧跟全角开括号「{nxt}」→ 引用解析失败")
    return errs


def main() -> int:
    files = [Path(a) for a in sys.argv[1:]] or sorted(LOCALE_DIR.rglob("*.po"))
    if not files:
        print("check_markup: 未找到 po 文件（合法，P0 前）")
        return 0

    errors = 0
    warnings = 0
    for po in files:
        if not po.exists():
            print(f"ERROR: 文件不存在: {po}")
            errors += 1
            continue
        entries = parse_po(po)
        for idx, e in enumerate(entries):
            if e["obsolete"] or e["msgid"] == "" or not e["msgstr"].strip():
                continue
            src = extract(e["msgid"])
            dst = extract(e["msgstr"])
            where = f"{po} #{idx}"

            def err(msg):
                nonlocal errors
                errors += 1
                print(f"ERROR [{where}] {msg}")

            def warn(msg):
                nonlocal warnings
                warnings += 1
                print(f"WARN  [{where}] {msg}")

            if src["roles"] != dst["roles"]:
                err(f"role 括注目标不一致:\n    msgid: {src['roles']}\n    msgstr: {dst['roles']}")
            if src["lits2"] != dst["lits2"]:
                err(f"``字面量`` 不一致:\n    msgid: {src['lits2']}\n    msgstr: {dst['lits2']}")
            if src["urls"] != dst["urls"]:
                err(f"URL 不一致:\n    msgid: {src['urls']}\n    msgstr: {dst['urls']}")
            if len(src["bold"]) != len(dst["bold"]):
                err(f"**粗体** 数量不等: msgid={len(src['bold'])} msgstr={len(dst['bold'])}")
            if len(src["ital"]) != len(dst["ital"]):
                warn(f"*斜体* 数量不等: msgid={len(src['ital'])} msgstr={len(dst['ital'])}")
            if src["lits1"] != dst["lits1"]:
                warn(f"`单反引号` 内容不一致（若为默认 role 可译文本请人工确认）:\n    msgid: {src['lits1']}\n    msgstr: {dst['lits1']}")
            for adj_err in adjacency_errors(e["msgstr"]):
                err(adj_err)
            for ln in e["msgstr"].split("\n"):
                if ln != ln.rstrip():
                    warn("msgstr 存在行尾空格")
                    break

    print(f"check_markup: {len(files)} 文件，{errors} error / {warnings} warning")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
