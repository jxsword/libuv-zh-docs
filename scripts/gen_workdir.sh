#!/usr/bin/env bash
# gen_workdir.sh —— 从 upstream/<tag> 快照确定性重建 workdir/
#
# 用法: scripts/gen_workdir.sh [TAG]        # TAG 默认 v1.53.0（DR-004 锁定基线）
#
# 布局硬性要求（计划 §4 / R1-2）:
#   workdir/docs/{src,code}/ 同级 —— guide 的 literalinclude ../../code/ 依赖此布局
#   workdir/include/uv/version.h —— conf.py::get_libuv_version() 以 CWD=workdir/docs
#     解析 open('../../include/uv/version.h') → 缺失时版本号显示 unknown（硬错误）
#   workdir/ 不入 git（.gitignore），CI 与本地均可确定性重建
#
# 安全偏离补丁: 上游 sphinx-plugins 插件含扫描器判定的模板注入风险模式，
#   gen_workdir 后自动套用 scripts/patches/manpage-security.patch（幂等）。

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAG="${1:-v1.53.0}"
# 安全校验：TAG 仅允许 v<数字>.<数字>.<数字> 形式（防拼接注入，Mimosa 审计建议）
if ! [[ "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "FATAL: 非法 TAG 格式: $TAG（仅允许 vX.Y.Z）" >&2
    exit 1
fi
UPSTREAM="$REPO_ROOT/upstream/$TAG"
WORKDIR="$REPO_ROOT/workdir"

echo "== gen_workdir: 基线 $TAG =="

# --- 1. 快照完整性检查 ---
if [ ! -d "$UPSTREAM/docs" ]; then
    echo "FATAL: 快照目录不存在: $UPSTREAM/docs" >&2
    echo "  请先按计划 §10 步骤2 获取上游快照" >&2
    exit 1
fi
if [ ! -f "$UPSTREAM/include/uv/version.h" ]; then
    echo "FATAL: include/uv/version.h 缺失（版本号将显示 unknown，属硬错误）" >&2
    exit 1
fi
if [ ! -f "$UPSTREAM/docs/src/conf.py" ]; then
    echo "FATAL: docs/src/conf.py 缺失" >&2
    exit 1
fi

# --- 2. 幂等重建 workdir ---
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

# --- 3. 镜像上游 docs/ 完整布局（保持 src/ 与 code/ 同级）---
cp -a "$UPSTREAM/docs" "$WORKDIR/docs"

# --- 4. include/uv/version.h 就位 ---
mkdir -p "$WORKDIR/include/uv"
cp -a "$UPSTREAM/include/uv/version.h" "$WORKDIR/include/uv/version.h"

# --- 5. 套用安全补丁（幂等：已加固则跳过）---
if ! grep -q 'libuv-zh-docs 安全加固' "$WORKDIR/docs/src/sphinx-plugins/manpage.py"; then
    echo "== 套用 manpage 安全补丁 =="
    patch --forward "$WORKDIR/docs/src/sphinx-plugins/manpage.py" \
        < "$REPO_ROOT/scripts/patches/manpage-security.patch" \
        || { echo "FATAL: 安全补丁套用失败" >&2; exit 1; }
fi

# --- 6. conf.py overlay（Python 后行赋值覆盖前行）---
if ! grep -q 'libuv-zh-docs overlay' "$WORKDIR/docs/src/conf.py"; then
    cat >> "$WORKDIR/docs/src/conf.py" <<'OVERLAY_EOF'

# --- libuv-zh-docs overlay（gen_workdir.sh 追加，勿手改 workdir；改 scripts/gen_workdir.sh）---
language = 'zh_CN'
locale_dirs = ['../../../locale']   # 相对 srcdir（workdir/docs/src/）→ 仓库根 locale/
gettext_compact = False             # 按 rst 文件拆分 pot/po（41+1 个 po）
html_title = 'libuv documentation（中文翻译）'
gettext_additional_targets = []     # 与上游行为对齐：literal block 不抽取（计划 §3）
# IBM 文档站对自动化请求返回 403（bot 防护，非死链；PR CI linkcheck 实测 2026-11-18），
# 沿用上游 linkcheck_ignore 机制（上游同样忽略 invisible-island.net）
linkcheck_ignore = linkcheck_ignore + [
    r'https://www\.ibm\.com/docs/.*',
]
OVERLAY_EOF
    echo "== conf.py overlay 已追加 =="
else
    echo "== conf.py overlay 已存在，跳过 =="
fi

# --- 7. 布局自检 ---
echo "== 布局自检 =="
test -d "$WORKDIR/docs/src" && test -d "$WORKDIR/docs/code" && echo "  src/ 与 code/ 同级 ✓"
test -f "$WORKDIR/include/uv/version.h" && echo "  include/uv/version.h 就位 ✓"
test -f "$WORKDIR/docs/src/static/logo.png" && echo "  static/ 资源就位 ✓"
rst_count=$(find "$WORKDIR/docs/src" -name '*.rst' | wc -l)
echo "  rst 文件数: $rst_count"

echo "== gen_workdir 完成: $WORKDIR =="
