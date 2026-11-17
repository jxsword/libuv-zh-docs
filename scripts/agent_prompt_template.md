# Agent 批次翻译 Prompt 模板（agent_prompt_template.md）

> 用途: 每个 po 文件（或同文件的 msgid 区间分段）生成一份 agent 翻译任务 prompt。
> 使用: 复制下方模板，替换 `{{占位符}}` 后直接作为 agent prompt。同一 po 文件的多段任务**严禁并发写**（计划 §5 / R2-2）。

---

## 翻译任务：{{PO_FILE}}（批次 {{PHASE}}，msgid 区间 {{RANGE}}）

你是 libuv 官方文档中文翻译项目的批次翻译 agent。严格按以下要求完成**且仅完成**本任务。

### 输入（开工前依次通读）

1. 目标文件: `{{PO_FILE}}`（翻译发生地，逐条填写 msgstr）
2. 强制规范（全文遵守，冲突时以 STYLE_GUIDE 为准）:
   - `STYLE_GUIDE.md` —— 含 7 条硬性规则（只填 msgstr / 标记原样保留 / 标识符不译 / fuzzy 必清 / 术语与排版 / 不增不减 / 自检）
   - `glossary.md` —— 术语表（统一译名 + 禁用译名 + 错误描述惯用译法 + 不译清单）
3. 上游原文（理解上下文用，**禁止直接改写**）: `{{RST_PATH}}`
4. 批次报告输出路径: `{{BATCH_REPORT}}`（完成后写入）

### 任务步骤

1. 通读 STYLE_GUIDE.md 与 glossary.md 全文。
2. 处理 `{{PO_FILE}}` 中 {{RANGE}} 区间的每个条目：
   - 英文 msgid → 中文 msgstr；语义等价、不增不减；
   - 内联标记（role / ``…`` / **…** / URL）原样保留，标识符（`uv_*`、`UV_*`、`SIG*`、文件名）不译；
   - 若条目带 `#, fuzzy`：先读 `#|` 旧原文与新 msgid 逐句比对，修订 msgstr 后**删除 fuzzy 标志**；
   - 中英文之间加空格，全角标点（标记与代码内除外）。
3. 自检（全部通过才算完成）:
   ```bash
   msgfmt -c {{PO_FILE}}                    # 必须零错误
   grep -c '^#, fuzzy' {{PO_FILE}}          # 必须输出 0
   python3 scripts/check_markup.py {{PO_FILE}}   # 0 error
   python3 scripts/term_check.py {{PO_FILE}}     # 0 error
   ```
4. 写批次报告到 `{{BATCH_REPORT}}`：
   - 完成条目数 / 跳过条目数及原因；
   - 新术语提议（未收录术语 + 建议译名 + 理由）；
   - 采纳 neverwin 旧译文的条目清单（供 README 署名动态更新，计划 §9）；
   - 存疑条目（原文含糊/疑似上游笔误）与处理方式。

### 硬性禁区

- 禁止改动 msgid、位置注释、po 文件头；
- 禁止翻译/改动任何 `uv_*` / `UV_*` / `SIG*` / errno 名称 / 文件名；
- 禁止增删段落、合并拆分条目、重排条目顺序；
- 禁止把译文写成繁体或日文汉字变体；
- 禁止运行 gen_workdir / merge_po / init_po 等会改动 po 集合的脚本（仅限上文自检四条命令）。
