# P2 批次报告（核心 API 19 文件，799 条）

> 日期: 2026-11-18 ｜ 分支: p2-core-api ｜ 基线: v1.53.0（DR-004）
> 翻译引擎: zcode agent（GLM），19 文件 = 6 个翻译 agent 任务（3 波 × 并行 2；errors.po 优先；misc 157 / fs 138 单 agent 全量直翻，逐批写回防中断），全程仅填 msgstr。

## 1. 完成情况

| 文件 | msgid | 翻译 | 自检 | 备注 |
|---|---:|---|---|---|
| errors.po | 93 | 93 | ✅ | 优先翻译；66 条 UV_E* 描述逐条对齐 glossary §3 |
| version.po | 12 | 12 | ✅ | `semantic versioning`_ 为命名引用目标整体保留 |
| loop.po | 54 | 54 | ✅ | |
| handle.po | 59 | 59 | ✅ | |
| request.po | 26 | 26 | ✅ | |
| timer.po | 24 | 24 | ✅ | rearm 裁决为「重新装载」 |
| prepare.po | 16 | 16 | ✅ | |
| check.po | 16 | 16 | ✅ | |
| idle.po | 18 | 18 | ✅ | |
| async.po | 21 | 21 | ✅ | seq_cst/内存栅栏术语按 C++ 内存模型通行译名 |
| poll.po | 37 | 37 | ✅ | |
| signal.po | 29 | 29 | ✅ | |
| fs.po | 138 | 138 | ✅ | P2 第二大文件 |
| fs_event.po | 28 | 28 | ✅ | |
| fs_poll.po | 19 | 19 | ✅ | |
| dns.po | 28 | 28 | ✅ | ai_flags/hints/node/service 参数名保留 |
| dll.po | 11 | 11 | ✅ | |
| metrics.po | 13 | 13 | ✅ | |
| misc.po | 157 | 157 | ✅ | P2 最大文件，11 批增量写回 |
| **合计** | **799** | **799** | | 完成度 1308/1728（75%） |

机器门禁终态: msgfmt -c 全过 / fuzzy=0 / check_markup 19 文件 0 error / term_check 0 error（黑名单扩至 50 词后全量复扫含 P1 亦 0 error）/ 批次模式 validate_po.sh exit=0 / 中文构建 error 2=基线 2、warning 9=基线 9（零增量）。

## 2. 二轮校对（A 组 misc+fs 抽检 40 条 + 全量快扫；B 组其余 17 文件 100% 通读 504 条）

- **A 组**（reports/P2-proof-A-report.md）：misc 22 + fs 18 条正式抽检逐句比对，零漏译零增译；邻接规则人眼复核 0 处；两文件零修改。
- **B 组**（reports/P2-proof-B-report.md）：17 文件全量通读并修复 **37 处**——普通词误译 3（node/service/Instead）、术语统一 2（事件提供程序、联合体）、跨文件一致性 32（标题分隔符 `---`→「——」×6、also-apply 句式 ×10、初始化句式 ×6、i/o→I/O ×3、FS Event 大小写 ×2、同 msgid 异译统一 ×2 等）；errors.po 93 条全查，66 条 UV_E* 描述与 glossary §3 逐条一致。
- **校对后主控统一回修 10 处**（终态族谱裁决）：null/NUL/zero-terminated 家族统一为「以空字符结尾 / 空终止符 / 空终止字节」（errors ×2、misc ×8），rearm「装填」→「装载」（timer ×1）；同一 msgid 在 misc/fs_event 异译已对齐。
- check_markup 终态 warning：misc 7 / fs 2 / poll 1，均为「单反引号串出现次序」提示（中文语序所致，内容逐字相等）或 checker 已知误报（poll.po #24，msgid 中 `UV_E*` 的 `*` 与斜体 `*may*` 交叠，结构性不可消除）。

## 3. 术语裁决（P2 新增入库 81 条，详见 glossary.md §2.1；§4 +6、§5.1 +10）

- §2.1 新增 81 条：指标、事件处理器、事件提供程序、空闲时间、采样式性能分析器、后端（含后端文件描述符）、轮询超时、空闲链表、分配池、内存块、经验法则、未定义行为、强制转换、联合体、基础句柄、共享库、动态库、候选发布版、开发快照、传输端点、协议驱动程序、查找（seek）、以空字符结尾/空终止符/空终止字节（家族统一）、进程标题、常驻集大小、运行时间、负载均值、CPU 亲和性掩码、并行度、接口标识符、IPv6 作用域地址、分配器、高分辨率时间戳、时钟源、实时时钟、单调时钟、UNIX 纪元、时钟漂移、熵、短读、已提权的用户、优先级类、调度优先级、有效/真实 uid、主目录/临时目录、手册页、C 运行时、独占锁、元数据、追加模式、文件缓存、边缘情况、回退、纳秒精度、亚秒精度、目录流、目录项、联接点、写时复制的 reflink、控制终端、盘符、卷管理器、空操作、一次性的、重新装载、时间片超限、到期值、顺序一致性、合并（coalesce）、栅栏/内存栅栏、循环线程、电平触发、带外消息、忙循环、信号处理、递送、原始模式、控制台模拟器、控制台窗口等。
- §4 不译清单 +6: tick（事件循环语境）、CSPRNG、async-signal-safe、sysfs、ramdisk、reflink、WTF-8、NUL、Y2K38、Unicies。
- §5.1 黑名单 +10: 事件提供者、重新装填、null 终止符、NUL 终止符、以 null 结尾、以零结尾、null 字节。
- STYLE_GUIDE §3 新增第 8 条（标题分隔符「——」/公开成员/I/O/versionchanged 体例，P2 裁决）。
- P3 复用预置: 控制终端、原始模式、带外消息、递送、电平触发（tty/tcp/process 批次直接沿用）。

## 4. neverwin 语料采纳登记

**无采纳**（799 条全部新译），README 署名段无需更新。

## 5. 工作流发现与上游疑似笔误（不改原文，供上游 issue 参考）

| 位置 | 问题 | 处理 |
|---|---|---|
| `msgid "返回"` 工件（misc/async/prepare/check/idle 等，含 P3 的 tcp/udp） | overlay 固化 `language=zh_CN` 使 Sphinx `:returns:` 字段标签在 gettext 抽取时被本地化进 msgid（位置注释无行号） | 恒等译文「返回」，无害；P4 前可评估抽取时改用英文 locale 复抽（属工作流优化，非本批范围） |
| errors.rst:8 | "an API functions returns" 疑似笔误 | 按语义译 |
| errors.rst:220/252 | machine 与 host 语境区分、长句拗口 | machine→机器（避免与 host→主机混淆） |
| misc.rst:617 | uv_os_get_group 段 "provided uid"（参数实为 gid） | 忠实原文，登记待上游确认 |
| misc.rst:448/452 | "an IPv4/IPv6 addresses" 单复数笔误 | 按单数语义译 |
| misc.rst:878–885 | 熵来源链接 `` `RtlGenRandom <url>_` `` 反引号错位（rst 语法疑似错误） | 标记逐字保留 |
| fs.rst:448 | "precission" 拼写错误 | 按正确含义译「亚秒精度」 |
| signal.rst:32–34 | `` `SIGKILL.` `` 句号误入 code span | 原样保留，译文不追加句号 |
| handle.rst:277 | `and` 被上游标为单反引号字面量 | 原样保留，待上游确认 |
| versionchanged 片段句号体例 | errors.po "函数声明为公开。" 等指令参数片段独立成条 | 按独立短句翻译，体例已入 STYLE_GUIDE §3.8 |

## 6. 遗留与下批提示

- poll.po #24 warning 为 checker 正则误报（结构性），P4 sweep 时可考虑修 check_markup.py（属门禁工具变更，另行决策）。
- misc/fs 的 7+2 条语序 warning 均为良性；若 P3 出现同 msgid 异译，以先入库者为准（validate_po 不查跨文件同 msgid 一致性，P4 sweep 加查）。
- P3 入口: 8 文件 384 条（udp 95 / tcp 58 / stream 56 / threading 48 / pipe 39 / process 38 / tty 31 / threadpool 19），tty/process 直接复用 P2 预置术语。
