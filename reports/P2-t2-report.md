# P2-t2 批次报告：loop.po + handle.po

- 批次: P2-t2（事件循环 API / 句柄基类 API）
- 执行: zcode agent（GLM），2026-11-18
- 输入依据: STYLE_GUIDE.md（P0 v0.1）、glossary.md（P0 种子版 v0.1）、upstream/v1.53.0 `docs/src/loop.rst` / `handle.rst`

## 1. 完成情况

| 文件 | msgid 数 | 已翻译 | fuzzy | msgfmt -c | check_markup | term_check |
|---|---|---|---|---|---|---|
| `locale/zh_CN/LC_MESSAGES/loop.po` | 54 | 54 | 0 | 0 error | 0 error / 0 warning | 0 error |
| `locale/zh_CN/LC_MESSAGES/handle.po` | 59 | 59 | 0 | 0 error | 0 error / 0 warning | 0 error |

自检命令均为任务规定的 5 条（msgfmt 均带 `-o /dev/null`，未在仓库落 .mo 文件）。
另以只读 `git diff` 复核：两文件各仅 msgstr 行变更（54 / 59 行，一一对应），msgid、位置注释、文件头零改动。未执行任何 git add/commit/push，未触碰本批次以外的 po 文件。

## 2. 新术语提议（未收录 → 建议译名，供收尾裁决入库）

| 英文术语 | 本批译名 | 理由 |
|---|---|---|
| event provider | 事件提供者 | loop.rst UV_METRICS_IDLE_TIME 说明中指 epoll/kqueue 等后端机制，直译贴合且无既有译名 |
| idle time（uv_metrics_idle_time 语境） | 空闲时间 | 与 glossary「Idling→空转（idle 句柄语境）」区分：此处指事件循环无事件可处理的时段，「空闲时间」为通行译法 |
| sampling profiler | 采样式性能分析器 | profiler 无收录；「性能分析器」为通行译名，「采样式」对应 sampling |
| event loop tick | 事件循环 tick（tick 保留英文） | 无通行中文译名，且本库 guide/eventloops.po 既有译文同样保留 tick 概念的英文写法；建议术语库收录「tick（保留英文）」 |
| backend file descriptor | 后端文件描述符 | uv_backend_fd 描述，file descriptor 已定「文件描述符」，backend 取「后端」 |
| poll timeout | 轮询超时（值） | polling 已定「轮询」 |
| freelist | 空闲链表 | handle.rst uv_alloc_cb 说明，数据结构通行译名 |
| allocation pool | 分配池 | 同上 |
| memory chunk | 内存块 | 同上 |
| FFI binding writers | FFI 绑定编写者 | FFI 属不译清单行话；binding 取「绑定」 |
| rule of thumb | 经验法则 | 通行译法 |
| undefined behaviour | 未定义行为 | C 标准术语通行译名 |
| experimental | 实验性的 | 通行译法 |
| malfunction | 功能失常 | uv_fileno 警告段 |
| cast | 强制转换 | handle.rst「be cast to」，C 语境通行译法 |
| union | 联合 | uv_any_handle 说明，C 类型通行译名 |
| Readonly. | 只读。 | uv_handle_t 公开成员注释 |
| Miscellaneous API functions | 杂项 API 函数 | 章节标题 |
| Public members | 公开成员 | 章节标题 |
| Base handle | 基础句柄 | handle.rst 主标题，handle 已定「句柄」 |

另登记两处既有惯例沿用（非新提议）：章节标题 `:c:type:`X`` --- Subtitle` 中的 `---` 译作中文破折号「——」；`i/o` 统一写作「I/O」（与 errors.rst 惯用译法「I/O 错误」一致）。

## 3. 采纳 neverwin 旧译文条目清单

无。本批 113 条均为全新翻译，未参考或采纳旧译文（如实登记，预期一致）。

## 4. 存疑条目与处理方式

| 位置 | 问题 | 处理 |
|---|---|---|
| handle.po #35（uv_has_ref） | 上游原文 "Returns non-zero if the handle referenced, zero otherwise." 缺系动词（应为 "is referenced"） | 按明显本意译出「如果句柄已被引用，则返回非零值，否则返回零。」，未在上游侧改动 |
| loop.po #35（uv_backend_fd 段） | 上游 "…run the event loop's callbacks in another see test/test-embed.c for an example." 为缺标点的连写句 | 按语义切分为两个分句：「……在另一个线程中运行事件循环的回调，示例参见 test/test-embed.c。」 |
| handle.po #57（refcount 首段） | 上游以单反引号 `` `and` `` 强调 "active and referenced" 两个并列条件，rst 字面量在中文句中无法自然融入 | 按 STYLE_GUIDE 规则 2（单反引号整体保留）保留 `and` 原样，译文作「处于活动状态 `and` 被引用的句柄」；建议后续与上游确认该字面量是否有意为之 |
| handle.po #54（uv_handle_type_name） | 译文若保留原文括注结构（`` `"pipe"`（如 :c:type:`uv_pipe_t`）``）会违反邻接规则（结束标记后不得紧跟全角开括号「（」） | 改写为「例如 :c:type:`uv_pipe_t` 中的 `\"pipe\"` 即对应 `UV_NAMED_PIPE`」，语义等价且通过邻接校验；标识符顺序与单反引号内容均与 msgid 一致 |
| loop.po #50 / #51（uv_loop_fork 注意与警告段） | "directory FS event handles" 属句柄类型名语境 | 按 glossary §4 例外提示保留类型名英文，译作「目录 FS event 句柄」 |
| loop.po #9（uv_loop_t.data） | "does not use and does not touch" 中 touch 为口语化表述 | 译「不使用也不触及」，保留原语的强调语气 |
| handle.po #22–#24、#30 | 句中类型名（uv_async_t 等）与 status=UV_ECANCELED 以普通文本出现（无内联标记） | 标识符逐字保留，顺序与 msgid 一致（term_check 通过） |

## 5. 遗留事项

- 无阻塞项。本批两文件已通过全部机器门禁，待收尾阶段 `validate_po.sh` 全量门禁与人工抽检。
- 新术语表待批次收尾统一裁决后回填 glossary.md。
