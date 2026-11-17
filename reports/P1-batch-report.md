# P1 批次报告（入门 12 文件，中文站首发）

> 日期: 2026-11-18 ｜ 分支: p1-intro ｜ 基线: v1.53.0（DR-004）
> 翻译引擎: zcode agent（GLM），12 文件 = 12 个 agent 任务（不同 po 并行 2 个，受会话并发上限约束；小文件串行合并处理），全程仅填 msgstr。

## 1. 完成情况

| 文件 | msgid | 翻译 | 自检 | 备注 |
|---|---:|---|---|---|
| index.po | 22 | 22 | ✅ | |
| design.po | 58 | 58 | ✅ | |
| guide.po | 2 | 2 | ✅ | |
| guide/about.po | 5 | 5 | ✅ | |
| guide/introduction.po | 16 | 16 | ✅ | |
| guide/basics.po | 41 | 41 | ✅ | |
| guide/eventloops.po | 9 | 9 | ✅ | |
| guide/networking.po | 58 | 58 | ✅ | |
| guide/filesystem.po | 61 | 61 | ✅ | |
| guide/processes.po | 81 | 81 | ✅ | |
| guide/threads.po | 67 | 67 | ✅ | |
| guide/utilities.po | 89 | 89 | ✅ | |
| **合计** | **509** | **509** | | 完成度 509/1728（29%） |

机器门禁终态: msgfmt -c 全过 / fuzzy=0 / check_markup 0 error / term_check 0 error / 批次模式 validate_po.sh exit=0 / 中文构建 warning 回到基线 9 行（0 新增 error）。

## 2. 二轮校对（抽检 ≥10% 实际执行 216 条 = 42%）

两个独立校对 agent：A 组（guide 5 大文件，46 条正式抽检 + docutils 渲染全扫）、B 组（design/networking 全查 + 5 小文件逐条全查，170 条）。**语义/术语层面零漏译零增译零黑名单违规**；发现两类系统性排版缺陷并已全部修复：

- **A 类·内联标记邻接损坏**（16 条目 39 处）：标记紧邻汉字或结束后紧跟全角开括号 → docutils 不识别，星号/反引号变字面量（构建实报 8 处 WARNING、部分静默）。全部按「标记两侧补半角空格」修复（threads.po 既有正确风格），构建告警 26→9（回到基线）。
- **B 类·`::` 结尾条目**：msgid 以 `::`（literal block 引导符）结尾、译文以全角冒号收尾。两个 agent 结论相反，以真实构建一锤定音：**HTML 输出仍为 `<pre>` 代码块、零告警**（sphinx i18n 在 doctree 层替换文本，结构关系不受影响）→ 全库统一全角冒号收尾，**不修改**。规则与依据已写入 STYLE_GUIDE §2。
- **引用一致性**：processes.po #58 触发 Sphinx「译文中的引用与原文不一致」告警，根因同为邻接问题（`pipe(7)`_ 后紧跟全角「（」），修复后消除。
- **文风统一**：sanity check→合理性检查、去重复措辞、引号统一为中文弯引号“”、networking.po 11 处行尾空格移行首。
- **门禁强化**：check_markup.py 新增邻接规则（error 级，39 处全量扫描与人工校对结论一致），STYLE_GUIDE §2 补邻接规则/`::` 定案/引号规范，防 P2–P4 复发。

## 3. 术语裁决（P1 新增入库 48 条，详见 glossary.md §2/§4/§5.1）

core: domain socket→域套接字、named pipe→命名管道、echo server→回显服务器、daemon→守护进程、master/worker process、round-robin→轮转、mutex→互斥锁、read-write lock→读写锁、barrier→屏障、condition variable→条件变量、synchronization primitives→同步原语、thread-local storage→线程局部存储、work queue→工作队列、thread affinity→线程亲和性、scheduler→调度器、signal handler→信号处理函数、CPU bound→CPU 密集型、garbage collector→垃圾回收器、heartbeat→心跳、events mask→事件掩码、interval timer→周期定时器、opaque struct→不透明结构体、long-lived/short-lived→长寿命的/短寿命的、de-initialize→反初始化、call site→调用点、Idling→空转、multicast→组播（禁多播）、datagram→数据报、peer→对端、loopback→环回（禁回环）、TTL→生存时间、high resolution clock→高分辨率时钟、ANSI escape code、pull request→拉取请求、file change notification/event、buffer pool→缓冲区池、evented I/O、poller→轮询器、file I/O primitives、due timer→到期的定时器、ref'd handles→被引用的句柄、loop *alive*→存活、handler→处理函数、fire-and-forget→发后即忘。
不译清单扩充: event ports、IPC、backlog、tee、slab、baton、Hello World。
黑名单新增: 多播、回环、受 CPU 限制、超时的定时器。

## 4. neverwin 语料采纳登记

**无采纳**（全部新译），README 署名段无需更新。

## 5. 上游疑似笔误登记（不改原文，供上游 issue 参考）

| 位置 | 原文 | 问题 |
|---|---|---|
| design.rst:74 | establishes the **content** for all I/O operations | content 疑为 context |
| design.rst:105 | `*alive*  an iteration` | 双空格排版瑕疵 |
| utilities.rst:110 | queue up **and** idle watcher | and 疑为 an |
| utilities.rst:362 | in the second argument in the third argument | 表述混乱 |
| utilities.rst:431 | Obeys string of display settings | 缺冠词 |
| filesystem.rst:258 | write callback **trigged** | trigged 疑为 triggered |
| filesystem.rst:293 | Refer to the `notes of …`_ function | 语法含糊（function 悬空） |
| networking.rst | The second **arguments** is / **packet** time-to-live for multicast packets | 主谓不一致/重复词 |
| threads.rst:281 | ``uv_fs_t.errorno`` | errorno 疑为 errno（``字面量`` 内按门禁原样保留） |
| guide/processes.rst:129 | watcher _after_ the exit callback | _after_ 非合法 rst 标记 |
| threads.rst:20 / processes.rst:171,261,423 | complete agnostic / applications launches / created by settings / stands in for | 语法小疵，均按语义翻译 |

## 6. linkcheck 判定说明（网络纪律对齐）

本机两路均不可判定：直连（DNS 解析失败/网络不可达 17 broken）、代理（出口 502/重置 131 broken）——测的是本机网络而非链接本身，且全部外链源自上游 msgid（上游 CI 在 GitHub 网络下 linkcheck 通过）。**权威判定移至 PR CI**：pr.yml 新增 linkcheck 步骤（GitHub 干净网络），PR 绿灯即为批次验收通过。

## 7. 遗留与移交

- furo 主题个别 UI 词英文（如 Contents）——furo 自身语言包范围，观察项。
- fire-and-forget 等 P1 暂保留英文处已在 glossary 登记，P4 sweep 回改。
- 下一批 P2（核心 API 19 文件 799 条，errors.rst 优先），入口见 docs/handoff-latest.md。
