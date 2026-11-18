# P3 校对报告 B 组（threading + pipe + process + tty + threadpool）

> 校对 agent: P3-proof-B ｜ 日期: 2026-11-19 ｜ 工作目录: `/home/ssy/soft-tech-docs-translate/libuv-zh-docs`
> 对象（仅可改这 5 个文件，共 175 条）: `threading.po`（48）、`pipe.po`（39）、`process.po`（38）、`tty.po`（31）、`threadpool.po`（19）
> 规范依据: `STYLE_GUIDE.md`、`glossary.md`（开工前全文通读）；上游原文 `workdir/docs/src/{threading,pipe,process,tty,threadpool}.rst` 逐条对照；初译存疑清单 `reports/P3-t3-report.md` §4–§5 复核
> 结论: **175 条全量通读精校，修订 10 条（占 5.7%），其余 165 条（94.3%）确认无误**；同 msgid 跨文件对齐修复 3 条（P1/P2 先例为准），A 组 3 文件只读发现 5 条（未动，见 §4）。修订后 5 文件门禁全绿。

## 1. 逐文件统计与修订明细

只改 msgstr；修订后经 `git show HEAD` 对比校验，msgid、位置注释、文件头 5 文件全部逐字未动（脚本比对 PASS）。

### 1.1 threading.po（复核 48 条，修订 2 条）

| 位置 | msgid 片段 | 修订 | 理由 |
|---|---|---|---|
| :186 | "or it will be truncated to fit with the trailing NUL" | 「否则它将被截断以连同结尾的 NUL 一起适配」→「否则名称将被截断以适配缓冲区并保留结尾的 NUL」 | 原译拗口且「它」在中文里易误指缓冲区；「名称」为原文 it 的实际所指（被截断的是线程名），信息点不变 |
| :263 | "Callers should be prepared to deal with spurious wakeups on …" | 「应做好应对……上虚假唤醒的准备」→「应准备好处理……上的虚假唤醒」 | role 插入后原句定语过长、语气生硬；语义等价的自然陈述句 |

其余 46 条确认无误，要点抽查：`---`→「——」、互斥锁/读写锁/信号量/条件变量/屏障数据类型系列、uv_thread_setaffinity/getaffinity 长段逐句比对（cpu_set_t 映射方向、SetThreadAffinityMask 语义）、UV_THREAD_PRIORITY_* 常量串原样、"Thread affinity setting/getting is not atomic" 对偶译法一致、z/OS 绝对时间语义、barrier「即：」引出代码块与 ``…`` 字面量、版本注记无句号短句加句号收尾（对齐 P2 fs.po 先例 "sub-second precission…" → 「……。」）。

### 1.2 pipe.po（复核 39 条，修订 5 条）

| 位置 | msgid 片段 | 修订 | 理由 |
|---|---|---|---|
| :81 | "the file descriptor is set to non-blocking mode." | 「文件描述符**会**被设置为非阻塞模式」→「文件描述符被设置为非阻塞模式」 | **对齐 P1/P2 先例** poll.po:114 同 msgid 译法（§3.2 第 5 条） |
| :56 | "…not the listening pipe that uv_accept is called on"（ipc 成员） | 「而不是调用 uv_accept 的监听管道」→「而不是**对其**调用 uv_accept 的监听管道」 | 原译可误读为「监听管道调用 uv_accept」；补「对其」明确动作方向 |
| :73 | 同句（uv_pipe_init 描述内） | 同上 | 同一英文句在两处出现，保持一致修订 |
| :171 | "the returned length no longer includes the terminating null byte, and the buffer is not null terminated." | 「不再包含空终止字节，且缓冲区不以空字符结尾」→「不再包含**结尾的空终止字节**，且缓冲区**不会以空字节结尾**」 | **对齐 P1/P2 先例** fs_event.po:157 / fs_poll.po:110 同 msgid 译法（§3.2 第 6 条） |
| :198 | "initialize a handle of the given `type`, returned by :c:func:`uv_pipe_pending_type`" | 「（由 …返回）」→「（该 type 由 …返回）」 | 原括注紧跟「句柄」，可误读为句柄由该函数返回；实为 type 由其返回。括注内用不带反引号的 type，避免反引号数量与 msgid 不对等（check_markup warning） |

其余 34 条确认无误，要点抽查：「子类」与 tcp.po/tty.po 逐字一致、bind/bind2/connect/connect2 的 flags 语义与 ``UV_EINVAL`` 字面量、abstract namespace sockets（抽象命名空间套接字）、FreeBSD ``SOCK_MAXADDRLEN``、pending instances 语义、chmod 权限句、uv_pipe 的 fds[0]/fds[1] 读写方向。

### 1.3 process.po（复核 38 条，修订 1 条）

| 位置 | msgid 片段 | 修订 | 理由 |
|---|---|---|---|
| :96 | "See the ``UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS`` flag on :c:enum:`uv_process_flags`." | 「参见 ``…`` 标志（见 :c:enum:…）」→「参见 :c:enum:`uv_process_flags` 中的 ``…`` 标志」 | 原译「参见……（见……）」动词冗余且语序偏离原文；改为与英文同序的一句 |

其余 37 条确认无误，要点抽查：stdio 容器/联合体（glossary union→联合体）、uv_spawn 长段（either way-success or failure-- 的破折号处理、「再次关闭句柄」的 again 语义）、zombie/reap（僵尸进程/回收）、PID 释放后重用语义、"Returns `handle->pid`."（逐字对齐 P2 handle/request.po 的「返回 `…`。」句式）。

### 1.4 tty.po（复核 31 条，修订 1 条）

| 位置 | msgid 片段 | 修订 | 理由 |
|---|---|---|---|
| :169 | "Get the current state of whether console virtual terminal sequences are handled by libuv or the console." | 「获取**当前**控制台虚拟终端序列由……」→「获取控制台虚拟终端序列**当前**由 libuv 还是控制台处理的状态」 | 原译「当前」位置易误作定语修饰「控制台虚拟终端序列」；移至状语位 |

其余 30 条确认无误，要点抽查：TTY 模式枚举引导句、「0 = stdin」三列表项原样、ttyname_r(3) 重开语义、回退阻塞式写入（fallback→回退）、versionchanged 片段（1.23.1/1.9.0/1.5.0/1.2.0）、`UV_EBUSY`/`UV_ENOTSUP` 字面量、ConEmu/ANSI X3.64/Xterm 256 色句、"N/A"→「无」（对齐 tcp.po）。

### 1.5 threadpool.po（复核 19 条，修订 1 条）

| 位置 | msgid 片段 | 修订 | 理由 |
|---|---|---|---|
| :103 | "Loop that started this request and where completion will be reported. Readonly." | 「发起此请求的循环，完成结果也将报告至该循环。只读。」→「发起此请求并在其中报告完成情况的事件循环。只读。」 | **对齐 P1/P2 先例** fs.po:126 同 msgid 译法（§3.2 第 1 条） |

其余 18 条确认无误，要点抽查：UV_THREADPOOL_SIZE 默认 4/上限 1024、三条 versionchanged 片段（128→1024、8 MB 栈、libuv-worker 默认名）、全局线程池预分配段（惰性增长）、"all events loops" 上游笔误按语义归一、uv_after_work_cb 取消分支 ``UV_ECANCELED``。

## 2. 门禁自检（修订后实测，2026-11-19）

```text
msgfmt -c:      threading / pipe / process / tty / threadpool 五文件全部 OK
fuzzy 计数:     五文件均为 0
check_markup:   五文件 0 error / 0 warning（含邻接规则；pipe.po 中途一次
                `单反引号` 数量 warning 已通过去掉括注内多余反引号归零）
term_check:     五文件 0 error（175 条译文，黑名单 50 词）
msgid 完整性:   5 文件对 HEAD 比对，msgid / 位置注释 / 文件头全部逐字一致 PASS
```

## 3. 同 msgid 跨文件对齐检查（重点）

方法：脚本抽取 8 个 P3 po 文件（threading/pipe/process/tty/threadpool/stream/tcp/udp）全部 msgid（346 个唯一值）两两比对；另将本组 5 文件的 msgid 与全库其余 po（P1/P2 已发布文件）比对。规则按任务书：**冲突以 P1/P2 既有译法为准；A/B 之间无 P1/P2 依据的不一致只登记、待主控裁决**。

### 3.1 8 个 P3 文件内部：16 个跨文件共享 msgid，11 个完全一致

一致项（抽验记录）：`API`→「API」（8 文件）、`Data types`→「数据类型」（8 文件）、`Public members`→「公开成员」（7 文件）、`N/A`→「无」、`The :c:type:`uv_stream_t` members also apply.`→「……的成员也同样适用。」、`The :c:type:`uv_stream_t` API functions also apply.`、`The :c:type:`uv_handle_t` members/API functions also apply.`（process/stream/udp 三文件一致）、工件条目 `msgid "返回"`/`msgid "参数"` →「返回」「参数」（仅 tcp/udp 有，均正确填写；本组 5 文件确无此类工件条目，与 T3 报告 §1 一致）。

5 个不一致条目：

| # | msgid | 涉及文件 | P1/P2 依据 | 处置 |
|---|---|---|---|---|
| 1 | "the file descriptor is set to non-blocking mode." | pipe.po(我)/tcp.po/udp.po | **有** poll.po:114 | 本组 pipe.po 已改为「文件描述符被设置为非阻塞模式。」；tcp.po「被设为」、udp.po 符合先例 → tcp 由 A 组改（§4-1） |
| 2 | "0 on success, or an error code < 0 on failure." | tcp.po/udp.po | **有** request.po:97、async.po:109 | 均为 A 组文件：udp 符合先例「成功时返回 0，失败时返回小于 0 的错误码。」；tcp「失败时返回 < 0 的错误码」偏离 → §4-2 |
| 3 | "UV_NONBLOCK_PIPE: Opens the specified socket handle …" | pipe.po(我)/tcp.po | 无（tcp 同为 P3） | 待裁决 §5-1，未动 |
| 4 | "added ``0.0.0.0`` and ``::`` to ``localhost`` mapping" | tcp.po/udp.po | 无 | 待裁决 §5-2，未动（均 A 组） |
| 5 | "The callee is responsible for freeing the buffer, … null buffer …" | stream.po/udp.po | 无 | 待裁决 §5-3，未动（均 A 组） |

### 3.2 本组 5 文件 × P1/P2 全库：15 个共享 msgid，6 个不一致（3 个已修，3 个为 P1/P2 内部既有分歧）

| # | msgid | P1/P2 先例 | 本组原译 | 处置 |
|---|---|---|---|---|
| 1 | "Loop that started this request and where completion will be reported. Readonly." | fs.po:126「发起此请求并在其中报告完成情况的事件循环。只读。」 | threadpool.po 自译「发起此请求的循环，完成结果也将报告至该循环。」 | **已改**（§1.5） |
| 2 | "The :c:type:`uv_req_t` members also apply." | dns.po:93「……的成员也同样适用。」＝本组；**fs.po:162「……的成员同样适用。」少「也」** | threadpool.po 与 dns.po 一致 | 未动；fs.po 为 P1/P2 内部少数派（17 文件用「也同样适用」，仅 fs.po 两处不用），建议主控后续 sweep fs.po |
| 3 | "The :c:type:`uv_req_t` API functions also apply." | 同上（fs.po:626 少「也」） | 与 dns.po 一致 | 未动；同上 |
| 4 | "the file descriptor is set to non-blocking mode." | poll.po:114 | pipe.po 多「会」 | **已改**（§1.2） |
| 5 | "the returned length no longer includes the terminating null byte, and the buffer is not null terminated." | fs_event.po:157 / fs_poll.po:110 | pipe.po 用词不同（空字符/无「结尾的」） | **已改**（§1.2） |
| 6 | "Returns `handle->pid`." | handle.po:301 等「返回 `handle->pid`。」 | process.po 逐字一致 | 未动（确认项） |

另抽验句式：`---`→「——」（signal/timer/stream 等 P2 文件一致）、"X handle type."→「X 句柄类型。」（类型名保留英文）、versionchanged 无句号短句加句号（fs.po 先例）——本组均符合。

### 3.3 A 组（stream/tcp/udp）只读发现清单（未动那 3 个文件）

1. **tcp.po:243**（msgid "Returns 0 on success, or an error code < 0 on failure."）译「成功时返回 0，失败时返回 < 0 的错误码。」——有 P1/P2 先例（request.po:97、async.po:109）「成功时返回 0，失败时返回小于 0 的错误码。」，建议 A 组按先例改。
2. **tcp.po:81**（msgid "the file descriptor is set to non-blocking mode."）译「文件描述符被**设为**非阻塞模式。」——先例 poll.po:114 为「被设置为」，建议 A 组改；udp.po:220 已符合。
3. **stream.po:87 vs udp.po:88**（msgid "The callee is responsible for freeing the buffer, … The buffer may be a null buffer (where `buf->base` == NULL and `buf->len` == 0)."）两译法并存：「出错时，该缓冲区可能是空缓冲区（其中 …）」vs「出错时缓冲区可能是 null 缓冲区（即 …）」。无 P1/P2 依据，待主控裁决统一（「空缓冲区」与 buffer→缓冲区 更贴，「null 缓冲区」贴近原文 null buffer 字面）。
4. **tcp.po:292 vs udp.po:434**（msgid "added ``0.0.0.0`` and ``::`` to ``localhost`` mapping"）「新增了 …的映射」vs「将 …加入 …映射」。无 P1/P2 依据，待裁决（前者信息点更全）。
5. **tcp.po:320 vs pipe.po:224**（msgid "UV_NONBLOCK_PIPE: Opens the specified socket handle …"）两译法并存，见 §5-1。

## 4. 上游笔误条目复核（不改 msgid，全部只登记）

T3 报告 §5 的 8 条全部复核确认，处理合理：

| 条目 | 复核结论 |
|---|---|
| process.po "Options for spawning the process (passed to :c:func:`uv_spawn`." 缺右括号 | 译文同样不配对括号，与 msgid 逐字对应，合理 |
| process.po "unlike other the other init functions" | 译「这与 libuv 中的其他 init 函数不同」，按语义处理，合理 |
| process.po "the child processes uses the MSVCRT runtime" 主谓不一致 | 按单数语义译「只有当子进程使用 MSVCRT 运行时时」，合理 |
| process.po ×2 "specially on Windows"（应为 especially） | 译「尤其是在 Windows 上」，合理 |
| threading.po setname 平台列表 Linux 后无数值（疑漏 (16)） | 照原文括注位置直译「Linux、IBM i（16）、……」，未擅补数字，合理 |
| threading.po barrier 注以 "i.e." 断句接代码块 | 译「……以便于清理，即：」全角冒号引出代码块，合理 |
| pipe.po "First - call …" 连字符行文 | 译「首先，调用……」，合理 |
| tty.po "async signal-safe"（规范拼写 async-signal-safe） | 按 glossary §4 P2 裁决保留英文原样，合理 |

本次精校新发现的上游笔误（均已由初译合理消化，msgid 未动）：

- process.rst:194 "concatenates the arguments into a string this can cause some strange errors"（缺逗号连写）→ 译文拆句「将参数拼接成一个字符串，这可能引发一些奇怪的错误」。
- process.rst:265 "either way-success or failure--you must eventually"（连字符两侧缺空格，应为 em dash）→ 译文以「——」处理，符合风格指南。
- threadpool.rst:29 "shared across all events loops"（events loops 笔误）→ 译「在所有事件循环之间共享」，已归一。
- process.rst:200 "the parents environment"（缺所有格撇号）→ 译「父进程的环境」，语义正确。
- threading.rst:172 "in case `name` is larger"（语义应为 "if"）→ 译「会在 `name` 超过平台限制时将其截断」，语义正确。

## 5. 仍存疑、待主控裁决的条目

1. **UV_NONBLOCK_PIPE 条目译法统一**（pipe.po:224 vs tcp.po:320，msgid "UV_NONBLOCK_PIPE: Opens the specified socket handle for `OVERLAPPED` or `FIONBIO`/`O_NONBLOCK` I/O usage. …"）：
   - pipe.po（本组）：「UV_NONBLOCK_PIPE：为 `OVERLAPPED` 或 `FIONBIO`/`O_NONBLOCK` I/O 用途打开指定的套接字句柄。建议对将被 libuv 使用的句柄采用此选项，其他情况通常不建议。」
   - tcp.po（A 组）：「UV_NONBLOCK_PIPE：以 `OVERLAPPED` 或 `FIONBIO`/`O_NONBLOCK` I/O 用法打开指定的套接字句柄。对于将被 libuv 使用的句柄建议如此设置，其他情况通常不建议。」
   - 无 P1/P2 先例。差异点：①「为……用途」vs「以……用法」（usage）；②推荐句式。裁决后两组其一回改。另注：pipe.rst 中该句写 "socket handle" 属上游从 tcp 章复制所致，两译文均忠实保留「套接字句柄」，无需改 msgid。
2. **"added ``0.0.0.0`` and ``::`` to ``localhost`` mapping"**（tcp.po:292 vs udp.po:434）——A 组内部两译法，待裁决统一。
3. **"The callee is responsible for freeing the buffer, … null buffer …"**（stream.po:87 vs udp.po:88）——「空缓冲区」vs「null 缓冲区」，待裁决；裁决结果涉及 glossary 是否入库「null buffer」条目。
4. **fs.po 两处「同样适用」少「也」**（P1/P2 既有内部分歧，不在本批范围）——建议主控在后续 sweep 中统一为「也同样适用」。
5. **threading.po uv_thread_setname 平台数值列表**（"Linux, IBM i (16), macOS (64)…" Linux 后疑漏数字）——已照原文直译，待上游修复后再同步（登记在案即可）。

## 6. 术语与风格合规结论

- glossary §2 统一译名（互斥锁、读写锁、屏障、条件变量、线程局部存储、同步原语、信号/信号量、派生、管道/命名管道、主进程/工作进程、句柄传递等）在 175 条中零违例；§4 不译清单（`uv_*`/`UV_*`/errno/SIG*/文件名/平台名/句柄类型名）全部保留英文；term_check 机器扫描 0 error。
- T3 报告 §4 的 25 条新术语提议经复核无与既有术语冲突者，其中「虚假唤醒」「句柄传递」「抽象命名空间套接字」「线程局部键」「僵尸进程/回收」「虚拟终端序列」「TTY 模式」「阻塞式写入」「自动检测」「向上取整到最近的页边界」等在本批语境中使用恰当，同意随批次收尾裁决入库。
- 排版抽验：中英文间半角空格、全角标点（标记内除外）、中文弯引号（“子类”、“serializer”）、行尾无空格、`---`→「——」、`::`/`i.e.` 结尾条目全角冒号收尾——均合规；check_markup 邻接规则 0 error / 0 warning。
- neverwin 旧译文：本组未发现采用迹象（与 T3 报告 §6 一致）。

## 7. 一句话总结

B 组 5 文件 175 条全量精校完成：修订 10 条（94.3% 原译直接确认），跨文件同 msgid 对齐以 P1/P2 为准修复 3 条，A 组 3 文件只读发现 5 条移交主控，修订后 5 文件 msgfmt / fuzzy / check_markup / term_check 全绿，msgid 与文件头逐字未动。
