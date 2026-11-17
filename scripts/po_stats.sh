#!/usr/bin/env bash
# po_stats.sh —— 进度统计 → reports/progress.md（计划 §4 / R2-3）
# 用法: scripts/po_stats.sh
# 产物: reports/progress.md（文件 × translated/fuzzy/untranslated × 批次归属 + 总计）
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LC_DIR="$REPO_ROOT/locale/zh_CN/LC_MESSAGES"

# 批次归属（计划 §7，P0 实测修正: freertos.rst 已不在 v1.53.0）
phase_of() {
    case "$1" in
        index|design|guide|guide/about|guide/introduction|guide/basics|guide/eventloops|guide/networking|guide/filesystem|guide/processes|guide/threads|guide/utilities) echo "P1" ;;
        errors|version|loop|handle|request|timer|prepare|check|idle|async|poll|signal|fs|fs_event|fs_poll|dns|dll|metrics|misc) echo "P2" ;;
        stream|tcp|pipe|tty|udp|process|threading|threadpool) echo "P3" ;;
        api|migration_010_100|upgrading) echo "P4" ;;
        sphinx) echo "UI" ;;
        *) echo "-" ;;
    esac
}

stats_line() {  # 文件 → "translated fuzzy untranslated"
    LC_ALL=C msgfmt --statistics -o /dev/null "$1" 2>&1
}

total_t=0; total_f=0; total_u=0
rows=""
for po in $(find "$LC_DIR" -name '*.po' | sort); do
    name="${po#$LC_DIR/}"; name="${name%.po}"
    line=$(stats_line "$po")
    t=$(echo "$line" | grep -oE '[0-9]+ translated' | grep -oE '^[0-9]+' || echo 0)
    f=$(echo "$line" | grep -oE '[0-9]+ fuzzy' | grep -oE '^[0-9]+' || echo 0)
    u=$(echo "$line" | grep -oE '[0-9]+ untranslated' | grep -oE '^[0-9]+' || echo 0)
    t=${t:-0}; f=${f:-0}; u=${u:-0}
    total_t=$((total_t + t)); total_f=$((total_f + f)); total_u=$((total_u + u))
    rows+="| $name | $(phase_of "$name") | $t | $f | $u |"$'\n'
done

total=$((total_t + total_f + total_u))
pct=$(( total > 0 ? (total_t * 100 / total) : 100 ))

cat > "$REPO_ROOT/reports/progress.md" <<EOF
# 翻译进度看板（po_stats.sh 自动生成，勿手改）

> 最近更新: $(date '+%F %T %Z') ｜ 基线: v1.53.0（DR-004）｜ 总条目: $total

| 文件 | 批次 | translated | fuzzy | untranslated |
|---|---|---:|---:|---:|
$rows
| **合计** | - | **$total_t** | **$total_f** | **$total_u** |

**完成度: $total_t / $total（$pct%）** ｜ fuzzy 硬门禁: $([ "$total_f" -eq 0 ] && echo "✅ 0" || echo "❌ $total")

批次完成度: P1（509 条）/ P2（799 条）/ P3（384 条）/ P4（36 条）—— 对应计划 §7
EOF

echo "== progress.md 已生成 =="
echo "完成度: $total_t / $total（$pct%）| fuzzy: $total_f | untranslated: $total_u"
