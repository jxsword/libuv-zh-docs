# P2-t1 批次报告：errors / version / dll / metrics（zh_CN）

> 批次 agent：zcode（GLM）｜ 完成日期：2026-11-18
> 范围：`locale/zh_CN/LC_MESSAGES/{errors,version,dll,metrics}.po`，逐条填写 msgstr，未做任何 git 操作。

## 1. 完成条目数与自检结果

| 文件 | msgid 数 | 已翻译数 | fuzzy | msgfmt -c | check_markup | term_check |
|---|---|---|---|---|---|---|
| errors.po | 93 | 93 | 0 | 零错误（-o /dev/null） | 0 error / 0 warning | 0 error |
| version.po | 12 | 12 | 0 | 零错误（-o /dev/null） | 0 error / 0 warning | 0 error |
| dll.po | 11 | 11 | 0 | 零错误（-o /dev/null） | 0 error / 0 warning | 0 error |
| metrics.po | 13 | 13 | 0 | 零错误（-o /dev/null） | 0 error / 0 warning | 0 error |
| 合计 | 129 | 129 | 0 | — | 0 error / 0 warning | 0 error |

- 四文件全量复跑结果：`check_markup: 4 文件，0 error / 0 warning`；`term_check: 4 文件，129 条译文，0 error`。
- 本批遇到 `#, fuzzy` 条目数：0（与预期一致，未触发 fuzzy 修订流程）。
- `git status --porcelain` 确认仅上述 4 个 po 文件被修改，无 .mo 落盘（msgfmt 均带 `-o /dev/null`），未触碰其他文件。

## 2. 新术语提议（未收录 → 建议入库）

| 英文术语 | 建议译名 | 出处 | 理由 |
|---|---|---|---|
| metrics | 指标 | metrics.po 全篇 | 通行译名；`uv_metrics_t` 等标识符保留英文，正文叙述用"指标" |
| event handler | 事件处理器 | metrics.rst（uv_metrics_t.events 描述） | 此处 handler 指事件处理机制而非回调函数，不适用 glossary 的 handler→处理函数（函数语境） |
| event provider | 事件提供程序 | metrics.rst（epoll_wait 等内核机制） | "provider" 的通行译法（提供程序），指内核事件供给机制 |
| shared library | 共享库 | dll.rst | 通行译名 |
| dynamic library | 动态库 | dll.rst（uv_dlsym 描述） | 通行译名；与 shared library 区分使用，与上游用词一一对应 |
| Public members | 公开成员 | dll.po / metrics.po 共有小节标题 | 通行译法；建议全库统一（备选"公共成员"） |
| Release Candidate | 候选发布版 | version.rst（UV_VERSION_SUFFIX） | 通行译名 |
| development snapshot | 开发快照 | version.rst（UV_VERSION_IS_RELEASE） | 直译自然 |
| transport endpoint | 传输端点 | errors.rst（UV_ESHUTDOWN 描述） | POSIX errno 中文惯用译法 |
| seek | 查找 | errors.rst（UV_ESPIPE "invalid seek"） | seek 为普通词非标识符；备选"定位"，供裁决 |
| protocol driver | 协议驱动程序 | errors.rst（UV_EUNATCH 描述） | 通行译名 |
| zero-terminated | 以零结尾 | errors.rst（uv_strerror_r / uv_err_name_r） | null-terminated 的同义表述，取"以零结尾"贴合原文 zero |

登记（非提议）：`semantic versioning` 在 version.po 中保留英文——它是命名交叉引用目标（`` `semantic versioning`_ ``，目标定义于 rst 源 `.. _semantic versioning: https://semver.org`），译文若改写引用文本会断裂引用解析，故整体保留（STYLE_GUIDE 规则 2）。

## 3. 采纳 neverwin 旧译文的条目清单

无。本批 129 条均为全新翻译，未参考、未采纳任何 neverwin 旧译文（预期"无"，如实登记）。

## 4. 存疑条目与处理方式

| 位置 | 问题 | 处理方式 |
|---|---|---|
| errors.rst:8（errors.po 条目 2） | "or an API functions returns an integer" 疑似上游笔误（应为 function） | 按语义正常翻译，不改 msgid，不另行标注 |
| errors.rst:388（"function declared public."） | `.. versionchanged:: 1.10.0` 指令参数被抽取为独立条目，单独成句略显突兀 | 按字面译"函数声明为公开。"，渲染时仍归属 versionchanged 行，语义完整 |
| errors.rst:72（"ai_family not supported"） | glossary §3 同族模式为"不支持的 X"（如"不支持的地址族"），但 X 为标识符 ai_family 时该模式读起来像残缺短语 | 译作"ai_family 不受支持"（主谓式名词短语）；如验收希望严格对齐 §3 模式，可回改为"不支持的 ai_family"，登记供裁决 |
| errors.rst:292（"invalid seek"） | seek 无通行固定译名 | 译"无效的查找操作"；备选"无效的定位"，已在 §2 登记 |
| errors.rst:220（"machine is not on the network"） | machine 译"主机"会与 host→主机（UV_EHOSTUNREACH）混淆 | 译"机器不在网络上" |
| errors.rst:252（"operation not supported on socket"） | 直译长句拗口 | 译"套接字上不支持该操作"，信息点一一对应 |
| metrics.rst:61-63 | 上游对 `uv_loop_configure`（函数）误用 `:c:type:` role | 按规则原样保留 role 类型与顺序（check_markup 要求 role 逐字相等），不替上游"纠错" |
| dll.rst:22（"N/A"） | Public members 下的占位文本（无公开成员） | 译"无" |
| version.rst:7 | `semantic versioning`_ 引用文本不可译（见 §2 登记） | 保留英文引用整体，仅译周围文本 |

## 5. 其他执行说明

- errors.po 的 79 条 UV_E* 描述全部按 glossary §3 惯用译法执行（如 permission denied→权限不足、bad file descriptor→文件描述符无效、connection reset by peer→对端重置了连接）；§3 未覆盖条目按同风格（名词短语、简洁、全角标点）补齐，未出现黑名单词。
- `ai_flags`、`hints`、`ai_family`、`node`、`service`、`errno`、`buf`、`buflen`、`sys_errno`、`iter_macro`、`ioctl`、`utf-8` 等字段名/参数名/调用名一律保留英文。
- 内联标记（role、单反引号、``epoll_wait``/``metrics`` 双反引号字面量、命名引用）逐字保留；标记与中文之间按邻接规则补半角空格（如 `errno` 后接全角逗号/括号处均已避开 opener 冲突）。
- 本批无以 `::` 结尾的 msgid，未涉及全角冒号收尾规则。
- msgstr 均为单行（不在 msgstr 内引入续行），天然满足"禁止行尾空格"。
