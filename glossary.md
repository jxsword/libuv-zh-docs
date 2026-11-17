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
- 平台 / 标准 / 协议名: Windows、Unix、POSIX、TCP、UDP、SCTP、inotify、kqueue、epoll、IOCP、POSIX
- HTTP 头名、URL、许可证名: CC BY 4.0、MIT
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
