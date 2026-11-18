# 会话交接文档（handoff-latest）

> 更新: 2026-11-18 ｜ 里程碑: **P2 完成（核心 API 19 文件已发布）** ｜ 下一批: P3（网络/进程/线程 8 文件，384 条）
> 本文件是每批次收尾更新的唯一交接入口；新会话开工前**必读**本文件 + 计划 §5/§7。

## 1. 状态快照

- 分支: `p2-core-api` → PR #2（validate 1m1s 绿）→ squash merge **main@c71ad21**；Pages 自动发布完成，站点 https://jxsword.github.io/libuv-zh-docs/ 已含核心 API 中文页。
- 翻译进度 **1308 / 1728（75%）**，fuzzy=0；P1（509）+ P2（799）100% 完成。
- 终态门禁: msgfmt -c 全过 / check_markup 19 文件 0 error / term_check 0 error（黑名单扩至 **50 词**）/ validate_po.sh 批次模式 exit=0 / 中文构建 error 2=基线 2、warning 9=基线 9（零增量）。
- 术语表: §2.1 新增 P2 批次 81 条（总数 ~172）；§4 不译清单 +6；§5.1 黑名单 50 词。
- STYLE_GUIDE §3.8 新增体例惯例（标题分隔符 `---`→「——」、Public members→公开成员、i/o→I/O、versionchanged 片段体例）。

## 2. P2 关键经验（坑位沉淀，接 P1 §2）

1. **大文件单 agent 直翻可行**：misc(157)/fs(138) 单 agent 全量直翻成功，关键约束是「每 15–20 条写回一次」防中断丢失（P1 经验 5 的对策）；无需按 msgid 区间拆段。
2. **`msgid "返回"` 抽取工件**：overlay 固化 `language=zh_CN` 使 Sphinx `:returns:` 字段标签在 gettext 抽取时被本地化进 msgid（位置注释无行号）。恒等译文「返回」无害；含 P3 的 tcp/udp 也有，按已知工件处理，勿报缺陷。
3. **同一 msgid 跨文件异译**：misc 与 fs_event 存在相同 msgid 译法不同（`:returns:` 类短句）；validate_po 不查跨文件一致性，校对阶段需 grep 同 msgid 对齐（先入库者为准）。P4 sweep 加查此项。
4. **term_check 黑名单是终态统一利器**：批次收尾裁决术语后，把弃用译法加入 §5.1 黑名单并全量复扫，能抓出所有残留（本次抓出 misc 3 处漏改）；黑名单只收**无歧义**禁用词（「联合」这类普通词不可收）。
5. **Bash sed 直改 po 会被钩子拦截**：改 po 用 Edit 工具（先 Read 后 Edit）；批量只读统计/校验用 Bash 无碍。
6. 本机 agent 并发上限 2（P1 经验 3 仍有效）；3 波 × 2 并发完成 799 条，单 agent 任务粒度 113–157 条为宜。
7. 本机 linkcheck 不可判定（权威判定在 PR CI，P1 经验 6 仍有效）；Mimosa 钩子会在 commit/push 前提示补跑完整扫描（docs 仓库仅上游示例代码 4 条 MEDIUM 误报级发现，无需处理）。

## 3. P3 入口（下一批）

- 范围: 8 文件 384 条（**udp 95 / tcp 58 / stream 56 / threading 48 / pipe 39 / process 38 / tty 31 / threadpool 19**，明细 reports/pot-stats-v1.53.0.md）。
- 术语直接复用 P2 预置: 控制终端、原始模式（tty）、带外消息、电平触发（tcp）、递送（process）、主进程/工作进程/守护进程（process）。
- 流程同 P2：模板生成 prompt → 3 波 × 2 并发（agent 粒度 ~100–160 条）→ 自检 → 2 校对 agent（A 组大文件 udp+tcp+stream / B 组其余，含同 msgid 跨文件对齐）→ 主控终态统一 → validate_po 批次门禁 + PR CI → squash merge → Pages。
- 校对重点: uv_* 标识符顺序、邻接规则（机器门禁拦）、stream/tcp 共用句式跨文件一致。

## 4. 硬性纪律（重申）

- 一切以计划文档为准；改架构/目录/工具链属重大决策（决策矩阵 + 用户确认 + decision_log）。
- fuzzy 硬门禁：任何构建前 fuzzy=0；修订 fuzzy 必须先比对 `#|` 旧原文。
- 只填 msgstr；msgid/注释/文件头禁改；`uv_*`/`UV_*`/`SIG*`/errno/文件名不译；标记原样保留（含邻接规则）。
- 改 po 用 Edit 工具（先 Read）；网络纪律：gh api 直连优先，失败走代理 http://192.168.33.1:10808 回退一次；提权经 zcode-run。
- 初译期上游发版只开 issue 不切基线（DR-004）。
- 每批次一个 squash commit；批次收尾必更新本文件与 reports/progress.md；里程碑处主动建议开新会话。
