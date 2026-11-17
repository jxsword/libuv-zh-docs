#!/usr/bin/env bash
# validate_po.sh —— 翻译批次验收门禁（计划 §5 质检链）
#
# 用法:
#   scripts/validate_po.sh               # 全量模式: 全部 po + 构建冒烟
#   scripts/validate_po.sh file1.po ...  # 批次模式: 仅校验指定文件 + 全量构建冒烟
#   scripts/validate_po.sh --no-build    # 跳过构建冒烟（如已单独构建）
#   scripts/validate_po.sh --linkcheck   # 追加 linkcheck（批次收尾必跑）
#
# 门禁项（任一失败即退出 1）:
#   1. msgfmt -c 全量/指定文件        —— po 语法与标记完整性
#   2. fuzzy 硬门禁: 全库 '#, fuzzy' 计数必须为 0
#      （fuzzy 在 msgfmt 与 babel 两条编译路径均不进 .mo，计划 §5 规则4 / R1-4）
#   3. check_markup.py                —— 内联标记对等（role/字面量/URL/粗体）
#   4. term_check.py                  —— 术语黑名单 + 标识符保留
#   5. sphinx-intl stat               —— 全量模式按其退出码判定（fuzzy/未翻译 > 0 即失败）；
#      批次模式仅展示统计（全局未翻译数在多批次并行期间必然 > 0，门禁转为按文件 msgfmt 统计判定）
#   6. 构建冒烟 build_zh.sh           —— 零 error + 增量 warning 对照基线（reports/warning-baseline-v1.53.0.txt）
#   7. --linkcheck 时跑上游 linkcheck 目标
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PY="$REPO_ROOT/.venv/bin/python"
[ -x "$PY" ] || PY=python3
SI="$REPO_ROOT/.venv/bin/sphinx-intl"
[ -x "$SI" ] || SI=sphinx-intl

BUILD=1
LINKCHECK=0
FILES=()
for arg in "$@"; do
    case "$arg" in
        --no-build)  BUILD=0 ;;
        --linkcheck) LINKCHECK=1 ;;
        -*) echo "未知参数: $arg" >&2; exit 2 ;;
        *)  FILES+=("$arg") ;;
    esac
done

MODE=全量
[ ${#FILES[@]} -gt 0 ] && MODE=批次
echo "== validate_po（$MODE 模式）=="
rc=0

# --- 1. msgfmt -c ---
echo "-- 1/6 msgfmt -c --"
targets=("${FILES[@]:-}")
if [ ${#FILES[@]} -eq 0 ]; then
    mapfile -t targets < <(find "$REPO_ROOT/locale" -name '*.po')
fi
for f in "${targets[@]}"; do
    if ! msgfmt -c -o /dev/null "$f"; then
        echo "FAIL: msgfmt -c $f"; rc=1
    fi
done
echo "   ${#targets[@]} 个 po 校验完成"

# --- 2. fuzzy 硬门禁 ---
echo "-- 2/6 fuzzy 硬门禁 --"
if [ ${#FILES[@]} -gt 0 ]; then
    fuzzy_total=$(grep -c '^#, fuzzy' "${FILES[@]}" 2>/dev/null || true)
else
    fuzzy_total=$(grep -rc '^#, fuzzy' "$REPO_ROOT/locale" 2>/dev/null | awk -F: '{s+=$2} END {print s+0}')
fi
echo "   fuzzy 条目数: $fuzzy_total（必须为 0）"
[ "$fuzzy_total" -ne 0 ] && { echo "FAIL: 存在 fuzzy 条目——比对 #| 旧原文修订并清除标志后再验"; rc=1; }

# --- 3. check_markup ---
echo "-- 3/6 check_markup --"
if [ ${#FILES[@]} -gt 0 ]; then
    "$PY" "$REPO_ROOT/scripts/check_markup.py" "${FILES[@]}" || rc=1
else
    "$PY" "$REPO_ROOT/scripts/check_markup.py" || rc=1
fi

# --- 4. term_check ---
echo "-- 4/6 term_check --"
if [ ${#FILES[@]} -gt 0 ]; then
    "$PY" "$REPO_ROOT/scripts/term_check.py" "${FILES[@]}" || rc=1
else
    "$PY" "$REPO_ROOT/scripts/term_check.py" || rc=1
fi

# --- 5. sphinx-intl stat ---
echo "-- 5/6 sphinx-intl stat --"
if [ ${#FILES[@]} -eq 0 ]; then
    if "$SI" stat --locale-dir "$REPO_ROOT/locale" -l zh_CN; then
        echo "   stat 门禁通过（无 fuzzy/未翻译）"
    else
        echo "FAIL: sphinx-intl stat 报告存在 fuzzy 或未翻译条目（全量模式视为失败）"; rc=1
    fi
else
    "$SI" stat --locale-dir "$REPO_ROOT/locale" -l zh_CN || true
    echo "   批次模式: stat 仅展示；按文件翻译度由 msgfmt --statistics 判定"
    for f in "${FILES[@]}"; do
        st=$(LC_ALL=C msgfmt --statistics -o /dev/null "$f" 2>&1)
        echo "   $(basename "$f"): $st"
        if echo "$st" | grep -qE '[1-9][0-9]* untranslated|untranslated [1-9]'; then
            echo "FAIL: $f 尚有未翻译条目"; rc=1
        fi
    done
fi

# --- 6. 构建冒烟（零 error + 增量 warning 对照基线）---
if [ "$BUILD" -eq 1 ]; then
    echo "-- 6/6 构建冒烟 --"
    log=/tmp/validate-build.log
    if ! bash "$REPO_ROOT/scripts/build_zh.sh" > "$log" 2>&1; then
        echo "FAIL: 中文构建失败（日志: $log）"; tail -20 "$log"; rc=1
    else
        echo "   构建成功: $(tail -3 "$log" | grep -oE 'build succeeded[^.]*' || echo ok)"
        grep -E 'ERROR|CRITICAL' "$log" && { echo "FAIL: 构建存在 ERROR"; rc=1; }
        # 增量 warning 对照基线（基线含 11 条，此处仅数量告警，明细人工比对）
        wnow=$(grep -c 'WARNING' "$log" || true)
        wbase=$(grep -c 'WARNING' "$REPO_ROOT/reports/warning-baseline-v1.53.0.raw.log" || true)
        echo "   warning: 本次 $wnow / 基线 $wbase（数量上涨需人工比对明细）"
        [ "$wnow" -gt "$wbase" ] && { echo "FAIL: warning 数量超过基线"; rc=1; }
    fi
fi

# --- 7. linkcheck（可选）---
if [ "$LINKCHECK" -eq 1 ]; then
    echo "-- 7 linkcheck --"
    if [ -x "$REPO_ROOT/.venv/bin/sphinx-build" ]; then
        export PATH="$REPO_ROOT/.venv/bin:$PATH"
    fi
    if ! make -C "$REPO_ROOT/workdir/docs" linkcheck > /tmp/validate-linkcheck.log 2>&1; then
        echo "FAIL: linkcheck 失败（日志: /tmp/validate-linkcheck.log）"; rc=1
    else
        echo "   linkcheck 完成"
    fi
fi

echo "== validate_po 结束: $([ $rc -eq 0 ] && echo 门禁全绿 || echo 存在失败) =="
exit $rc
