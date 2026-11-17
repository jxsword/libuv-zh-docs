# 会话交接文档（handoff-latest）

> 更新: 2026-11-18 ｜ 里程碑: **P1 完成（中文站首发待发布）** ｜ 下一批: P2（核心 API 19 文件，799 条，errors.rst 优先）
> 本文件是每批次收尾更新的唯一交接入口；新会话开工前**必读**本文件 + 计划 §5/§7。

## 1. 状态快照

- 分支: `p1-intro`（12 文件 509 条译文 + 修复 + 报告），PR 流程：PR → pr.yml（validate + linkcheck）→ squash merge 进 main → pages.yml 自动发布 **https://jxsword.github.io/libuv-zh-docs/** 中文站。
- main@f67517e（CI 门禁批次化 + linkcheck 步骤）；远程 SSH 通道可用。
- 翻译进度 **509 / 1728（29%）**，fuzzy=0；P1 全部 12 文件 100% 翻译。
- 终态门禁: msgfmt -c 全过 / check_markup 0 error（含新邻接规则）/ term_check 0 error / validate_po 批次模式 exit=0 / 中文构建 warning=基线 9 行 0 新增。
- 术语表: §2 已扩至 ~91 条（P1 新增 48），§5.1 黑名单 43 词。

## 2. P1 关键经验（坑位沉淀）

1. **内联标记邻接规则**（本轮最大坑）：`**`/`*`/`` `` ``/`` ` `` 起始前/结束后必须邻空白或全角标点；结束后紧跟全角开括号「（」也会炸（连 Sphinx 引用一致性告警都会触发）。已固化进 check_markup.py（error 级）+ STYLE_GUIDE §2。修法 = 标记两侧补半角空格。
2. **`::` 结尾条目定案**：译文全角冒号「：」收尾即可，无需保留 `::`（实证：sphinx i18n doctree 层替换，HTML 仍输出 `<pre>` 代码块）；两种写法渲染等价，全库统一前者。勿再争论。
3. **agent 并发上限 2**：本机 zcode 会话并行 agent 上限 2（不是计划的 3–5）；波次编排按 2 并行设计，小文件可合并给单 agent 串行处理（1 po = 1 agent 任务的精神是禁并发写同文件，串行合并不违规）。
4. **agent 标题与任务可能错位**：并发拒绝/恢复后 agent 的显示标题与实际任务可能不一致，**以文件实际状态为准**（msgfmt --statistics 快查），勿信标题。
5. **agent 会因"Start Plan is busy"流恢复耗尽而失败**：失败后文件可能 0 写入（未开始）或部分写入；重启任务前必须先查文件实际状态，再决定续做还是重做。
6. **本机 linkcheck 不可判定**：直连 DNS 失败、代理出口 502——权威判定放 PR CI（pr.yml 已加 linkcheck 步骤）。
7. msgfmt 无 `-o` 落 messages.mo；babel 拒绝日期占位符；runner 需显式装 gettext——均见 P0 handoff §4（仍然有效）。

## 3. P2 入口（下一批）

- 范围: 19 文件 799 条（明细见 reports/pot-stats-v1.53.0.md）；**errors.rst（93 条）优先**——错误描述惯用译法 glossary §3 已备好。
- 大文件: misc 157（P2 最大）、fs 138——单 agent 任务，必要时按 msgid 区间分段串行（同文件严禁并发写）。
- 流程同 P1：模板生成 prompt → 并行翻译（2 波次）→ 自检 → 2 校对 agent（含邻接规则机器扫描）→ 修复 → validate_po 批次门禁 + PR CI → squash merge → Pages。
- 校对重点: uv_* 标识符顺序保持（term_check 强制）、role/字面量逐字相等、邻接规则（机器门禁会拦）。

## 4. 硬性纪律（重申）

- 一切以计划文档为准；改架构/目录/工具链属重大决策（决策矩阵 + 用户确认 + decision_log）。
- fuzzy 硬门禁：任何构建前 fuzzy=0；修订 fuzzy 必须先比对 `#|` 旧原文。
- 只填 msgstr；msgid/注释/文件头禁改；`uv_*`/`UV_*`/`SIG*`/errno/文件名不译；标记原样保留（含邻接规则）。
- 网络纪律：gh api 直连优先，失败走代理 http://192.168.33.1:10808 回退一次；提权经 zcode-run。
- 初译期上游发版只开 issue 不切基线（DR-004）。
- 每批次一个 squash commit；批次收尾必更新本文件与 reports/progress.md。
