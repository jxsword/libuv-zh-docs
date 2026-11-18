# 会话交接文档（handoff-latest）

> 更新: 2026-11-19 ｜ 里程碑: **P4 完成 · v1.0 全量发布（1728/1728 = 100%）** ｜ 下一阶段: **增量同步模式（计划 §6）**
> 本文件是每批次/sync 收尾更新的唯一交接入口；新会话开工前**必读**本文件 + 计划 §5/§6。

## 1. 状态快照

- 分支: `p4-final` → PR #4（validate 全量绿）→ squash merge 进 main；Pages 自动发布完成，**v1.0 全量发布**：站点 https://jxsword.github.io/libuv-zh-docs/ 42 页全部中文（含 guide 12 + 核心 API 19 + 网络/进程/线程 8 + api/migration/upgrading 3）。
- 翻译进度 **1728 / 1728（100%）**，fuzzy=0，untranslated=0——`sphinx-intl stat` 全量门禁**项目史上首次全绿**；P1（509）+ P2（799）+ P3（384）+ P4（36：api 1 / migration_010_100 33 / upgrading 2）全部完成。
- 终态门禁: msgfmt 43 po 零错误 / check_markup 全库 0 error（16 warning 为 P1–P2 既有提示级基线）/ term_check 0 error（黑名单 **51 词**）/ stat 全绿 / 构建 error 2=基线 2、warning 9=基线 9（零增量）。
- 全库一致性 sweep（P4 终检）: 同 msgid 跨文件对齐 **0 组不一致**（1573 唯一 msgid / 跨文件共享 35 组，双解析器交叉验证）、「信道」残留 0、黑名单复扫 0 error、P4 新译 36 条终检全合规——**四项零缺陷，0 修改**。
- 术语表: §2.3 新增 P4 批次 4 条（by value→按值传递、roundtrip→往返、deprecated→弃用、internals→内部结构；duality 仅备案），总数 ~221 条；§4 不译清单无新增。
- sphinx.po 裁决: **不译入，保持 0 条占位**（Sphinx 内置 zh_CN 界面翻译已生效，构建页实测含「搜索」等本地化串；覆盖式翻译零收益正成本，详见 P4 报告 §8.1）。
- 站点 footer: 计划 §9「站点可见位置」非官方声明已补齐——gen_workdir.sh overlay 对上游 `copyright` 追加声明句（零模板机件），每页 footer 可见，构建验证通过。
- README: 署名四要素（TASL）+ 免责声明齐备；neverwin 参考语料登记口径更新为「P1–P4 均无采纳」。

## 2. P4 关键经验（坑位沉淀，接 P3 §2）

1. **上游指令缺空格笔误（`..note::`）同属 DR-005 处置族**：migration_010_100.rst:139 的 `..note::`（缺空格不被解析为指令）被抽取为文本段 msgid，逐字镜像 msgstr、渲染与英文页一致，登记于批次报告；后续同类笔误照此办理，勿再争论。
2. **role 残片与纯文本笔误处置分流**：role/标记残片（`c:func:`、`..note::`）逐字镜像；纯文本拼写笔误（"IPv4 and IPv6 APIS"、"a full list strings"）按语义正常翻译并登记即可。
3. **msgfmt -c 不支持多文件并跑**（多 catalog 并成单一文件报重复 header 假错）——多文件校验必须逐文件运行。
4. **sweep 双解析器交叉验证方法论**：两套独立实现（事件驱动解析 vs 空行分块+非贪婪正则）逐条对账一致后才下结论；gettext `msgcat` 对冲突条目静默合并，只能作旁证不可作判定。
5. **站点可见位置声明落在 conf overlay 的 copyright 追加**：Furo 无 footer 文案配置项，模板机件为零；`gen_workdir.sh` 是唯一事实来源（workdir 幂等重建），改 overlay 后须 `rm -rf workdir && gen_workdir.sh` 重生成（脚本自带 rm，直接重跑即可）。
6. 全量 stat 门禁（untranslated=0）在 43 po 全译后自然通过，无需任何豁免——门禁链设计自洽收官。

## 3. 增量同步模式入口（下一阶段，计划 §6）

- **触发**: `upstream-watch.yml` 每周一 cron 查上游 latest release，变更则自动开 issue；v1.0 已发布，DR-004 的「只开 issue 不切基线」锁定范围（初译期 P0–P4）已完成使命，收到 issue 后即可切基线。
- **执行**: 按计划 §6 `scripts/sync_upstream.sh v1.54.0`——**注意该脚本尚未编写**，首个增量会话的第一项工作是编写并演练（独立分支、locale/ 全量快照备份、幂等可重跑；gh api / dist.libuv.org 下载 + 代理回退；重抽 pot → sphinx-intl update → fuzzy 补译 → 门禁 → PR）。
- **预期增量量级**: 上游 2–3 个月一版，多为 API 增补，估数十条新增/变更（以 sync 报告实测为准）；obsolete 条目默认保留（必要时 msgattrib 清理）。
- **资产沿用**: glossary.md（~221 条）、STYLE_GUIDE.md、validate_po.sh 全量门禁、PR CI、Pages 自动发布全部继续沿用，无架构变更。

## 4. 硬性纪律（重申）

- 一切以计划文档为准；改架构/目录/工具链属重大决策（决策矩阵 + 用户确认 + decision_log）。
- fuzzy 硬门禁：任何构建前 fuzzy=0；修订 fuzzy 必须先比对 `#|` 旧原文。
- 只填 msgstr；msgid/位置注释/文件头禁改；`uv_*`/`UV_*`/`SIG*`/errno/文件名/版本号不译；内联标记原样保留（含邻接规则；DR-005 已修正邻接 role 正则）；role/指令残片逐字镜像（DR-005 族）。
- msgid 以 `::` 结尾的条目：译文全角冒号「：」收尾；`msgid "返回"`/`msgid "参数"` 恒等译文处理（STYLE_GUIDE §2）。
- 改 po 用 Edit 工具（先 Read）；网络纪律：gh api 直连优先，失败走代理 http://192.168.33.1:10808 回退一次；提权经 zcode-run；长脚本经 memgate。
- 每批次/每次 sync 一个 squash commit；收尾必更新本文件与 reports/progress.md；里程碑处主动建议开新会话。
