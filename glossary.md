# 术语表（glossary.md）

> 版本: P0 种子版 v0.1（2026-11-18）｜ 状态: 随批次演进，每批次收尾可增补
> 强制性: 批次翻译 agent **必须全文遵守**；`scripts/term_check.py` 按本表「禁用译名」机器扫描 po 文件，出现即门禁失败
> 裁决流程: 翻译时遇到未收录术语 → 先按本表规则 2 的通则临时定名并在批次报告中提议 → 批次收尾统一裁决入库，后续批次回改

## 1. 术语使用通则

1. **有通行中文译名的技术名词**采用通行译名，并在跨文档语境中保持唯一（如 event loop → 事件循环）。
2. **函数、类型、宏、常量、文件名、命令、errno 名称、环境变量**一律不译，保留原文（如 `uv_loop_init()`、`uv_loop_t`、`UV_EEXIST`、`EEXIST`、`EINTR`、`SIGTERM`、`O_RDONLY`、`Makefile`）。
3. **错误码常量（`UV_E*`）与 errno 名称不译**；错误码后跟的**描述文字照常翻译**，惯用译法见 §3（如 `UV_EACCES` 描述 "Permission denied" → 权限不足）。
4. 句柄类型名（timer / prepare / check / idle / async / poll / signal / process / fs_event / fs_poll 等）与 API 段落标题中的类型名**保留英文**，修饰词照常翻译（如 "Timer handle" → Timer 句柄；"uv_prepare_t — Prepare handle" 译作 `uv_prepare_t — Prepare 句柄`）。
5. 译名一经入库即冻结；修改既有译名属术语变更，需在批次报告登记影响面并全量 sweep。

## 2. 核心概念术语表

| 英文术语 | 统一译名 | 首次出现章节 | 禁用译名 / 备注 |
|---|---|---|---|
| event loop | 事件循环 | guide/eventloops | 事件轮、循环器 |
| loop | 循环（指 `uv_loop_t` 实例时译「事件循环」） | guide/eventloops | 回路 |
| handle | 句柄 | guide/basics | 控制器、把手 |
| request | 请求 | guide/basics | 请求对象 |
| watcher | 监视器 | guide/basics | 观察者、监听器 |
| callback | 回调 | guide/basics | 回叫、回调函数（可混用「回调函数」，但统一用「回调」） |
| buffer | 缓冲区 | guide/basics | 缓存、缓存区 |
| stream | 流 | guide/networking | 流式、串流 |
| socket | 套接字（标识符/代码语境保留 socket） | guide/networking | Sock、网络套接字 |
| file descriptor | 文件描述符 | guide/basics | 档案描述符、句柄（与 handle 冲突） |
| polling | 轮询 | guide/eventloops | 轮巡、拉模式 |
| non-blocking | 非阻塞 | guide/eventloops | 非封锁 |
| blocking | 阻塞 | guide/eventloops | 封锁、卡死 |
| asynchronous | 异步 | guide/about | 异步地 |
| synchronous | 同步 | guide/about | 同步地 |
| event-driven | 事件驱动 | guide/about | 事件导向 |
| thread | 线程 | guide/threads | 线式 |
| thread pool | 线程池 | guide/utilities | 线程池子 |
| process | 进程 | guide/processes | 程序（与 program 区分） |
| spawn | 派生（子进程） | guide/processes | 产卵、孵化、创建（泛化过度） |
| signal | 信号 | guide/processes | 信号量（与 semaphore 冲突） |
| semaphore | 信号量 | guide/threads | 信号（与 signal 冲突） |
| pipe | 管道 | guide/pipe | 管线 |
| timer | 定时器 | guide/basics | 计时器 |
| file system | 文件系统 | guide/filesystem | 档案系统 |
| directory | 目录 | guide/filesystem | 文件夹（正式文本用「目录」） |
| reference counting | 引用计数 | guide/eventloops | 引用记数 |
| reference | 引用 | guide/eventloops | 参考计数 |
| default loop | 默认事件循环 | guide/basics | 缺省循环 |
| event loop 的 phases | 事件循环阶段 | guide/eventloops | 相位 |
| file system event | 文件系统事件 | fs_event | 文件事件 |
| flags | 标志 | 全库高频 | 旗标、标记 |
| options | 选项 | 全库高频 | 配置项（与 configuration 区分） |
| parameter | 参数 | 全库高频 | 形参（除非原文 parameter vs argument 需区分） |
| argument | 参数 | 全库高频 | 实参（除非需区分） |
| return value | 返回值 | 全库高频 | 回传值 |
| error code | 错误码 | errors | 错误代码 |
| error message | 错误信息 | errors | 错误消息 |
| thread-safe | 线程安全 | guide/utilities | 执行绪安全 |
| file path | 路径 | guide/filesystem | 文件路径可混用，统一「路径」 |
| Windows | Windows | design（平台名） | 视窗 |
| Unix / Unix-like | Unix / 类 Unix | design（平台名） | 尤恩克斯 |
| POSIX | POSIX | design（标准名） | 可移植操作系统接口 |
| domain socket | 域套接字 | guide/processes | |
| Unix domain socket | Unix 域套接字 | guide/introduction | |
| named pipe | 命名管道 | guide/processes | |
| echo server | 回显服务器 | guide/processes | |
| daemon | 守护进程 | guide/processes | |
| master / worker process | 主进程 / 工作进程 | guide/processes | |
| round-robin | 轮转 | guide/processes | 禁用: 轮叫 |
| fire-and-forget | 发后即忘 | guide/processes | P4 sweep 回改 P1 暂保留英文处 |
| mutex | 互斥锁 | guide/threads | |
| recursive mutex | 递归互斥锁 | guide/threads | |
| read-write lock | 读写锁 | guide/threads | rwlock 同 |
| barrier | 屏障 | guide/threads | |
| condition variable | 条件变量 | guide/threads | |
| synchronization primitives | 同步原语 | guide/threads | |
| thread-local storage | 线程局部存储 | guide/threads | |
| work queue | 工作队列 | guide/threads | |
| thread affinity | 线程亲和性 | guide/threads | |
| scheduler | 调度器 | guide/threads | |
| signal handler | 信号处理函数 | guide/threads | |
| CPU bound | CPU 密集型 | guide/threads | 禁用: 受 CPU 限制 |
| garbage collector | 垃圾回收器 | guide/utilities | |
| heartbeat | 心跳 | guide/utilities | |
| events mask | 事件掩码 | guide/utilities | |
| interval timer | 周期定时器 | guide/utilities | |
| opaque struct | 不透明结构体 | guide/basics | |
| long-lived / short-lived | 长寿命的 / 短寿命的 | guide/basics | |
| de-initialize | 反初始化 | guide/basics | |
| call site | 调用点 | guide/basics | |
| Idling | 空转 | guide/basics | idle 句柄语境 |
| multicast | 组播 | guide/networking | 禁用: 多播（统一术语） |
| datagram | 数据报 | guide/networking | |
| peer | 对端 | guide/networking | |
| loopback | 环回 | guide/networking | 禁用: 回环（统一术语） |
| time-to-live (TTL) | 生存时间（缩写 TTL 保留） | guide/networking | |
| high resolution clock | 高分辨率时钟 | index | |
| ANSI escape code | ANSI 转义码 | index | |
| pull request | 拉取请求 | index | 禁用: 混用 PR/合并请求 |
| file change notification | 文件变更通知 | guide/filesystem | 与 file system event 区分 |
| file change event | 文件变更事件 | guide/filesystem | 与 file system event 区分 |
| buffer pool | 缓冲区池 | guide/filesystem | |
| evented I/O | 事件驱动 I/O | guide/filesystem | |
| poller | 轮询器 | design | |
| file I/O primitives | 文件 I/O 原语 | design | |
| due timer | 到期的定时器 | design | 禁用: 超时的定时器 |
| ref'd handles | 被引用的句柄 | design | |
| loop *alive* | 存活（循环存活） | design | 禁用: 活着的、活跃的（此语境） |
| handler | 处理函数 | guide（函数语境） | 与 handle→句柄 区分 |

### 2.1 P2 批次新增（2026-11-18 裁决，81 条）

| 英文术语 | 统一译名 | 首次出现章节 | 禁用译名 / 备注 |
|---|---|---|---|
| metrics | 指标 | metrics | |
| event handler | 事件处理器 | metrics | 此处指事件处理机制，与 handler→处理函数（函数语境）区分 |
| event provider | 事件提供程序 | metrics/loop | 禁用: 事件提供者 |
| idle time | 空闲时间 | loop/metrics | 与 Idling→空转（idle 句柄语境）区分 |
| sampling profiler | 采样式性能分析器 | loop | |
| backend | 后端 | loop/fs_event | |
| backend file descriptor | 后端文件描述符 | loop | |
| poll timeout | 轮询超时 | loop | |
| freelist | 空闲链表 | handle | |
| allocation pool | 分配池 | handle | |
| memory chunk | 内存块 | handle | |
| rule of thumb | 经验法则 | handle | |
| undefined behaviour / behavior | 未定义行为 | handle/async/signal | |
| experimental | 实验性的 | loop | |
| cast | 强制转换 | handle | C 类型转换语境 |
| union | 联合体 | handle/request | 类型语境；普通词「联合使用」不受限 |
| base handle | 基础句柄 | handle | |
| shared library | 共享库 | dll | |
| dynamic library | 动态库 | dll | |
| Release Candidate | 候选发布版 | version | |
| development snapshot | 开发快照 | version | |
| transport endpoint | 传输端点 | errors | |
| protocol driver | 协议驱动程序 | errors | |
| seek | 查找 | errors | UV_ESPIPE 语境 |
| null-terminated / zero-terminated | 以空字符结尾 | errors/fs | 统一裁决：含「以零结尾」「以 null 结尾」变体（NUL 字面常量语境除外） |
| null terminator / NUL terminator | 空终止符 | misc/fs_event | NUL 作为字面常量名保留 |
| terminating null byte | 空终止字节 | fs_event/fs_poll | |
| process title | 进程标题 | misc | |
| resident set size (RSS) | 常驻集大小 | misc | 缩写 RSS 保留 |
| uptime | 运行时间 | misc | |
| load average | 负载均值 | misc | |
| CPU affinity mask | CPU 亲和性掩码 | misc | |
| parallelism | 并行度 | misc | |
| interface identifier | 接口标识符 | misc | |
| IPv6 scoped address | IPv6 作用域地址 | misc | |
| allocator | 分配器 | misc | |
| high-resolution timestamp | 高分辨率时间戳 | misc | 与高分辨率时钟配套 |
| clock source | 时钟源 | misc | |
| real-time clock | 实时时钟 | misc | |
| monotonic clock | 单调时钟 | misc | |
| UNIX epoch | UNIX 纪元 | misc | |
| clock drift | 时钟漂移 | misc | |
| entropy | 熵 | misc | |
| short read | 短读 | misc | |
| elevated user | 已提权的用户 | misc | |
| priority class | 优先级类 | misc | |
| scheduling priority | 调度优先级 | misc | |
| effective uid / real uid | 有效 uid / 真实 uid | misc | uid 保留 |
| home directory / temp directory | 主目录 / 临时目录 | misc | |
| man page | 手册页 | fs | |
| C runtime | C 运行时 | fs | |
| exclusive lock | 独占锁 | fs | 与 mutex→互斥锁 区分 |
| metadata | 元数据 | fs | |
| append mode | 追加模式 | fs | |
| file caching | 文件缓存 | fs | 与 buffer→缓冲区 区分 |
| corner case | 边缘情况 | fs | |
| fallback | 回退 | fs | |
| nanosecond resolution | 纳秒精度 | fs | |
| sub-second precision | 亚秒精度 | fs | |
| directory stream | 目录流 | fs | |
| directory entry | 目录项 | fs | |
| junction point | 联接点 | fs | Windows NTFS 术语 |
| copy-on-write reflink | 写时复制的 reflink | fs | reflink 保留 |
| controlling terminal | 控制终端 | fs | P3 tty 复用 |
| drive letter | 盘符 | fs | |
| Volume Manager | 卷管理器 | fs | |
| no-op | 空操作 | request/dns | |
| single-shot | 一次性的 | timer | |
| rearm | 重新装载 | timer | 禁用: 重新装填（P2 裁决） |
| time-slice overrun | 时间片超限 | timer | |
| timer due value | 到期值 | timer | 与 due timer→到期的定时器 同族 |
| sequential consistency | 顺序一致性 | async | 缩写 seq_cst 保留 |
| coalesce | 合并 | async | 调用合并语境 |
| fence / memory fence | 栅栏 / 内存栅栏 | async | 与 barrier→屏障 区分 |
| loop thread | 循环线程 | async | |
| level triggering | 电平触发 | poll | 与 edge triggering（边沿触发）相对 |
| out-of-band messages | 带外消息 | poll | P3 tcp 复用 |
| busyloop | 忙循环 | poll | |
| signal handling | 信号处理 | signal | 与 signal handler→信号处理函数 配套 |
| deliver | 递送 | signal | 信号递送语境 |
| raw mode | 原始模式 | signal | P3 tty 复用 |
| console emulator | 控制台模拟器 | signal | |
| console window | 控制台窗口 | signal | |

### 2.2 P3 批次新增（2026-11-19 裁决，43 条）

| 英文术语 | 统一译名 | 首次出现章节 | 禁用译名 / 备注 |
|---|---|---|---|
| chunk | 分块 | udp | recvmmsg 语境，与 datagram→数据报 区分 |
| socket domain | 套接字域 | tcp/udp | init_ex 语境（AF_* 域） |
| datagram contract | 数据报契约 | udp | |
| raw socket | 原始套接字 | udp | |
| source-specific multicast | 特定源组播 | udp | 缩写 SSM 语境 |
| membership | 成员关系 | udp | 组播成员关系（drop/set membership） |
| connectionless | 无连接 | udp | |
| unconnected mode | 未连接模式 | udp | |
| packet | 数据包 | udp/tcp | 与 datagram→数据报 区分（上游两词混用，译文保持区分） |
| callee | 被调用方 | udp/stream | |
| null buffer | null 缓冲区 | udp/stream | 禁用: 空缓冲区（与 empty buffer 混淆）；指 `buf->base` == NULL 的缓冲区 |
| lazily | 惰性地（增长语境）/ 延迟创建（创建语境） | udp/threadpool | 禁用: 懒创建 |
| memory footprint | 内存占用 | threadpool | |
| throughput | 吞吐量 | threadpool | |
| load balancing | 负载均衡 | udp | SO_REUSEPORT 语境 |
| lightweight abstraction | 轻量抽象 | udp | |
| dual-stack | 双栈 | tcp | IPv4/IPv6 语境 |
| Nagle's algorithm | Nagle 算法 | tcp | 人名不译 |
| keep-alive probe | keep-alive 探测 | tcp | keepalive 选项名不译 |
| RST packet | RST 包 | tcp | |
| stream socket | 流套接字 | tcp | BSD SOCK_STREAM 语境，与 Stream 句柄类型名区分 |
| duplex communication channel | 双工通信通道 | stream | P3 裁决词根统一：channel→通道 |
| communication channel | 通信通道 | process | 同上 |
| idempotent | 幂等的 | tcp | |
| listening socket | 监听套接字 | stream/tcp | |
| incoming connection | 传入连接 | stream/tcp | |
| linger interval | linger 间隔 | tcp | linger 套接字选项语义保留 |
| simultaneous accepts | 并发接受 | tcp | |
| multi-process setups | 多进程部署 | tcp | |
| handle passing | 句柄传递 | pipe | IPC 句柄传递 |
| abstract namespace socket | 抽象命名空间套接字 | pipe | Linux Unix 域套接字机制名 |
| bytes on the wire | 线上传输的字节 | pipe | |
| leading / trailing nul byte | 前导 / 结尾 nul 字节 | pipe | msgid 小写 nul 按字面常量保留（对齐 NUL 保留规则）；null byte 文本语境仍用空终止字节 |
| pipe instance | 管道实例 | pipe | Windows 命名管道语境 |
| spurious wakeup | 虚假唤醒 | threading | |
| detach / detached thread | 分离 / 已分离的线程 | threading | pthread 语境 |
| thread-local key | 线程局部键 | threading | 与线程局部存储配套（uv_key_t） |
| once-only initialization | 一次性初始化 | threading | uv_once 语境 |
| elevated privilege | 提升的特权 | process | 与已提权的用户同族 |
| zombie process / reap | 僵尸进程 / 回收 | process | |
| best-effort | 尽力而为 | process | |
| stdio container | stdio 容器 | process | |
| virtual terminal sequence | 虚拟终端序列 | tty | Windows 控制台机制，与控制台模拟器配套 |
| TTY mode | TTY 模式 | tty | |
| blocking writes | 阻塞式写入 | tty | 派生短语（blocking→阻塞） |

### 2.3 P4 批次新增（2026-11-19 裁决，4 条）

| 英文术语 | 统一译名 | 首次出现章节 | 禁用译名 / 备注 |
|---|---|---|---|
| by value | 按值传递 | migration_010_100 | 动词搭配作「按值返回 / 按值接收」；与 by reference（按引用）相对 |
| roundtrip | 往返 | migration_010_100 | 线程池往返语境（"make a roundtrip to the threadpool"） |
| deprecated | 弃用 / 已弃用 | migration_010_100 | |
| internals | 内部结构 | migration_010_100 | "libuv internals" 语境，指内部数据结构 |

> 备案不入库: duality（个案句式「不再有 … 之分」，不冻结）；`..note::`（上游 migration_010_100.rst:139 指令缺空格笔误被抽取为文本段，按 DR-005 同类处置逐字镜像，登记于 P4 批次报告）。

## 3. 错误描述惯用译法（errors.rst 高频错误信息，R2-9）

> 适用: `UV_E*` 常量后的英文描述、错误返回说明文本。错误码常量本身不译（通则 3）。

| 英文描述 | 统一译法 | 备注 |
|---|---|---|
| Success | 成功 | |
| Permission denied | 权限不足 | 禁用: 权限被拒绝 |
| Address already in use | 地址已被占用 | |
| Address not available | 地址不可用 | |
| Address family not supported | 不支持的地址族 | |
| Connection refused | 连接被拒绝 | |
| Connection reset by peer | 对端重置了连接 | 禁用: 连接被复位 |
| Broken pipe | 管道破裂 | |
| Operation was interrupted | 操作被中断 | |
| Interrupted system call | 系统调用被中断 | |
| Invalid argument | 无效参数 | |
| No such file or directory | 无此文件或目录 | |
| No such device | 无此设备 | |
| Input/output error | I/O 错误 | |
| Out of memory / Cannot allocate memory | 内存不足 | |
| Timed out | 已超时 | |
| Too many open files | 打开的文件过多 | |
| Operation not permitted | 不允许的操作 | |
| Operation not supported | 不支持的操作 | |
| Operation would block | 操作会阻塞 | |
| Operation canceled | 操作已取消 | |
| Is a directory | 是一个目录 | |
| Not a directory | 不是一个目录 | |
| Not a socket | 不是一个套接字 | |
| End of file | 文件结束 | |
| Premature end of file | 文件过早结束 | |
| Protocol not supported | 不支持的协议 | |
| Protocol family not supported | 不支持的协议族 | |
| Network is down | 网络已断开 | |
| Network is unreachable | 网络不可达 | |
| Connection aborted | 连接已中止 | |
| Connection reset | 连接被重置 | |
| Connection timed out | 连接超时 | |
| Host is unreachable | 主机不可达 | |
| Invalid | 无效 | |
| Symbol link loops | 符号链接循环 | |
| Protocol error | 协议错误 | |
| Bad file descriptor | 文件描述符无效 | 禁用: 坏的文件描述符 |
| Cross-device link | 跨设备链接 | |
| Argument list too long | 参数列表过长 | |
| Directory not empty | 目录非空 | |
| Executable format error | 可执行格式错误 | |
| File table overflow | 文件表溢出 | |
| Filename too long | 文件名过长 | |
| Function not implemented | 函数未实现 | |
| Inappropriate file type or format | 文件类型或格式不当 | |
| Quota exceeded | 超出配额 | |
| Result too large | 结果过大 | |
| Value too large for data type | 值超出数据类型范围 | |

## 4. 不译清单（保留英文原文）

- API 标识符: 所有 `uv_*` 函数 / `uv_*_t` 类型 / `UV_*` 宏与常量 / `uv_err_name` 输出值
- errno 名称: `EEXIST`、`EINTR`、`EACCES`、`EAGAIN`、`ECONNRESET` 等
- 信号名: `SIGTERM`、`SIGINT`、`SIGPIPE` 等
- 打开标志: `O_RDONLY`、`O_WRONLY`、`O_RDWR` 等
- 文件名 / 路径 / 命令: `Makefile`、`CMakeLists.txt`、`gcc`、`make` 等
- 平台 / 标准 / 协议名: Windows、Unix、POSIX、TCP、UDP、SCTP、inotify、kqueue、epoll、IOCP、event ports（Solaris 机制名）、POSIX
- HTTP 头名、URL、许可证名: CC BY 4.0、MIT
- 无通行译名或特有行话（P1 裁决）: IPC、backlog（listen(2) 参数名）、tee（Unix 工具）、slab（内核术语）、baton（libuv 指南行话）、Hello World（程序名）
- 无通行译名或特有行话（P2 裁决）: tick（事件循环 tick 语境）、CSPRNG、async-signal-safe、sysfs、ramdisk、reflink、WTF-8、NUL（字面常量）、Y2K38、Unicies（上游笔误词）
- 无通行译名或特有行话（P3 裁决）: uv_once guard（「守护变量」易歧义，保留英文）、serializer thread（上游自造角色名，带引号原样保留）、keepalive（套接字选项名）
- 编码名: UTF-16、UCS-2、WTF-8 等
- 句柄/请求类型名: timer、prepare、check、idle、async、poll、signal、process、fs_event、fs_poll、tty、udp、tcp、pipe、stream（作为类型名出现时）

> 例外提示: 上述名词作为**普通英文单词**出现在句子中时按上下文翻译（如 "signals and pipes" 一般句境 → 信号与管道；类型名语境 "the signal handle" → signal 句柄）。

## 5. 机器扫描数据（scripts/term_check.py 读取本节，格式勿改）

### 5.1 禁用译名黑名单（msgstr 中出现即门禁失败；一行一条）

> 原则: 仅收录**无歧义**禁用词（与 §2 禁用列对应）；「句柄/程序/信号/信号量」等
> 上下文依赖词不进机器黑名单（会误伤合法术语），靠抽检把关。

档案描述符
事件轮
循环器
控制器
把手
观察者
监听器
回叫
缓存区
流式
串流
网络套接字
轮巡
拉模式
非封锁
卡死
线式
线程池子
产卵
孵化
管线
计时器
档案系统
文件夹
引用记数
回传值
错误代码
错误消息
执行绪安全
异步地
同步地
视窗
尤恩克斯
旗标
缺省循环
事件导向
权限被拒绝
连接被复位
坏的文件描述符
多播
回环
受 CPU 限制
超时的定时器
事件提供者
重新装填
null 终止符
NUL 终止符
以 null 结尾
以零结尾
null 字节
远端对端
