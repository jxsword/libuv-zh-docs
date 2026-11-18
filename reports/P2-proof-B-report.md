# P2 校对报告（B 组）：errors / version / dll / metrics / loop / handle / request / timer / prepare / check / idle / async / poll / signal / fs_event / fs_poll / dns

> 校对 agent: P2-proof-B｜日期: 2026-11-18
> 对象: `locale/zh_CN/LC_MESSAGES/` 下 17 个 po 文件（504 条任务 msgid，实测 521 条含 header 与 "返回" 工件）
> 规范依据: `STYLE_GUIDE.md`、`glossary.md`（含 §3 错误描述惯用译法）、`upstream/v1.53.0/docs/src/` 对应 rst
> 边界: 仅改 msgstr；msgid / 位置注释 / 文件头零改动；未做任何 git 操作；未触碰 misc.po / fs.po

## 1. 校对方法与覆盖面

- **逐条对照**：17 个文件全部 msgstr 逐条对照上游 rst 校读（语义等价、术语、标记、文风），
  远超「≥50 条」抽检要求，实际抽检比例 100%（errors 93 / loop 54 / handle 59 / poll 37 / dns 28 / fs_event 28 / async 21 / signal 29 / fs_poll 19 / timer 24 / request 26 / idle 18 / prepare 16 / check 16 / version 12 / dll 11 / metrics 13）。
- **errors.po 全查**：93 条全部核对，其中 66 条 `UV_E*` 错误描述逐条比对 glossary §3 惯用译法，
  全部一致（权限不足 / 地址已被占用 / 对端重置了连接 / 文件描述符无效 / 操作已取消 / 不允许的操作 / 打开的文件过多 / 无此文件或目录 / 系统调用被中断 / 连接超时 / 网络已断开 / 网络不可达 / 文件结束 / 目录非空 / 结果过大 / 值超出数据类型范围 等），无一命中 §5 黑名单。
- **全量快扫**：脚本扫描 17 文件 msgstr —— 繁体专用字（简繁同形字排除后）0、直引号仅出现在
  `` `"pipe"` ``/`` `"connect"` `` 反引号字面量内（与 msgid 逐字一致，合法）、「」0、行尾空格 0、
  CJK 间半角逗号/句号 0、msgstr 半角标点收尾 0、黑名单 0（term_check 全绿）。
- **跨文件一致性**：句柄类型名（Timer/Prepare/Check/Idle/Async/Poll/Signal/FS Event/FS Poll 句柄）、
  "Public members"→公开成员（17 文件全一致）、"N/A"→无、seealso 句式、初始化/启动句式、
  标题分隔符、联合/联合体、事件提供者/事件提供程序 逐项 grep 对齐。
- **邻接规则人工复核**：机器 0 error；人眼复查全部内联标记边缘情形
  （`` `"connect"` （即… `` 反引号后有空格再接全角开括号，不触发 openers 规则，合法）、
  `**不**`/`*任意事件循环*`/`*不会*`/`*可能*` 两侧均为空白或全角标点，全部合规。

## 2. 抽检条目清单（关键样例，全量结论见 §4 终态表）

| 文件 | 条目（rst 行 / msgid） | 结论 |
|---|---|---|
| errors.po | §3 全部 66 条 UV_E* 描述 | 与 glossary §3 逐条一致 |
| errors.po | rst:7 负数常量导语 / rst:15 实现细节 note | 语义完整，`errno`/`-errno` 反引号保留 |
| errors.po | rst:351 UV_ERRNO_MAP / rst:358–375 四个 API | `iter_macro`/`UV_`/`buf`/`buflen` 标记完整，错误信息→错误信息（§2 术语）|
| loop.po | rst:122–133 UV_RUN_DEFAULT/ONCE/NOWAIT | 三条返回值语义逐句等价 |
| loop.po | rst:209–216 uv_loop_fork 长段 | 无漏译；父子进程条件句完整 |
| loop.po | rst:232/241 FS event 句柄两条 caution | *for any event loop*/*not* 斜体保留；大小写一致性见修复 #4/#5 |
| handle.po | rst:57 uv_alloc_cb 五段长文 | base 字段名保留英文正确；slab/空闲链表符合不译清单 |
| handle.po | rst:117–131 uv_is_active 四要点 + 经验法则 | "active" 弯引号合规；uv_foo_t 标记完整 |
| handle.po | rst:277 引用计数（`` `and` `` 工件） | 反引号 `and` 原样保留（上游原文即带反引号）|
| handle/request | rst:193–223 发送/接收缓冲区两函数 | `*value` 标记对等；Linux 双倍 note 语义正确 |
| request.po | rst:70–99 uv_cancel 全段 | **not** 加粗保留；req->result/status==`UV_ECANCELED` 逐字保留 |
| timer.po | rst:9–15 重复定时器语义段 | 50 ms/17 ms/33 ms 数字与单位空格合规；"重新装填"（rearm）见存疑项 §5 |
| prepare/check/idle | 全文件（16/16/18 条） | :returns: 工件（"返回"、"0"、"0 on success…"）处理正确 |
| async.po | rst:12–27 seq_cst 两个 note + versionchanged | 顺序一致/内存栅栏术语准确；URL 逐字保留 |
| poll.po | rst:100 uv_poll_start 错误段 | *may*/\*\*not\*\* 保留；UV_E* 语义正确（warning 为 checker 误报，见 §5）|
| poll.po | rst:117–133 level triggering 五要点 | 五种情形逐条对应，"电平触发"准确 |
| signal.po | rst:12–52 Windows/Unix notes 全部 | SIG* 全部不译；"递送/引发/捕获"动词准确 |
| fs_event.po | rst:7–22 AIX/z/OS 限制段 | spawn→派生（§2）；folder→目录（§2 禁用"文件夹"规避正确）|
| fs_poll.po | rst:24 uv_fs_poll_cb 长段 | status<0 条件句语义等价 |
| dns.po | rst:74–105 getaddrinfo/getnameinfo | node/service 为函数参数名保留英文正确；**synchronously** 加粗保留 |
| version/dll/metrics | 全部条目 | 语义/标记/术语全过，无修改 |

已知工件复核（按任务说明不计缺陷）：`msgid "返回"` 4 处（async/prepare/check/idle）均译 "返回"，
恒等正确；errors.po `ai_flags`/`ai_family`/`hints` 保留英文符合不译清单。

## 3. 修复清单（14 文件 37 处，全部仅动 msgstr）

| # | 文件:行 | 修改前 → 修改后 | 原因 |
|---|---|---|---|
| 1 | errors.po:110 | 未知的 node 或 service → 未知的节点或服务 | 文风细则 5：错误描述中的普通词应翻译，不中英混杂（node/service 非 C 标识符）|
| 2 | errors.po:122 | service 对该套接字类型不可用 → 服务对该套接字类型不可用 | 同上（dns.po 中 node/service 为 uv_getaddrinfo 参数名，保留英文不变）|
| 3 | loop.po:107 | 事件提供者 → 事件提供程序 | 与 metrics.po（4 处）统一术语 |
| 4 | loop.po:319 | 相反，…FS event 句柄×2 → 取而代之的是，…FS Event 句柄×2 | "Instead" 为替代关系而非转折，"相反" 属轻度误译；句柄名与 fs_event.po 统一 |
| 5 | loop.po:327 | FS event 句柄 → FS Event 句柄 | 与 fs_event.po/fs_poll.po 句柄名统一 |
| 6 | handle.po:59 | 所有句柄类型的联合 → 联合体 | 与 request.po 统一（联合体为更通行译名）|
| 7 | request.po:26 | `--- 基础请求` → `—— 基础请求` | 标题分隔符与 loop/handle/poll 等 6 文件统一为中文破折号 |
| 8 | request.po:37 | 存放…不会使用该字段 → 用于存放…不使用此字段 | 与 handle.po 同一 msgid 的译法统一 |
| 9 | timer.po:26 | `--- Timer 句柄` → `—— Timer 句柄` | 同 #7 |
| 10 | timer.po:89 | 初始化该句柄。→ 初始化句柄。 | 初始化句式与 signal/fs_event/fs_poll 统一 |
| 11 | prepare.po:26 | `--- Prepare 句柄` → `—— Prepare 句柄` | 同 #7 |
| 12 | prepare.po:33 | 轮询 i/o 之前 → 轮询 I/O 之前 | I/O 大小写与 loop/handle/timer 统一 |
| 13 | prepare.po:65 | 初始化该句柄。→ 初始化句柄。 | 同 #10 |
| 14 | prepare.po:79 | 启动该句柄 → 启动句柄 | 启动句式与 signal/fs_event 统一 |
| 15 | check.po:26 | `--- Check 句柄` → `—— Check 句柄` | 同 #7 |
| 16 | check.po:32 | 轮询 i/o 之后 → 轮询 I/O 之后 | 同 #12 |
| 17 | check.po:64 | 初始化该句柄。→ 初始化句柄。 | 同 #10 |
| 18 | check.po:78 | 启动该句柄 → 启动句柄 | 同 #14 |
| 19 | idle.po:26 | `--- Idle 句柄` → `—— Idle 句柄` | 同 #7 |
| 20 | idle.po:43 | 阻塞等待 i/o → 阻塞等待 I/O | 同 #12 |
| 21 | idle.po:83 | 初始化该句柄。→ 初始化句柄。 | 同 #10 |
| 22 | idle.po:97 | 启动该句柄 → 启动句柄 | 同 #14 |
| 23 | async.po:26 | `--- Async 句柄` → `—— Async 句柄` | 同 #7 |
| 24 | async.po:102 | 初始化该句柄。→ 初始化句柄。 | 同 #10 |
| 25–26 | poll.po:103/231 | 同样适用 → 也同样适用 ×2 | seealso 句式与 timer/prepare/check/idle/async 统一 |
| 27–28 | signal.po:144/170 | 同样适用 → 也同样适用 ×2 | 同 #25 |
| 29–30 | fs_event.po:113/170 | 同样适用 → 也同样适用 ×2 | 同 #25 |
| 31 | fs_poll.po:57 | 如果 `path` 不存在或不可访问，回调会以 `status < 0` 被调用 → 回调会以 `status < 0` 被调用，此时 `path` 不存在或不可访问 | 消除单反引号 token 顺序 warning #6；语义等价（此时 = 条件关系），语序自然 |
| 32 | fs_poll.po:76 | 同样适用 → 也同样适用 | 同 #25 |
| 33 | fs_poll.po:88 | 每隔 `interval` 毫秒检查 `path` 处的文件是否有变化 → 检查 `path` 处的文件是否有变化，间隔为 `interval` 毫秒 | 消除单反引号 token 顺序 warning #13；语义等价（every X ms = 间隔为 X 毫秒）|
| 34 | fs_poll.po:123 | 同样适用 → 也同样适用 | 同 #25 |
| 35–36 | dns.po:94/156 | 同样适用 → 也同样适用 ×2（uv_req_t seealso）| 同 #25 |

说明：#31/#33 修复后 fs_poll.po 的 2 条 warning 归零，17 文件 warning 总数恰为任务给定基线
「共 1 条（poll.po）」。

## 4. 17 文件终态自检汇总

| 文件 | msgfmt -c | check_markup error | check_markup warning | term_check error | fuzzy | 修改处数 |
|---|---|---|---|---|---|---|
| errors | OK | 0 | 0 | 0 | 0 | 2 |
| version | OK | 0 | 0 | 0 | 0 | 0 |
| dll | OK | 0 | 0 | 0 | 0 | 0 |
| metrics | OK | 0 | 0 | 0 | 0 | 0 |
| loop | OK | 0 | 0 | 0 | 0 | 3 |
| handle | OK | 0 | 0 | 0 | 0 | 1 |
| request | OK | 0 | 0 | 0 | 0 | 2 |
| timer | OK | 0 | 0 | 0 | 0 | 2 |
| prepare | OK | 0 | 0 | 0 | 0 | 4 |
| check | OK | 0 | 0 | 0 | 0 | 4 |
| idle | OK | 0 | 0 | 0 | 0 | 4 |
| async | OK | 0 | 0 | 0 | 0 | 2 |
| poll | OK | 0 | **1** | 0 | 0 | 2 |
| signal | OK | 0 | 0 | 0 | 0 | 2 |
| fs_event | OK | 0 | 0 | 0 | 0 | 2 |
| fs_poll | OK | 0 | 0 | 0 | 0 | 4 |
| dns | OK | 0 | 0 | 0 | 0 | 2 |

- msgid 计数修复前后逐文件一致（94/13/12/14/55/60/27/25/17/17/19/22/38/30/29/20/29），未触碰 msgid。
- warning 总计 1 条 = 任务给定基线（poll.po #24）；fs_poll 由 2 条降为 0 条。
- 残留复扫：无 "---" 标题、无未加"也"的"同样适用"、无小写 i/o（msgstr 内）、无"事件提供者"。

## 5. 未修复的存疑项

| # | 位置 | 内容 | 原因与建议 |
|---|---|---|---|
| 1 | poll.po #24（基线 warning）| check_markup 单反引号内容不一致 | checker 正则误报：msgid 中 `UV_E*` 的 `*` 与斜体 `*may*` 交叠，使假想单反引号 span 吞入整段英文散文，任何中文译文的提取结果都不可能与该英文串相等，属结构性不可消除误报。建议后续在 check_markup.py 中先于 ital 提取 lits1 或给 `UV_E*` 类 pattern 加保护。译文本身（`UV_E*` 错误码之一、*可能*、\*\*不\*\*）经人工核对正确，保留原样。|
| 2 | timer.po #3（rst:9）| "rearmed" → "重新装填" | rearm 为定时器重设触发的行话，"重新装填" 可解但偏军事隐喻；备选"重新装载/重新设定"。语义无损失，属措辞偏好，未改。建议术语裁决时考虑收录。|
| 3 | loop.po #33（rst:178）| "you will only get disappointed" → "你只会失望" | 原文即口语化调侃，译文如实保留语气，符合不增不减；若后续整体定调偏正式可再议。|
| 4 | errors.po:246 | "machine is not on the network" → "机器不在网络上" | "机器" 直译可行，"主机" 更常见；因 ENONET 属低频条目且现译无歧义，未改。|
| 5 | loop.po #50 vs fs_event.po 句柄名 | 上游自身混用 "FS event handles"(loop.rst) 与 "FS Event handle"(fs_event.rst) | 已统一为 "FS Event 句柄"；若术语裁决倾向 glossary §4 的小写形式 "fs_event 句柄"，需全库 sweep（含 guide/design 等 B 组外文件），本轮不越界执行。|
| 6 | handle.po/request.po/errors.po | UV_*_TYPE_MAP 宏描述三文件句式各异（"展开后会对…生成的宏" / "该宏会针对…展开为" / "该宏会针对…展开为"）| 三种译法均正确，仅措辞不同；handle/request 两文件句式差异属可接受范围，避免不必要 churn，未强行统一。后续可在术语裁决中定一个模板句。|

## 6. 结语

- 语义等价：17 文件全量逐条核对，未发现漏译半句、增译或关键术语误译（仅 #4 一处连接词轻度误译，已修）。
- 术语：UV_E* 描述与 glossary §3 逐条一致；§5 黑名单零命中；句柄类型名、"公开成员"、"标志"、"监视器"、"派生"、"线程安全"、"空转" 等均合规。
- 标记与排版：role/字面量/URL/加粗/斜体全部对等，邻接规则零 error，弯引号与全角标点合规，无行尾空格。
- 门禁终态：msgfmt 全过、markup 0 error / 1 warning（= 基线误报）、term 0 error、fuzzy 0，达到验收标准。
