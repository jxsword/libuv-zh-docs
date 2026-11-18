# P2-t6 批次报告：poll / signal / fs_event / fs_poll / dns 五文件翻译

> 批次: P2-t6｜文件: `locale/zh_CN/LC_MESSAGES/` 下 poll.po、signal.po、fs_event.po、fs_poll.po、dns.po｜上游: `upstream/v1.53.0/docs/src/` 对应 5 个 rst
> 完成日期: 2026-11-18｜引擎: zcode agent（GLM）

## 1. 完成条目数表

| 文件 | msgid 条目数（不含文件头） | 已翻译 | 未翻译 | `#, fuzzy` | msgfmt -c | check_markup.py | term_check.py |
|---|---|---|---|---|---|---|---|
| poll.po | 37 | 37 | 0 | 0 | 零错误（PASS） | 0 error / 1 warning（见下） | 0 error |
| signal.po | 29 | 29 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| fs_event.po | 28 | 28 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| fs_poll.po | 19 | 19 | 0 | 0 | 零错误（PASS） | 0 error / 2 warning（见下） | 0 error |
| dns.po | 28 | 28 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| **合计** | **141** | **141** | **0** | **0** | — | 0 error / 3 warning | 0 error |

自检命令（每文件完成后立即执行，全部通过）：

```text
msgfmt -c -o /dev/null locale/zh_CN/LC_MESSAGES/<file>.po        → PASS（零错误，均带 -o /dev/null，无 .mo 落盘）
msgfmt --statistics -o /dev/null locale/zh_CN/LC_MESSAGES/<file>.po → 各文件全量已翻译（0 未翻译）
grep -c '^#, fuzzy' <file>.po                                    → 0（5 个文件全部为 0）
python3 scripts/check_markup.py <file>.po                        → 0 error
python3 scripts/term_check.py <file>.po                          → 0 error（黑名单 43 词全扫描）
```

3 条 warning 均为规范允许项，非缺陷：

- poll.po `#24`（poll.rst:100，uv_poll_start 错误说明段）：单反引号 token 提取受 `*may*` 斜体与 `**not**` 粗体干扰，msgid 与 msgstr 提取结果结构完全一致（均为同一种「反引号+斜体相邻」形态），属 checker 正则对上游原文标记相邻形态的固有提示；标记数量、内容逐字对等。
- fs_poll.po `#6`（fs_poll.rst:24）与 `#13`（fs_poll.rst:51）：单反引号 token 顺序 `path`/`status < 0`、`path`/`interval` 因中文语序与英文不同而互换，内容本身逐字一致，仅顺序 warning（与 P2-t4 fs.po `#41` 同类）。

## 2. 新术语提议（未收录术语 + 建议译名 + 理由）

以下术语本次批次内使用且 glossary.md 未收录，建议批次收尾时裁决入库：

| 英文术语 | 建议译名 | 理由 / 出现位置 |
|---|---|---|
| utility functions | 工具函数 | dns.po 标题 "DNS utility functions"（dns.rst:4）；通行译法，与 misc.po「杂项工具」风格协调 |
| level triggering | 电平触发 | poll.rst:136（硬件/事件模型通行术语，与边沿触发 edge triggering 相对） |
| out-of-band messages | 带外消息 | poll.rst:93（TCP out-of-band 数据，网络编程通行译法） |
| sysfs interrupts | sysfs 中断 | poll.rst:93；sysfs 为 Linux 内核机制名，按 §4 惯例保留英文 |
| busyloop | 忙循环 | poll.rst:23；内核/事件循环语境通行译法 |
| signal handling | 信号处理 | signal.rst:7；与 signal handler→信号处理函数（glossary 已有）配套 |
| deliver（信号递送） | 递送 | signal.rst:14/17/23；POSIX 信号学术语通行译法（信号递送/信号投递，取「递送」） |
| raw mode | 原始模式 | signal.rst:14/23（tty 术语，与行模式相对），tty.po 批次将复用 |
| console emulator | 控制台模拟器 | signal.rst:23 |
| console window | 控制台窗口 | signal.rst:19 |
| 32-bit / 64-bit | 32 位 / 64 位 | signal.rst:23/40；通行写法 |
| backend | 后端 | fs_event.rst:9/68（"best backend for the job"），通行译法 |
| monitoring infrastructure | 监视基础设施 | fs_event.rst:22（z/OS / AIX 语境） |
| null terminator | 空终止符 | fs_event.rst:135；与 fs.po 批次「null terminated string→以空字符结尾的字符串」建议统一族谱（见 §4） |
| terminating null byte | 空终止字节 | fs_event.rst:137 / fs_poll.rst:69（versionchanged 段） |
| kernel bug | 内核缺陷 | fs_event.rst:51（FreeBSD bugzilla 引用语境） |
| undefined behavior | 未定义行为 | signal.rst:48；C 标准术语通行译法 |
| no-op | 空操作 | dns.rst:95（uv_freeaddrinfo 段）；通行译法 |
| lookup result | 查找结果 | dns.rst:81/101（getaddrinfo/getnameinfo 语境） |
| request type | 请求类型 | dns.rst:15/25（与 request→请求 glossary 一致的复合词） |

另：章节标题 "API"、"Data types"（→数据类型）、"Public members"（→公开成员）、"N/A"（→无）沿用既有批次定案；标题分隔符 `---` 依 loop.po 先例译作 `——`。

## 3. 采纳 neverwin 旧译文条目清单

无（预期一致）。5 个 po 文件初始状态均为全空 msgstr（无历史译文，无 fuzzy 条目），本批全部为新译，未整段采纳任何旧译文。

## 4. 存疑条目与处理方式

| 位置 | 原文 | 疑点 / 处理 |
|---|---|---|
| signal.rst:32-34 | `` `SIGKILL.` ``（句号在反引号内） | 上游标记笔误（句号误入 code span）。单反引号内容须逐字保留，译文保留 `` `SIGKILL.` `` 原样且不再追加全角句号，避免双重句末标点；建议向上游报 typo |
| signal.rst:14/52 | SIGINT 句中第二次出现用 "it" 指代；SIGRT0/SIGRT1 | msgid 与 msgstr 的 SIG* token 计数必须对等（term_check 硬门禁），第二处 SIGINT 以「它」指代；SIGRT0/SIGRT1 为信号名保留英文 |
| fs_event.rst:15-18 | "spawned"、"containing folder" | spawn 按 glossary 译「派生」；"folder" 若译「文件夹」会命中 term_check 黑名单（glossary §2 directory 禁用列），依 glossary 统一译「目录」 |
| fs_event.rst:20/22 | `documentation_`、`` `IBM Knowledge centre`_ `` 具名链接 | 链接目标名为引用键不可译，整段保留英文原样（STYLE_GUIDE §2：链接文本可译，此处为外部引用键，保留以防断链） |
| fs_event.rst:131 / fs_poll.rst:63 | "an error code < 0" | 不等式为代码语义，译「小于 0 的错误码」；同段 `` `status < 0` ``（带反引号者）逐字保留 |
| fs_poll.rst:24 | "The watcher is *not* stopped but your callback..." | watcher 按 glossary 译「监视器」；"your callback" 中文不需物主代词，译「回调」不损语义（对齐 STYLE_GUIDE §3.6 不增不减） |
| dns.rst:74/99 | "Asynchronous :man:`getaddrinfo(3)`." | 译「异步版的 :man:`getaddrinfo(3)`。」，man role 括注逐字保留 |
| dns.rst:85-86 | 列表项 "status == 0, ... , or" / "status < 0, ..." | 两个列表项为独立 msgid，禁合并：第一项句尾 "or" 译「，或」悬置（与英文列表结构一一对应），第二项独立成句 |
| dns.rst:78 | `hints`/`node`/`service`/`res` 等字段参数名 | 全部保留英文不译（批次 prompt 明确要求）；`struct addrinfo` 无标记纯文本也保留原文 |
| poll.rst:104 | "polling is discontinued for the file handle" | "file handle" 此处指被轮询的文件描述符（非 libuv 句柄类型），译「对该文件句柄的轮询将停止」，保持字面对应 |
| poll.rst:88/93 | `events`/`status`/`UV_E*`/sysfs | 单反引号 token 逐字保留；`UV_E*` 为错误码通配写法保留原文；sysfs 为 Linux 机制名保留 |
| signal.rst:40 | "was rolled back to old implementation" | 译「被回退到旧实现」；注意与 loop/fallback 语境的「回退」一致 |

## 5. 硬性禁区遵守情况

- 仅填写 msgstr；msgid、位置注释（# 行）、文件头均未改动（填充按「空 `msgstr ""` 块逐条替换」方式执行，写入前校验条目数匹配）。
- `uv_*` / `UV_*` / `SIG*` / errno 名称 / 文件名 / role 括注 C 标识符逐字保留（term_check 0 error 佐证）。
- 未增删段落、未合并拆分条目、未重排顺序；无繁体/日文汉字变体。
- 未运行 gen_workdir / merge_po / init_po / validate_po.sh；未做任何 git 操作；未触碰任务外的其他 po 文件。
- msgstr 无行尾空格；本批 5 个文件均无 `::` 结尾条目（无需处理）；引号统一中文弯引号；邻接规则逐条自查（标记两侧补半角空格，如 poll.po「回调 *可能* 会」「**不** 是」「dns.po「**同步** 运行」），check_markup 邻接校验 0 error。
- 本批无 `#, fuzzy` 条目，无需 fuzzy 修订流程。
