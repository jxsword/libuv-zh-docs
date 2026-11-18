# P2-t3 批次报告：misc.po（杂项工具）

- 批次: P2-t3（misc.rst：版本宏、内存分配函数、主机名/内存/负载/运行时间查询、CPU 信息、网络接口地址、杂项工具、字符串操作函数）
- 执行: zcode agent（GLM），2026-11-18
- 输入依据: STYLE_GUIDE.md（P0 v0.1）、glossary.md（P0 种子版 v0.1）、upstream/v1.53.0 `docs/src/misc.rst`

## 1. 完成情况

| 文件 | msgid 数 | 已翻译 | fuzzy | msgfmt -c | check_markup | term_check |
|---|---|---|---|---|---|---|
| `locale/zh_CN/LC_MESSAGES/misc.po` | 157 | 157 | 0 | 0 error | 0 error / 7 warning | 0 error |

自检命令均为任务规定的 5 条（msgfmt 均带 `-o /dev/null`，未在仓库落 .mo 文件）：

- `msgfmt -c -o /dev/null` → 零错误；`--statistics` → 157 条已翻译，0 条未翻译
- `grep -c '^#, fuzzy'` → 0（本文件本就无 fuzzy 条目，无 `#|` 比对项）
- `check_markup.py` → 0 error / 7 warning（见 §4 说明）
- `term_check.py` → 157 条译文，0 error

只读 `git diff` 复核：157 insertions / 157 deletions，全部为 msgstr 行一一对应变更；msgid、位置注释（# 行）、文件头零改动。未执行任何 git add/commit/push，未触碰本批次以外的 po 文件。

### 7 条 warning 的性质（均已接受）

全部为「`单反引号` 内容不一致（顺序差异）」warning 级：单反引号内标识符（`uv_setup_args`、`buffer`、`/dev/random`、`buf` 等）均**逐字保留**，仅因中文语序（如 "Fill `buf` with `buflen`" 自然语序为「用 `buflen` 个…填充 `buf`」）导致出现次序与 msgid 不同。check_markup 对单反引号差异按 warning 设计（role / 双反引号 / URL / 粗体对等均为 error 级，本批全部通过）。已通过改写消除 3 处可自然调序的 warning（#123 name/value、#126 buffer/nul、#155 \*wtf8_ptr/wtf8_len_ptr），余下 7 处强行调序会产生欧化中文，不值得。

## 2. 新术语提议（未收录 → 建议译名，供收尾裁决入库）

| 英文术语 | 本批译名 | 理由 |
|---|---|---|
| Miscellaneous utilities | 杂项工具 | misc.rst 章节标题；与批次任务描述一致 |
| process title | 进程标题 | uv_setup_args / uv_get_process_title / uv_set_process_title 语境，通行译法 |
| resident set size (RSS) | 常驻集大小（RSS） | uv_resident_set_memory；操作系统术语通行译法，缩写保留 |
| uptime | 运行时间 | uv_uptime；通行译法 |
| load average | 负载均值 | uv_loadavg；通行译法（Average load 常译「负载均值」） |
| resource usage measures | 资源使用度量 | uv_getrusage / uv_getrusage_thread；getrusage 语境 |
| CPU affinity mask | CPU 亲和性掩码 | affinity 已入库为「线程亲和性」，mask 取「掩码」 |
| parallelism | 并行度 | uv_available_parallelism；通行译法 |
| interface identifier | 接口标识符 | uv_if_indextoname / uv_if_indextoiid；IPv6 术语 |
| IPv6 scoped address | IPv6 作用域地址 | IPv6 RFC 4007 通行译法 |
| allocator | 分配器 | uv_replace_allocator 语境 |
| high-resolution timestamp | 高分辨率时间戳 | uv_hrtime；glossary 已有「高分辨率时钟」，配套取「时间戳」 |
| clock source | 时钟源 | uv_clock_id 说明 |
| real-time clock / monotonic clock | 实时时钟 / 单调时钟 | uv_clock_gettime 段，Linux time 术语通行译法 |
| UNIX epoch | UNIX 纪元 | 通行译法（Unix 属不译清单平台名） |
| clock drift | 时钟漂移 | uv_hrtime 段，通行译法 |
| jump back in time | 时间回跳 | 时钟调整语境，「回拨/回跳」中取「回跳」 |
| entropy | 熵 | uv_random 段；密码学术语通行译名 |
| cryptographically strong | 密码学安全的 | uv_random；通行表述 |
| short read | 短读 | I/O 术语通行译法 |
| CSPRNG | CSPRNG（保留英文） | 密码学安全伪随机数生成器缩写，无通行中文简称 |
| elevated user | 已提权的用户 | Windows UAC 语境 |
| priority class | 优先级类 | Windows SetPriorityClass 术语 |
| scheduling priority | 调度优先级 | uv_os_getpriority / setpriority；通行译法 |
| thin wrapper | 轻量封装 | uv_os_uname；通行表述 |
| null terminator / NUL terminator byte | null 终止符 / NUL 终止字节 | C 字符串语境；NUL 与 null 按原文大小写区分保留 |
| password file entry / group file entry | 密码文件条目 / 组文件条目 | /etc/passwd、/etc/group（passwd/group 数据库）语境 |
| effective uid / real uid | 有效 uid / 真实 uid | POSIX 凭证术语；uid 保留英文 |
| home directory / temp directory | 主目录 / 临时目录 | uv_os_homedir / uv_os_tmpdir；通行译法 |
| ad hoc debugging | 临时调试 | uv_print_* 警告段 |
| binary structure | 二进制结构 | uv_ip4_addr 等；与「结构体」区分（此处泛指 sockaddr 结构） |
| machine（uname 字段） | 机器类型 | uv_os_uname 段 uname(2) machine 字段 |
| String manipulation functions | 字符串操作函数 | misc.rst 章节标题 |

另登记沿用既有惯例：`:returns:` 字段内容按「成功时为 0，失败时为小于 0 的错误码」句式；Windows/Unix/POSIX/macOS/Linux/Android/FreeBSD/NetBSD/OpenBSD/AIX/IBM i 等平台名全部保留英文；`uv_utf16_length_as_wtf8` 等标识符与 `"/tmp"`、`"/data/local/tmp"`、`fe80::abc:def1:2345%en0` 等字面量逐字保留。

## 3. 采纳 neverwin 旧译文条目清单

无。本批 157 条均为全新翻译，未参考或采纳旧译文（如实登记，预期一致）。

## 4. 存疑条目与处理方式

| 位置 | 问题 | 处理 |
|---|---|---|
| po 中 `msgid "返回"`（`#: ../../src/misc.rst`，无行号，位于 rst:889 与 rst:891 之间） | 疑似抽取工件：Sphinx `:returns:` 字段标签在 zh_CN locale 下被本地化为「返回」后进入 pot，msgid 已是中文。硬性规则禁止改 msgid | msgstr 填「返回」（与 msgid 相同），位置注释与条目顺序原样保留；建议收尾批次核对 pot 生成配置（是否应固定 `language='en'` 抽取） |
| rst:617（uv_os_get_group） | "for the provided uid" 疑似上游笔误：参数为 `uv_uid_t gid`，同族 uv_os_get_passwd2 才是 uid | 忠实原文译作「所提供 uid」，未擅改；建议向上游报 issue |
| rst:448 / rst:452（uv_ip4_addr / uv_ip6_addr） | "an IPv4 addresses / an IPv6 addresses" 单复数笔误 | 按单数语义译「将包含 IPv4/IPv6 地址的字符串…」 |
| rst:482（uv_if_indextoname） | "including the NUL terminator byte into the `*size`" 介词用法存疑（into） | 按语义译「NUL 终止字节计入 `*size`」 |
| rst:300（uv_buf_init 警告段） | "spurious failures.  Specifically" 双空格（上游排版残留） | 中文不保留双空格 |
| rst:878 / rst:882 / rst:884 / rst:885（熵来源列表） | 上游链接尾部标记异常：`` `RtlGenRandom <url>_` `` 等在 `_` 后又有一个反引号（rst 语法疑似错误） | 按抽取结果原样保留全部标记字符（check_markup role/URL/字面量对等通过），未修复上游标记 |
| rst:933 / rst:957（wtf8 转换函数） | 初译「计数 `utf16_len`（以字符为单位）」违反邻接规则（结束标记后紧跟全角开括号「（」） | 改写为「`utf16_len` 的计数值（以字符为单位）」，语义等价并通过邻接校验 |
| rst:436（uv_free_interface_addresses） | 初译 role 出现次序与 msgid 相反，触发 error 级「role 括注目标不一致」（列表逐字对等含顺序） | 改写为「释放 :c:type:`uv_interface_address_t` 数组，该数组由 :c:func:`uv_interface_addresses` 返回」，role 顺序与 msgid 一致 |
| rst:842（IBM i PASE \*JOBCTL） | `\*JOBCTL` 为 rst 转义星号 | msgstr 原样保留 `\*JOBCTL`（po 转义写作 `\\*JOBCTL`），「special authority」译「特殊权限」（IBM i 官方中文语境） |
| rst:895（uv_random `:returns:` 内容） | "an error code < 0" 含裸 `<` 符号 | 按语义译「小于 0 的错误码」，未保留 `<` 字符（中文语序自然消解，无标记对等问题） |

## 5. 遗留事项

- `msgid "返回"` 工件条目建议在批次收尾（merge/validate 阶段）统一裁决：若后续 pot 重新抽取为英文 "Returns"，本条目将自然失效。
- 邻接规则实测与 STYLE_GUIDE §2 一致：本轮 2 处「标记后紧跟全角开括号」error 均由「中文词 + （」改写消除；建议后续批次在含「计数/数值 + 括注」句式时预防性注意。
- warning 基线（reports/warning-baseline-v1.53.0.txt）如有全量刷新需求，本文件贡献 7 条「单反引号顺序差异」warning，标识符均已逐字保留。
