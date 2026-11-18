# P2 校对报告 A（misc.po + fs.po）

> 校对 agent: P2-proof-A ｜ 日期: 2026-11-18 ｜ 工作目录: `/home/ssy/soft-tech-docs-translate/libuv-zh-docs`
> 对象: `locale/zh_CN/LC_MESSAGES/misc.po`（157 条）、`locale/zh_CN/LC_MESSAGES/fs.po`（138 条）
> 规范依据: `STYLE_GUIDE.md`、`glossary.md`、上游原文 `upstream/v1.53.0/docs/src/misc.rst`、`fs.rst`
> 结论: **正式抽检 40 条 + 全量快扫 295 条，未发现需修改 msgstr 的明确错误；未做任何修改**，两文件全部门禁保持基准（warning 只减不增，实际不变）。

## 1. 抽检条目清单（正式抽检 ≥30 条，逐条对照 rst 原文）

抽检覆盖：长短条目、含标记条目（role / `**` / `` ` `` / 链接）、错误返回说明条目、`::` 结尾引导条目、`#, python-format` 条目、versionadded/versionchanged 片段。位置以 po 行号 + msgid 首词标识。

### 1.1 misc.po（22 条正式抽检 + 全量通读）

| 位置 | 条目（msgid 摘要） | 检查项 | 结论 |
|---|---|---|---|
| :26 | Miscellaneous utilities | 语义/文风 | 通过 |
| :29-32 | 本节包含杂项函数… | 语义（"don't really belong"→不宜归入） | 通过 |
| :39-48 | uv_buf_t base/len 成员 | 术语（缓冲区）、语义 | 通过 |
| :79-83 | uv_random_cb 回调说明 | role 括注、术语（回调）、语义 | 通过 |
| :94-97 | uv_os_fd_t 抽象表示 | 反引号字面量（typedef/int/HANDLE）、语义 | 通过 |
| :104-107 | uv_timeval_t Y2K38-unsafe | 语义（非 Y2K38 安全）、role | 通过 |
| :126-129 | getrusage `(X)` 成员 | 字面量 `(X)`、术语（类 Unix）、语义 | 通过 |
| :132-135 | 最大常驻集大小/千字节 | 语义、文风 | 通过 |
| :170-180 | uv_guess_handle + isatty | role（:man:/:c:func:）、语义（test for UV_TTY→测试结果是否为） | 通过 |
| :183-194 | uv_replace_allocator 覆盖标准库 | role 串（4 个 :man:）、语义（调用时机） | 通过 |
| :203-208 | 多次更换分配器 warning | 语义（"or that they are compatible"→新旧分配器相互兼容） | 通过 |
| :214-219 | uv_library_shutdown 全局状态 | 语义、事件循环术语 | 通过 |
| :240-245 | uv_buf_init 平台差异 | 语义（按值传递）、字面量 base/len | 通过 |
| :247-254 | len 大值 warning（511 MB/2 GB） | 语义（spurious→偶发）、数字与单位、Unicies→类 Unix 系统 | 通过 |
| :268-283 | uv_get_process_title 全条 | `*must*` 强调对等、错误码串、语义零漏译 | 通过 |
| :294-302 | uv_set_process_title 全条 | 同上 + 截断行为语义 | 通过 |
| :344-365 | available_parallelism / cpu_info | 语义（亲和性掩码、在线 CPU）、术语 | 通过 |
| :387-409 | interface_addresses / free / loadavg | 链接 `<url>`_ 原样、语义 | 通过 |
| :437-460 | inet_ntop/pton、UV_IF_NAMESIZE、if_indextoname | 语义（NUL 计入/不计入两分支）、字面量示例 | 通过 |
| :482-517 | if_indextoiid / exepath / setuid 警告 | 语义零漏译、`*必须*` 强调 | 通过 |
| :533-616 | homedir / tmpdir / passwd / group 长条 | 语义逐句比对（环境变量查找顺序、size 语义） | 通过 |
| :624-654 | 内存 4 函数（constrained/available） | 语义（UINT64_MAX、cgroups、z/OS RLIMIT_MEMLIMIT） | 通过 |
| :656-706 | hrtime / clock_gettime / print_all_handles | 语义（UNIX 纪元、单调时钟）、R/A/I 列表结构 1:1 | 通过 |
| :842-865 | entropy sources 列表 + :returns: | 链接 8 处逐字相等、`/dev/*` 字面量、错误码说明 | 通过 |
| :918-973 | 字符串操作 4 函数（WTF-8/UTF-16） | 超长条逐句比对（NULL 分支 × 3、截断返回）零漏译 | 通过 |

### 1.2 fs.po（18 条正式抽检 + 全量通读）

| 位置 | 条目（msgid 摘要） | 检查项 | 结论 |
|---|---|---|---|
| :29-37 | 开篇两段（sync/async、threadpool） | 术语（回调/线程池）、:ref: 原样 | 通过 |
| :46-62 | io_uring 段落 | 链接逐字、v1.45.0/v1.49.0 行为回退语义、role × 2 | 通过 |
| :77-82 | uv_timespec_t Y2K38-unsafe | 语义（不具备 Y2K38 安全性） | 通过 |
| :89-102 | uv_statfs_t / uv_dirent_t 等价物 | ``struct stat`` 字面量不译、语义 | 通过 |
| :105-115 | uv_dir_t 数据类型 | 语义（dirents/nentries 职责） | 通过 |
| :126-129 | uv_fs_t.loop 成员 | 术语（loop→事件循环，glossary §2）、Readonly→只读 | 通过 |
| :140-146 | uv_fs_t.result 成员 | 语义（< 0 表示错误；分别表示读/写数据量） | 通过 |
| :153-158 | uv_fs_t.ptr 成员 | 语义（别名 statbuf） | 通过 |
| :169-172 | uv_fs_req_cleanup | 语义 | 通过 |
| :183-204 | uv_fs_open / preadv 注记 / O_BINARY | 语义（CreateFileW、二进制模式） | 通过 |
| :198-204, 218-223 | UV_FS_O_FILEMAP 致命崩溃 warning ×2 | ``UV_FS_O_FILEMAP`` 字面量、读/写两版对应正确 | 通过 |
| :234-246 | mkdtemp/mkstemp 结果位置 | 语义（null terminated string） | 通过 |
| :253-286 | opendir/readdir/closedir 三件套 | 语义逐句（内存释放顺序、>= 0、"." ".." 目录项） | 通过 |
| :312-321 | scandir/scandir_next | ``UV_EOF`` 字面量、语义 | 通过 |
| :345-357 | statfs 结果字段为零 | 语义 | 通过 |
| :382-417 | uv_fs_copyfile 三标志 + warning | 语义逐句（EXCL/FICLONE/FICLONE_FORCE、回退机制、时间窗口） | 通过 |
| :462-477 | utime 系列 + z/OS + AIX + versionchanged | 语义（UV_FS_UTIME_NOW/OMIT）、``UV_ENOSYS`` 字面量 | 通过 |
| :523-546, 548-592 | realpath 警告块 / chown / get_type 系列 | 语义（UV_ELOOP 32 符号链接、subst 盘符）、链接逐字 | 通过 |
| :633-658 | uv_get_osfhandle / uv_open_osfhandle | 长条逐句（消耗参数语义、链接逐字）、``fd``/``os_fd`` 字面量 | 通过 |
| :665-887 | 文件打开常量 19 条（O_* 全量） | 语义逐条、FILE_FLAG_*/FILE_ATTRIBUTE_* 链接逐字、术语（非阻塞/独占锁/追加模式） | 通过 |

## 2. 全量快扫（系统性检查，工具辅助 + 通读）

对两文件全部 msgstr（295 条）做如下机器扫描（自建临时脚本 `/tmp/po_scan.py`，只读不写）：

| 检查项 | misc.po | fs.po | 说明 |
|---|---|---|---|
| msgstr 内 ASCII 直引号 | 4 处（行 553） | 0 | 行 553 为 `` `"/tmp"` ``、`` `"/data/local/tmp"` `` 字面量内容，与 msgid 逐字对应，**按规则 3 字面量不译，属正确保留**，非缺陷 |
| 角引号「」 | 0 | 0 | 引号规范符合（仅 :324/:327 使用中文弯引号 “”，与规范一致） |
| CJK 后半角句读（. , ; : ? !） | 0 | 0 | 全角标点规范执行到位 |
| 半角括号紧邻汉字 | 0 | 0 | — |
| 行尾空格 | 0 | 0 | — |
| 中西文之间缺空格 | 0 | 0 | 中英文间空格规则执行到位 |
| 繁体字 | 0 | 0 | 初扫命中的 境/路/定/建/硬 均为简繁同形字，排除误报后为 0 |
| 空译文 / fuzzy | 0 | 0 | msgfmt 统计：157/157、138/138 全部翻译 |
| 术语黑名单（term_check） | 0 error | 0 error | — |

术语一致性抽查（glossary 对照）：事件循环、句柄、回调、缓冲区、文件描述符、线程池、线程安全、非阻塞、符号链接、目录项、错误码、类 Unix、权限不足式描述（本两文件未涉及 UV_E* 描述翻译）等均符合 §2/§4；未发现禁用译名。

## 3. 邻接规则人工复核

机器 `check_markup.py` 两文件 0 error。人工复核全部「标记紧邻全角标点」情形（misc 60+ 处、fs 若干处）：

- 结束标记后接：`。` `，` `、` `；` `：` `"` —— 均属 docutils 结束后缀集合，安全；
- 起始标记前接：`，` `、` `。` `：` `"` 或半角空格 —— 均属合法前缀集合；
- **禁止模式复查：结束标记后紧跟全角开括号「（」、全角开括号后紧跟起始标记 —— 两文件均 0 处**（grep 实证）；
- 语义影响：未发现任何因邻接导致的渲染歧义（如 misc :715 `` `[flags] handle-type handle-address` `` 后接全角冒号、fs :321 `` `UV_EOF``。`` 等，均为安全组合）。

## 4. 修复清单

**空。** 未发现漏译、误译、术语违规、排版违规类明确错误，故未修改任何 msgstr；msgid、位置注释、文件头均未触碰。

## 5. 未修复的存疑项（登记备查，非错误）

| # | 位置 | 现象 | 不改原因 | 建议 |
|---|---|---|---|---|
| 1 | fs.po :448（fs.rst:448 versionchanged） | msgid `sub-second precission is supported on Windows` 无句号，msgstr 补了「。」；而同文件 :507 `implemented uv_fs_lchown`（msgid 亦无句号）译为「实现了 uv_fs_lchown」未补。两处体例不一致 | 纯排版口径差异，语义等价，两译法均可成立，不构成明确错误；按「拿不准不改」处理 | 若追求体例统一，建议后续批次统一 versionchanged 片段句号策略（可定为：msgid 无句号则不补） |
| 2 | misc.po :294-302（fs:191 等 loop 语境） | misc.po :702 `loop` 参数语境译「与给定 `loop` 关联」（保留标识符），fs.po :191 句柄成员 `Loop` 译「事件循环」 | 前者为参数名字面量语境、后者为普通名词语境，均符合 glossary「loop 指循环实例时译事件循环」及不译清单例外条款，属语境正确区分 | 无需行动 |
| 3 | misc.po :937 | "needed internally for dealing with Windows" 译「是 libuv 内部处理 Windows 时所需的」，补出了隐含主语 libuv | 补出的是上下文唯一可能的主语，无信息增衍，且提升可读性 | 如严格按「不增不减」抠字面，可改回「内部处理 Windows 时所需」；现译不改 |
| 4 | fs.po :188-189 | 「因此……因此」两句连用（对应 and thus / Because of this） | 对应原文两个不同连接词，不算误译；仅行文稍重复 | 可择一改「鉴于此」，属文风润色，非必需 |
| 5 | check_markup 基准 warning 7+2 | 均为「单反引号内容不一致（顺序）」：中文语序调整导致反引号串出现顺序与 msgid 不同，内容集合逐一相等；fs #87 为链接文本 `here`→`此处`（风格指南明确允许） | 强行对齐 msgid 顺序会损害中文语序；warning 属预期，且为机器静态顺序比对 | 保持现状；warning 数量未上升 |

## 6. 已知工件复核（按任务说明）

- misc.po :908-910 `msgid "返回"` → `msgstr "返回"`：确认为 Sphinx `:returns:` 字段标签抽取工件，恒等译文正确。
- 上游疑似笔误按正确含义翻译复核：fs.po :448 `precission`→「亚秒精度」✓；misc.po :416/:420 "an IPv4/IPv6 addresses"→「IPv4/IPv6 地址」✓；misc.po :251 "various Unicies"→「各种类 Unix 系统」✓。译法均合理。

## 7. 终态自检结果（与基准一致，warning 只减不增达成：不变）

```text
misc.po: msgfmt -c            PASS（0 error）
         check_markup.py      0 error / 7 warning（基准 7，未升）
         term_check.py        0 error（157 条译文，黑名单 43 词）
         fuzzy 计数           0
fs.po:   msgfmt -c            PASS（0 error）
         check_markup.py      0 error / 2 warning（基准 2，未升）
         term_check.py        0 error（138 条译文，黑名单 43 词）
         fuzzy 计数           0
```

校对过程只读文件，未执行任何 git 操作；扫描脚本置于 `/tmp/po_scan.py`（临时工件，不入库）。
