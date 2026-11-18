# P4 批次报告 —— 收尾批次 3 文件（36 条）

- 批次: P4（api、migration_010_100、upgrading）
- 执行: P4 翻译 agent（GLM），2026-11-19
- 范围: 全库最后 36 条未翻译条目；仅填 msgstr，msgid / 位置注释 / 文件头零改动，未运行任何会改动 po 集合的脚本，未 commit。

## 1. 完成统计与自检结果

| 文件 | 填写条目 | msgfmt -c | `#, fuzzy` | check_markup | term_check |
|---|---:|---|---:|---|---|
| api.po | 1 | OK（零错误） | 0 | 0 error / 0 warning | 0 error |
| migration_010_100.po | 33 | OK（零错误） | 0 | 0 error / 0 warning | 0 error |
| upgrading.po | 2 | OK（零错误） | 0 | 0 error / 0 warning | 0 error |
| **合计** | **36** | | | | |

- term_check 汇总行: `3 文件，36 条译文，黑名单 51 词`，`0 error`（uv_*/UV_* 标识符保留校验含在内，逐条对等）。
- check_markup 三文件合计 0 error / **0 warning**（单反引号标识符 `uv_loop_new`、`uv_loop_delete`、`uv_last_error`、`QueueUserWorkItem`、`uv_tcp_bind`、`uv_tcp_bind6`、`uv_read2_start`、`req->ptr`、`uv_fs_readdir` 等均连同反引号整体保留，内容逐字相等，未触发 lits1 warning）。
- 工具备注: `msgfmt -c` 不支持多文件并跑（多文件会被并成单一 catalog，重复文件头报假错），按批次预案改为逐文件运行，结果如上。

## 2. 主控裁决特殊条目落实记录

| 裁决项 | 落实情况 |
|---|---|
| `msgid "..note::"`（上游 migration_010_100.rst:139 笔误，指令缺空格被抽取为文本段） | msgstr 逐字镜像填写 `..note::`（DR-005 同类处置），check_markup 0 error；建议随 P3 的 `c:func:` 残片一并报上游修复 |
| 标题 `libuv 0.10 -> 1.0.0 migration guide` | 译作「libuv 0.10 → 1.0.0 迁移指南」，ASCII 箭头转「→」（对齐 STYLE_GUIDE §3.8 `---`→「——」先例），msgid 未动 |
| upgrading.po `Upgrading` | 译「升级」（页面标题不增不减，未写成「升级指南」） |
| `Migration guides for different libuv versions, starting with 1.0.` | 译「适用于不同 libuv 版本的迁移指南，自 1.0 起。」 |
| api.po `API documentation` | 译「API 文档」 |
| `Streams / UDP  data receive callback API change` | 译「Stream / UDP 数据接收回调 API 变更」；msgid 内 "UDP" 后双空格系上游原文，未镜像；正文 "The streams and UDP data receive callbacks" 译「Stream 与 UDP 数据接收回调」（stream 作类型名保留英文） |
| 上游纯文本笔误 "IPv4 and IPv6 APIS"（rst:112）、"a full list strings"（rst:241） | 按语义正常译为「API」「完整的字符串列表」，不做逐字镜像，本行登记 |
| `*dents*`（scandir(3) 目录项行话） | 保留 `*dents*` 原样不译（italic 星号对数与 msgid 对等） |
| "by value" | 按「按值传递」语域处理：rst:90 译「按值返回」、rst:115 译「按值接收」、rst:147 译「按值传递的结构体」（与 misc.po:245「返回的结构体按值传递」先例一致） |
| "see :c:ref:`threadpool`" | 译「参见 :c:ref:`threadpool`。」（对齐 loop.po「参见」先例） |
| "roundtrip to the threadpool" | 按 glossary threadpool→线程池 术语译「向线程池做一次往返」 |

另有小项: 代码块标签 `libuv 0.10` / `libuv 1.0`（rst:20/28 等 4+4 处位置注释合并条目）版本号原样保留；`:c:func:` / `:c:type:` / `:c:ref:` role 与双反引号字面量（``struct sockaddr_in``、``struct sockaddr_in6``、``struct sockaddr*``、``UV_THREADPOOL_SIZE``、``scandir(3)`` ×2）逐字保留。

## 3. 新术语提议（供收尾裁决入库）

| 英文 | 建议译名 | 理由 |
|---|---|---|
| by value | 按值传递（语域；按动词搭配作「按值返回 / 按值接收」） | misc.po 已有「按值传递」先例，本批 3 处复用，宜冻结 |
| roundtrip | 往返 | 线程池往返语境（"make a roundtrip to the threadpool"），中文技术文档惯用「往返」 |
| deprecated | 弃用（「已弃用」） | 本批 rst:17 出现；全库首次，通行译名 |
| libuv internals | （libuv 的）内部结构 | rst:224 "accessed the libuv internals"；与 loop.po「内部循环资源」不冲突，指内部数据结构 |
| duality | 之分（"no longer a … duality" → 「不再有 … 之分」） | 个案句式，可不冻结，仅备案 |

预计影响面小：均为低频词，是否入库由主控定夺。

## 4. 存疑条目与处理方式

| 位置 | 问题 | 处理 |
|---|---|---|
| migration_010_100.po rst:115 | ``struct sockaddr*`` 后紧跟 "(note it's a pointer)"，若直接换全角「（」会触发邻接规则（结束标记后不得紧跟全角开括号） | 按 STYLE_GUIDE §2 修法在 ``…`` 与「（」之间补一个半角空格（``struct sockaddr*`` （注意它是一个指针）） |
| rst:190 "which could also result in the reception of handles over it" | which/it 双指代（指读取行为/该管道） | 译「这也可能导致经由该管道接收句柄」，指代显式化 |
| rst:190 "The callback for such function looked like this:" | 句尾单 `:` 引导 literal block | 译「该函数的回调形如：」，按全角冒号收尾规则处理 |
| rst:224 "for example" 后置修饰 | 直译挂句尾生硬 | 初译「以便获取例如 TCP 句柄的文件描述符」，主控终态润色为「以获取文件描述符（例如 TCP 句柄的）」，语义等价 |
| rst:231 "This is now properly exposed" | This 指代上句的文件描述符获取方式 | 译「现在，这已通过 :c:func:`uv_fileno` 函数以规范的方式对外提供」，保留指代不加词 |
| rst:15 "those are deprecated" | those 指代两个函数 | 译「这两个函数均已弃用」，指代显式化 |
| msgfmt 多文件并跑报「重复的消息定义」 | 工具行为而非文件缺陷（多 catalog 合并） | 逐文件运行，全部通过 |

## 5. neverwin 旧译文采纳

**无**。36 条全部为本批原创翻译，README 署名段无需更新（计划 §9，与 P2/P3 批次口径一致）。

## 6. 收尾状态

- 本批完成后 locale/zh_CN 全部 .po 无空译文（各文件仅存文件头 `msgstr ""`，属正常）；api.po / upgrading.po / migration_010_100.po 达到与 P1–P3 各文件相同的门禁标准。
- 待主控执行: validate_po.sh 全量门禁复核、术语裁决入库（§3 提议 5 项）、构建告警基线比对、commit（本 agent 未做任何 git 操作）。

## 7. 全库一致性 sweep（P4 终检）

- 执行: P4 全库术语一致性 sweep agent（GLM），2026-11-19；分析脚本位于 `/tmp/p4-sweep/`（未入仓库），经 `memgate python3 -I` 运行。**本次 sweep 对全部 po 零修改**（无一处需要改写）。

### 7.1 S1 同 msgid 跨文件对齐（先入库者为准）

- 方法: 纯 stdlib 脚本解析全部 43 个 .po（正确处理多行续行、跳过文件头与 `#~` obsolete 条目；全库无 msgid_plural / msgctxt 条目，Plural-Forms 为 nplurals=1），以 msgid 全文为键分组。
- 统计: 1728 条译文 / 1573 唯一 msgid / 跨文件共享 **35 组**，其中 msgstr 不一致组 **0 组**。
- 交叉验证: ① 第二套独立实现解析器（空行分块 + 块内非贪婪正则）逐条对账，msgid 集合与逐条 msgstr 均完全一致；② gettext `msgcat` 合并 43 文件退出码 0（注：合成用例证实 msgcat 对冲突重复条目静默合并，故仅作旁证，结论以自研双解析器为准）。
- **改写条数: 0**；**登记未改（交主控裁决）条目: 0**（不存在跨文件不一致组，无需触发批次优先序 / 多数派判定）。
- fs.po 类内部分歧复查（P3 先例）: fs.po 两处 `:c:type:`uv_req_t` …` 条目均为「也同样适用」（含「也」），全库 grep 无缺「也」变体，**无回潮**。

### 7.2 S2 「信道」残留检查

- `grep -rn '信道' locale/zh_CN/LC_MESSAGES/`（含 guide/ 子目录）: **0 处残留**，P3 的「通道」统一维持清零状态，无需修复。

### 7.3 S3 glossary 黑名单全量复扫

- `memgate python3 scripts/term_check.py`（全量模式）: `43 文件，1728 条译文，黑名单 51 词`，**0 error**（含 uv_*/UV_*/SIG* 标识符保留逐条对等校验），无需修复。

### 7.4 S4 P4 新译 36 条终检（api 1 / migration_010_100 33 / upgrading 2）

- 逐条人工对照 glossary §2/§2.1/§2.2 术语、§4 不译清单与 STYLE_GUIDE 复核，**全部合规，0 修复，0 存疑**。要点：
  - 版本号与标识符: `0.10`、`1.0.0`、`1.0`、`uv_loop_new`、`uv_loop_delete`、`uv_last_error`、`QueueUserWorkItem`、`UV_THREADPOOL_SIZE`、`uv_tcp_bind(6)`、`uv_read2_start`、`uv_pipe_pending_count/type`、`uv_fileno`、`uv_fs_readdir/scandir/scandir_next`、`req->ptr`、`scandir(3)`、`*dents*` 全部原样保留；`libuv 0.10 -> 1.0.0` 标题箭头「→」沿用 §2 已登记裁决。
  - `..note::` 镜像条目（rst:142）逐字未动（DR-005 同类处置，§2 已登记）。
  - 中英文/数字空格: 全库 msgstr 惯例实测为汉字与数字间统一加半角空格（带空格 309 处 / 不带 0 处），P4 译文「在 1.0.0 的」「从 1.0 开始」与全库一致，非缺陷。
  - 全角标点: 3 文件 msgstr 无半角标点夹于汉字间 / 无汉字后半角句读 / 无行尾空格（grep 实测 0 处）。
  - 术语: loop→事件循环、threadpool→线程池、deprecated→（均已）弃用、by value→按值返回/接收/传递（§2 裁决）、roundtrip→往返、duality→之分，均符合 glossary 或 §3 提议口径。
  - 邻接规则: rst:115 ``struct sockaddr*`` 与全角「（」之间的半角空格维持 §4 已登记修法，未回退。

### 7.5 自检四项结果

| 命令 | 结果 |
|---|---|
| `msgfmt -c`（逐文件跑全部 43 po） | 全部零错误 |
| `python3 scripts/check_markup.py`（全量） | **0 error** / 16 warning（均为 design/fs/guide/index/misc/poll 等 P1–P2 已发布文件的「单反引号默认 role 可译文本 / 参数顺序」提示级既有基线，与 P4 三文件无关，P4 三文件保持 0 error / 0 warning） |
| `python3 scripts/term_check.py`（全量） | **0 error**（43 文件 / 1728 条 / 黑名单 51 词） |
| `grep -rc '^#, fuzzy'` 全库合计 | **0** |

### 7.6 sweep 结论

全库一致性 sweep **零缺陷通过**：S1–S4 四项均无需改写任何 po 条目，翻译资产已达 v1.0 发布一致性标准。后续仅待主控执行 §6 所列收尾动作（validate_po.sh 全量门禁、术语裁决入库、commit），本 sweep 未做任何 git 操作。

## 8. 主控终态（2026-11-19，主控会话）

### 8.1 sphinx.po 界面串裁决：不译入，保持 0 条占位

- 现状: sphinx.po 为 P0 手工建立的占位文件（0 条目），文件头注明「Sphinx 内置 zh_CN 界面翻译已自动生效」。
- 实测复核: workdir 构建产物（workdir/docs/build/html/index.html）含「搜索」等本地化界面串，证实 Sphinx 内置 zh_CN 界面翻译在 language=zh_CN 下确已生效。
- 裁决: **不译入**。覆盖式翻译需将 msgid 与所 pin Sphinx 版本（7.0.1）的 sphinx.pot 逐条对齐并随 Sphinx 升级同步维护，收益为零（内置翻译已覆盖全部界面串）、维护成本为正。属轻量决策（局部实现细节），已按协作约定在回复中说明并执行；未来仅在发现内置译文错误/缺漏时按需增补个别条目。

### 8.2 术语裁决入库（glossary §2.3，P4 批次 4 条）

by value→按值传递、roundtrip→往返、deprecated→弃用、internals→内部结构 已冻结入库（glossary.md §2.3）；duality 仅备案不冻结（§3 提议 5 项中采纳 4 项）。

### 8.3 主控润色 1 条

migration_010_100.po rst:224 条「以便获取例如 TCP 句柄的文件描述符」→「以获取文件描述符（例如 TCP 句柄的）」（§4 该行已同步更新）。

### 8.4 全量门禁结果（validate_po.sh 全量模式，2026-11-19，memgate 包裹）

**门禁全绿**——项目史上首次全量 stat 门禁通过：

| 门禁项 | 结果 |
|---|---|
| msgfmt -c（43 po） | 全部零错误 |
| fuzzy 硬门禁 | 全库 0 |
| check_markup | 43 文件 **0 error** / 16 warning（P1–P2 已发布文件既有提示级基线，与 P4 无关） |
| term_check | 43 文件 / 1728 条 / 黑名单 51 词，**0 error** |
| sphinx-intl stat | **全部 43 文件 translated，0 fuzzy，0 untranslated（1728/1728）**——untranslated 首次清零 |
| 构建冒烟 | 成功；error 2 = 基线 2、warning 9 = 基线 9（**零增量**） |

### 8.5 进度看板

`scripts/po_stats.sh` 已重跑，reports/progress.md 更新为 **1728 / 1728（100%）**，P1（509）/ P2（799）/ P3（384）/ P4（36）批次完成度对齐计划 §7。

### 8.6 v1.0 发布复核（README 署名 / 免责声明 / 站点 footer）

- README: 署名四要素（TASL）与免责声明齐备；参考语料登记行口径更新为「P1–P4 现状：均无采纳」（四个批次报告核实一致）。
- **站点 footer 缺口发现与补齐**：v1.0 复核发现站点仅侧栏标题含（中文翻译）、footer 只有上游版权行，缺计划 §9 要求的「站点可见位置」非官方声明。补齐方式：gen_workdir.sh overlay 追加 `copyright = copyright + '｜本项目为社区中文翻译（libuv-zh-docs），非 libuv 官方项目；如与官方英文文档有出入，以官方为准；译文问题请提 GitHub issue。'`（Furo 无 footer 文案配置项，零模板机件；gen_workdir.sh 为唯一事实来源）。重建 workdir + 构建实测：每页 footer 渲染该声明，构建 error/warning 与基线持平。
- 补齐后 validate_po.sh 全量门禁重跑仍全绿（error 2=基线 2、warning 9=基线 9）。
