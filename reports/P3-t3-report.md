# P3 批次报告 —— 任务 T3（threading.po + pipe.po + process.po + tty.po）

- 批次: P3 / 任务: T3
- 执行: zcode agent（GLM），2026-11-19
- 范围: `locale/zh_CN/LC_MESSAGES/` 下 `threading.po`、`pipe.po`、`process.po`、`tty.po`
- 规范依据: `STYLE_GUIDE.md`、`glossary.md` 开工前全文通读；上游原文 `workdir/docs/src/threading.rst`、`pipe.rst`、`process.rst`、`tty.rst` 仅作上下文参考，未改写
- 写回方式: 全程 Read + Edit 分块写回（每块 13–20 条），无 Bash 直改

## 1. 完成统计

| 文件 | 条目数（不含文件头） | 已翻译 | 跳过 | 备注 |
|---|---:|---:|---:|---|
| `threading.po` | 48 | 48 | 0 | 无 fuzzy 条目；无「返回」/「参数」字段标签工件 |
| `pipe.po` | 39 | 39 | 0 | 无 fuzzy 条目；多处 msgid 被两个位置引用共享（bind/connect 同文），仍按单条目处理 |
| `process.po` | 38 | 38 | 0 | 无 fuzzy 条目；含 1 处上游笔误（见 §5） |
| `tty.po` | 31 | 31 | 0 | 无 fuzzy 条目 |
| **合计** | **156** | **156** | **0** | |

- 跳过条目：无。四个文件均无 `#, fuzzy` 条目，无需 fuzzy 修订流程。
- `git diff -U0` 核验：4 文件共 156 处变更，全部为 `msgstr ""` → 译文替换；msgid、位置注释、文件头零改动。

## 2. 自检结果（收尾实测，2026-11-19）

```text
msgfmt -c:  threading / pipe / process / tty 四文件全部零错误
fuzzy 计数: threading=0, pipe=0, process=0, tty=0
check_markup: 四文件 0 error / 0 warning（含邻接规则）
term_check:   四文件 0 error（156 条译文，黑名单 50 词）
```

- 空译文残留：仅 po 文件头条目（规范要求保留原样），内容条目 156/156 全部填充。
- 修过并复验的两处中间态问题（已归零）：
  - pipe.po #2：「streaming files」直译「流式文件」命中禁用词「流式」→ 改译「用作流的文件」；
  - pipe.po #27（FreeBSD 路径）：译文重排导致 `` `…` `` 字面量出现顺序与 msgid 不一致（error 级）→ 改回原顺序。

## 3. 与既有批次的句式对齐

- `--- ` 分隔符 → 「——」：`:c:type:`uv_pipe_t` —— Pipe 句柄`、`:c:type:`uv_process_t` —— Process 句柄`、`:c:type:`uv_tty_t` —— TTY 句柄`（对齐 signal/stream/timer.po）。
- "… handle type." → 「Pipe/Process/TTY 句柄类型。」（类型名保留英文，对齐 P2 句柄文件）。
- "The … members also apply." → 「……的成员也同样适用。」；"The … API functions also apply." → 「……的 API 函数也同样适用。」（对齐 fs_event/idle/async.po）。
- 章节标题 "Data types" → 「数据类型」、"Public members" → 「公开成员」（STYLE_GUIDE §3.8）、"API" → 「API」、"N/A" → 「无」（对齐 dll/fs_event.po）。
- "'subclass'" → 「“子类”」（逐字对齐 tcp.po）。
- "Valid values for `flags` are:" → 「`flags` 的有效取值为：」（对齐 tcp.po）。
- threading 的 "X data type." 中 mutex/读写锁/信号量/条件变量/屏障/thread 按术语表译为中文（这些词不在 §4 不译清单；对齐 dll.po「共享库数据类型」、misc.po「缓冲区数据类型」先例）；pipe/process/tty 的类型名按任务书预置保留英文。
- 版本注记片段（msgid 无句号的小写开头短句，如 "the file descriptor is set to non-blocking mode."）按独立短句翻译并以句号收尾（对齐 fs.po 先例）。

## 4. 新术语提议（未收录术语 → 本批采用的译名 + 理由，供批次收尾裁决入库）

| 英文术语 | 本批译名 | 理由 / 出处 |
|---|---|---|
| handle passing | 句柄传递 | pipe.po 高频核心概念（IPC 句柄传递），跨文件复用 |
| abstract namespace socket | 抽象命名空间套接字 | Linux Unix 域套接字特有机制名，通行译名 |
| bytes on the wire | 线上传输的字节 | pipe.po `ipc` 参数说明；"on the wire" 网络文献通行译法 |
| leading / trailing nul byte | 前导 nul 字节 / 结尾 nul 字节 | 与 P2 已裁决「terminating null byte → 空终止字节」同族；msgid 用小写 nul，nul 字面常量保留不译 |
| pipe instance | 管道实例 | Windows 命名管道实例（uv_pipe_pending_instances 语境） |
| streaming files | 用作流的文件 | 直译「流式文件」命中禁用词「流式」（stream→流）；建议裁决时一并入库规范译法 |
| spurious wakeup | 虚假唤醒 | POSIX 条件变量通行术语（threading.po） |
| detach / detached thread | 分离 / 已分离的线程 | pthread 通行译名（uv_thread_detach） |
| thread-local key | 线程局部键 | 与已入库「线程局部存储」配套（uv_key_t） |
| once-only initialization / initializer | 一次性初始化 / 一次性初始化器 | uv_once 语境，通行译名 |
| guard（uv_once 语境） | guard（保留英文） | uv_once_t 的参数名兼概念名，译「守护变量」易生歧义；建议入库裁决 |
| serializer thread | “serializer”线程（保留英文） | 上游自造角色名，带引号原样保留 |
| elevated privilege | 提升的特权 | 与 P2「elevated user → 已提权的用户」同族 |
| affinity setting | 亲和性设置 | thread affinity → 线程亲和性 已入库，此处为派生短语 |
| zombie / reap | 僵尸进程 / 回收 | Unix 进程通行术语（process.po） |
| best-effort basis | 尽力而为的方式 | process.po uv_disable_stdio_inheritance |
| communication channel | 通信通道 | process.po 开篇句 |
| stdio container | stdio 容器 | uv_stdio_container_t 语境 |
| virtual terminal sequence | 虚拟终端序列 | tty.po Windows 控制台机制，与 P2「console emulator → 控制台模拟器」配套 |
| TTY mode | TTY 模式 | uv_tty_mode_t 语境 |
| blocking writes | 阻塞式写入 | tty.po（blocking→阻塞 已入库，派生短语） |
| auto-detected | 自动检测 | tty.po |
| round up to the nearest page boundary | 向上取整到最近的页边界 | threading.po 栈大小说明 |
| scheduling priority | 调度优先级 | P2 已入库（misc），threading 直接复用 |

## 5. 存疑条目（上游原文含糊 / 疑似笔误）与处理方式

| 位置 | 原文问题 | 处理方式 |
|---|---|---|
| process.po（uv_process_options_t 描述） | `Options for spawning the process (passed to :c:func:`uv_spawn`.` 缺右括号（上游笔误） | 译文保留不配对括号「（传递给 :c:func:`uv_spawn`。」，不擅自补全，与 msgid 逐字对应 |
| process.po（uv_spawn 说明） | "unlike other the other init functions" — "other the other" 重复词 | 按语义译「这与 libuv 中的其他 init 函数不同」 |
| process.po（stdio 成员注） | "only if the child processes uses the MSVCRT runtime" — 主谓不一致（processes uses） | 按单数语义译「只有当子进程使用 MSVCRT 运行时时」 |
| process.po / process.po（uv_process_kill、uv_kill） | "specially on Windows" — 应为 especially | 译「尤其是在 Windows 上」 |
| threading.po（uv_thread_setname） | "Linux, IBM i (16), macOS (64)…" — Linux 后无数值括注，平台与上限的对应关系含糊（上游疑漏 16） | 照原文括注位置直译，不擅补数字 |
| threading.po（uv_barrier_wait 注） | 段落以 "i.e." 结尾后接代码块（原文即断句） | 译「……以便于清理，即：」，以全角冒号收尾引出代码块 |
| pipe.po（uv_pipe_pending_count 注） | "First - call …" 连字符式行文 | 译「首先，调用……」，去除连字符（中文标点规范） |
| tty.po（uv_tty_reset_mode） | "async signal-safe"（规范拼写为 async-signal-safe） | 按 glossary §4 P2 裁决「async-signal-safe 不译」，此处原样保留英文 "async signal-safe" |

## 6. neverwin 旧译文采纳清单

无。本批 156 条均为全新独立翻译，翻译过程中未参考、未采纳 neverwin（github.com/neverwin/libuv-docs-chinese）旧译文，README 无需为其署名本批条目。

## 7. 任务书预置术语执行情况

- threading：互斥锁、递归互斥锁（未出现于本批 msgid）、读写锁、屏障（与 fence→栅栏 不冲突）、条件变量、同步原语、线程局部存储、线程安全（未出现）、CPU 密集型（未出现）、调度器（未出现）——按预置执行。
- pipe：管道（全程未出现「管线」）、命名管道、Unix 域套接字、非阻塞、轮询（未出现于本批）——按预置执行。
- process：派生（spawn 语境一律「派生」，未用「创建」）、信号、信号处理函数（未出现）、主/工作/守护进程（未出现）、轮转（未出现）、递送（未出现）、子进程/父进程——按预置执行。
- tty：控制终端（未出现于本批 msgid）、原始模式（未出现）、终端、控制台窗口/模拟器（未出现）、ANSI 转义码（本批作 "ANSI X3.64" 保留）、I/O（保持 I/O）——按预置执行。
- 句柄类型名保留英文："Process 句柄"、"Pipe 句柄"、"TTY 句柄" 全部落实；`---` → 「——」全部落实。
- 错误描述惯用译法：本批无独立错误码描述条目，`UV_*` 返回说明按 §3 语域行文（如「无效」类未出现）。
