# P0 收尾全链路验证（2026-11-18，第二次执行——修正 error 门禁语义后）

## 1. validate_po.sh 全量模式（含构建冒烟）
== validate_po（全量 模式）==
-- 1/6 msgfmt -c --
-- 2/6 fuzzy 硬门禁 --
   fuzzy 条目数: 0（必须为 0）
-- 3/6 check_markup --
-- 4/6 term_check --
-- 5/6 sphinx-intl stat --
FAIL: sphinx-intl stat 报告存在 fuzzy 或未翻译条目（全量模式视为失败）
-- 6/6 构建冒烟 --
   error: 本次 2 / 基线 2（上游存量，按增量比对）
   warning: 本次 9 / 基线 9（数量上涨需人工比对明细）
== validate_po 结束: 存在失败 ==
validate 整体退出码: 1（全量模式下 stat 门禁因 1728 条未翻译报失败 = P0 预期；fuzzy=0 / markup / term / 构建 增量门禁均绿）

## 2. po_stats
完成度: 0 / 1728（0%）| fuzzy: 0 | untranslated: 1728

## 3. fuzzy 硬门禁
fuzzy: 0

## 4. 占位站
HTTP 200（0.420286s）
