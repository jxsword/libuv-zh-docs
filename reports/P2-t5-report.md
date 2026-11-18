# P2-t5 批次报告：request / timer / prepare / check / idle / async 六文件翻译

> 批次: P2-t5｜文件: `locale/zh_CN/LC_MESSAGES/{request,timer,prepare,check,idle,async}.po`｜上游: `upstream/v1.53.0/docs/src/{request,timer,prepare,check,idle,async}.rst`
> 完成日期: 2026-11-18｜引擎: zcode agent（GLM）

## 1. 完成条目数表

| 文件 | msgid 条目数 | 已翻译 | 未翻译 | `#, fuzzy` | msgfmt -c | check_markup.py | term_check.py |
|---|---|---|---|---|---|---|---|
| request.po | 26 | 26 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| timer.po | 24 | 24 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| prepare.po | 16 | 16 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| check.po | 16 | 16 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| idle.po | 18 | 18 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| async.po | 21 | 21 | 0 | 0 | 零错误（PASS） | 0 error / 0 warning | 0 error |
| **合计** | **121** | **121** | **0** | **0** | — | 0 error / 0 warning | 0 error（黑名单 43 词全扫描） |

自检命令（每文件完成后立即执行，六文件终态复验同结果）：

```text
msgfmt -c -o /dev/null <file>.po                              → PASS（零错误）
msgfmt --statistics -o /dev/null <file>.po                    → 已翻译条目数如上表（0 未翻译）
grep -c '^#, fuzzy' <file>.po                                 → 0
python3 scripts/check_markup.py <六文件>                       → 6 文件，0 error / 0 warning
python3 scripts/term_check.py <六文件>                         → 0 error
```

跨文件一致性核对：六个文件互为姊妹页（prepare/check/idle 三文件条目几乎同构），译法已对齐；并对照既有批次统一了小节标题（"Data types"→数据类型、"Public members"→公开成员、"API"→API，与 loop/fs/errors/design 等 5 个已译文件一致）、"N/A"→无（dll.po 先例）、"Initialize the handle."→初始化该句柄。、"The :c:type:`uv_handle_t` members/API functions also apply."→「…也同样适用。」。

## 2. 新术语提议（未收录术语 + 建议译名 + 理由）

以下术语本批次使用且 glossary.md 未收录，建议批次收尾时裁决入库：

| 英文术语 | 建议译名 | 理由 / 出现位置 |
|---|---|---|
| no-op | 空操作 | request.rst:74 "a successful no-op"；通行译法（NOP 指令即空操作） |
| single-shot | 一次性的 | timer.rst:9 "Timers are either single-shot or repeating"；通行译法 |
| rearm（rearmed） | 重新装填 | timer.rst:10 重复定时器再装填语义；备选「重新设定」，请裁决 |
| time-slice overrun | 时间片超限 | timer.rst:74；操作系统术语通行译法 |
| timer due value | 到期值 | timer.rst:87；与已收录 due timer→到期的定时器 同族 |
| sequentially consistent / sequential consistency | 顺序一致（seq_cst） | async.rst:12/27/18；C++ 内存模型通行译法，缩写 seq_cst 保留 |
| coalesce（calls） | 合并（调用） | async.rst:18 "libuv will coalesce calls"；通行译法 |
| fence（memory fence） | 栅栏（内存栅栏） | async.rst:30 `seq_cst` fence、async.rst:80 full memory fence；与 barrier→屏障 区分 |
| async-signal-safe | 保留英文 | async.rst:76 链接文本；POSIX signal-safety(7) 行话，对齐 §4 不译清单惯例 |
| loop thread | 循环线程 | async.rst:73 "called on the loop thread"；与 event loop→事件循环 一致 |
| zero timeout poll | 零超时的轮询 | idle.rst:12；polling→轮询 已收录 |
| FFI | FFI（保留） | request.rst:106 "FFI binding writers"；通行缩写，无统一中文定译 |

另：标题 "API" 保留英文（与既有批次一致）；"Base request"→基础请求（request.rst:5）。

## 3. 采纳 neverwin 旧译文条目清单

无（预期一致）。六个 po 文件初始 msgstr 均为空（无历史译文），本批 121 条全部为新译，未整段采纳任何旧译文。

## 4. 存疑条目与处理方式

| 位置 | 原文 | 疑点 / 处理 |
|---|---|---|
| prepare/check/idle/async.po | `msgid "返回"`（位置注释无行号） | 已知 Sphinx `:returns:` 字段标签抽取工件，按批次指示填恒等译文「返回」 |
| prepare/check/idle.po | `msgid "0"`、`msgid "0 on success, or `UV_EINVAL` when `cb == NULL`."` | `:returns:` 字段内容被抽取为独立条目；"0" 填「0」；后者译「成功时为 0，否则为 `UV_EINVAL` （`cb == NULL` 时）。」，重排语序以保持反引号 token 出现顺序与 msgid 一致（消除 check_markup 顺序 warning），并在 `` ` `` 结束标记与全角开括号间补半角空格（邻接规则） |
| request.rst:76 / async.rst:60 | "an error code < 0 on failure" | "< 0" 为代码语义，译「小于 0 的错误码」（request）；async 同式 |
| request.rst:129 | "e.g. `\"connect\"` (as in :c:type:`uv_connect_t`) for `UV_CONNECT`" | 中文语序调整：译「例如 `\"connect\"` （即 :c:type:`uv_connect_t` 中的名称）对应 `UV_CONNECT`」，保持 token 顺序；`\"connect\"` 与 URL/role 逐字保留 |
| request.rst:70 | "cancellation of an already-completed write is a successful no-op" | "successful no-op" 译「一次成功的空操作」，未加解释性括注 |
| request.rst:83 | "It's **not** safe to free …" | 强调词 **not** 保留标记对，译「…是 **不** 安全的」，两侧补半角空格满足邻接规则 |
| request.rst:95 | "callbacks called out of order with respect to other writes on the same stream" | 译「其回调相对于同一流上的其他写操作可能乱序调用」 |
| timer.rst:9 | "rearmed relative to the event loop's idea of \"now\"" | "idea of \"now\"" 译「所认定的“现在”」；rearm 见新术语提议 |
| timer.rst:15 | "a 50 ms interval whose callback takes 17 ms … 33 ms later" | 数字与单位 "ms" 间保留空格，与既有译文（如「大概在 1 毫秒」）惯例一致 |
| timer.rst:65/71/77 | "the repeat value"（msgid 中无反引号） | 参数名 repeat 上游未加标记，译文以纯文本保留「repeat 值」，未擅自加标记；uv_timer_get_repeat 描述 "Get the timer repeat value" 译「获取定时器的 repeat 值」 |
| idle.rst:15 | "not when the loop is actually \"idle\"" | 引号内 idle 指循环空闲状态，按 glossary「Idling→空转」语境译「循环真正“空转”」 |
| idle.rst:7/11 | "prepare handles / idle handles"（正文小写） | 句柄类型名保留英文且保持原小写：「prepare 句柄」「idle 句柄」；标题处 "Idle handle"→「Idle 句柄」 |
| async.rst:12/27 | "(seq_cst)"、"`seq_cst` fence" | 括注 seq_cst 为内存序缩写保留；有反引号的 `seq_cst` 逐字保留 |
| async.rst:76 | "`async-signal-safe <URL>`_" | 链接文本按 STYLE_GUIDE「可译」但本批保留英文术语（POSIX 行话），URL 逐字保留 |
| async.rst:80 | "a full memory fence … order all operations" | 译「一道完整的内存栅栏…对所有操作进行排序」；fence→栅栏 与 barrier→屏障 区分，见新术语提议 |
| async.rst:63 | "Unlike other handle initialization  functions"（上游双空格） | msgid 含双空格属上游排版；译文不受影响，照常译「与其他句柄初始化函数不同」 |

## 5. 硬性禁区遵守情况

- 仅填写 msgstr；msgid、位置注释（# 行）、文件头均未改动（跨文件一致性修订仅发生在 msgstr 内）。
- `uv_*` / `UV_*` / errno / `SIG*` / 文件名 / URL / role 括注 C 标识符逐字保留（check_markup 0 error、term_check 0 error 佐证）。
- 未增删段落、未合并拆分条目、未重排条目顺序；无繁体/日文汉字变体。
- `::` 结尾条目：本批六个文件均无（prepare/check/idle/async 的 literal block 未被抽取），无需处理；引号统一中文弯引号“”；中英文之间加半角空格；msgstr 无行尾空格。
- 未运行 gen_workdir / merge_po / init_po / validate_po.sh；未做任何 git 操作；未触碰任务外其他 po 文件。
