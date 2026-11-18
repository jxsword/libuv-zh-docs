# 会话交接文档（handoff-latest）

> 更新: 2026-11-19 ｜ 里程碑: **P3 完成（网络/进程/线程 8 文件已发布）** ｜ 下一批: **P4 收尾批次（最后一批，36 条 + 全库 sweep → v1.0）**
> 本文件是每批次收尾更新的唯一交接入口；新会话开工前**必读**本文件 + 计划 §5/§7。

## 1. 状态快照

- 分支: `p3-net-proc-thread` → PR #3（validate 53s 绿）→ squash merge **main@a9ea2bc**；Pages 自动发布完成，站点 https://jxsword.github.io/libuv-zh-docs/ 已含网络/进程/线程 API 中文页。
- 翻译进度 **1692 / 1728（97%）**，fuzzy=0；P1（509）+ P2（799）+ P3（384）100% 完成；剩余 36 条全部属 P4（api 1 / migration_010_100 33 / upgrading 2）。
- 终态门禁: msgfmt 8 文件零错误 / check_markup 全库 0 error / term_check 全库 0 error（黑名单 **51 词**）/ validate_po.sh 批次模式 exit=0 / 中文构建 error 2=基线 2、warning **9=基线 9（零增量）**。
- 术语表: §2.2 新增 P3 批次 45 条（总数 ~217）；§4 不译清单 +1 行（P3 裁决行）；§5.1 黑名单 51 词。
- STYLE_GUIDE §2 补「返回/参数」字段标签工件定案（Sphinx `:param:`/`:returns:` 本地化进 msgid，恒填「返回」「参数」）。
- 决策: **DR-005** 生效（decision_log）——上游 role 缺冒号笔误条目（udp/stream 各 1）译文逐字镜像残片，check_markup.py 邻接 role 正则加 `(?<![\w])` 负向前瞻。

## 2. P3 关键经验（坑位沉淀，接 P2 §2）

1. **上游 role 缺前导冒号笔误的处置已定案（DR-005）**：`c:func:` 残片三种译法在旧门禁下均 fail（规范化→sphinx 引用一致性 warning +2；镜像→邻接误报 error；改写→role 对等 error）。定案 = check_markup 邻接正则加负向前瞻 + 译文逐字镜像（渲染与英文页一致）。后续同类笔误照此办理，勿再争论。
2. **`msgid "参数"` 是「返回」同类工件**：`:param:` 标签同样被本地化进 msgid（无行号），恒填「参数」。已写入 STYLE_GUIDE §2，全库此类条目目前仅 tcp/udp 各 1–2 处。
3. **同 msgid 跨文件对齐方法论（proof B 实证）**：脚本抽取 msgid 全文比对 + P1/P2 先入库者为准，P3 修 6 处（含 fs.po 2 条「同样适用」缺「也」——P1/P2 内部少数派已归一）；346 个唯一 msgid 中跨文件共享 16 个、全库共享 15 个，比例不高但值得查。
4. **communication channel 词根裁决**：信道→通道统一（IPC/管道语域），glossary §2.2 有案；后续 sweep 注意「信道」残留（当前全库已清零）。
5. **本机新增 MemGate 规则**：长任务/内存不可预估的解释器脚本一律 `memgate <命令…>` 包裹（本批 validate_po.sh / po_stats.sh / term_check / msgfmt 均已实践）。
6. agent 编排：384 条用 3 翻译 agent（114/114/156）× 2 波即可，不必凑 3 波；校对 A/B 组按「只改自己文件、跨组发现只登记」规则并发零冲突。
7. Mimosa 钩子在 commit/push 前提示补扫属兼容策略（docs 仓库仅上游示例代码 4 条 MEDIUM 误报级发现，P2 已定性，无需处理）。

## 3. P4 入口（下一批，收尾批次）

- 范围: **api(1) / migration_010_100(33) / upgrading(2)，共 36 条**（明细 reports/pot-stats-v1.53.0.md）+ **sphinx.po 界面串裁决**（当前 0 条译入；zh 界面已有部分本地化，需裁决是否译入及范围）。
- 流程建议: 1 个翻译 agent（3 文件 36 条）→ **全库术语一致性 sweep agent**（含同 msgid 全库对齐、fs.po 类内部分歧复查、「信道」残留检查）→ 主控终态裁决 → `validate_po.sh` **全量模式**（此时 sphinx-intl stat 门禁应首次全绿：untranslated=0）→ PR → CI 绿 → squash merge → Pages → **v1.0 全量发布**（README/站点署名与免责声明复核）。
- 校对重点: migration/upgrading 文件含大量版本号与历史表述，版本号/标识符不译；全文 sweep 以 glossary §2/§2.1/§2.2 + 黑名单 51 词为唯一依据。
- v1.0 后进入随上游 release 的增量模式（计划 §6；upstream-watch.yml 已就位）。

## 4. 硬性纪律（重申）

- 一切以计划文档为准；改架构/目录/工具链属重大决策（决策矩阵 + 用户确认 + decision_log）。
- fuzzy 硬门禁：任何构建前 fuzzy=0；修订 fuzzy 必须先比对 `#|` 旧原文。
- 只填 msgstr；msgid/注释/文件头禁改；`uv_*`/`UV_*`/`SIG*`/errno/文件名不译；标记原样保留（含邻接规则；DR-005 已修正邻接 role 正则）。
- 改 po 用 Edit 工具（先 Read）；网络纪律：gh api 直连优先，失败走代理 http://192.168.33.1:10808 回退一次；提权经 zcode-run；长脚本经 memgate。
- 初译期上游发版只开 issue 不切基线（DR-004）。
- 每批次一个 squash commit；批次收尾必更新本文件与 reports/progress.md；里程碑处主动建议开新会话。
