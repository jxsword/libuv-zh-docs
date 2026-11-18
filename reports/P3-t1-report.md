# P3-T1 批次报告（udp.po + threadpool.po）

- 批次: P3 / 任务 T1
- 执行: zcode agent（GLM），2026-11-19
- 范围: `locale/zh_CN/LC_MESSAGES/udp.po`、`locale/zh_CN/LC_MESSAGES/threadpool.po`

## 1. 完成情况统计

| 文件 | 条目总数 | 已翻译 | 跳过 | 备注 |
|---|---|---|---|---|
| udp.po | 95 | 95 | 0 | 含 2 条抽取工件（`msgid "参数"`、`msgid "返回"`，无行号位置注释） |
| threadpool.po | 19 | 19 | 0 | |

- `msgid "参数"`：与任务书已知的 `msgid "返回"` 同类的 Sphinx 字段标签抽取工件（`:param:` 标签被本地化进 msgid，位置注释无行号），按同法恒填「参数」，不算缺陷。
- `msgid "返回"`：按任务书定案恒填「返回」。

## 2. 自检结果（全部通过）

| 检查项 | udp.po | threadpool.po |
|---|---|---|
| `msgfmt -c` | 零错误 | 零错误 |
| fuzzy 计数（`grep -c '^#, fuzzy'`） | 0 | 0 |
| `check_markup.py` | 0 error / 0 warning | 0 error / 0 warning |
| `term_check.py` | 0 error（95 条译文） | 0 error（19 条译文） |

- `git diff` 核验：两文件 114 行变更全部为 msgstr 行，msgid、位置注释、文件头零改动。
- 本批次无 `#, fuzzy` 条目。

## 3. 新术语提议（未收录术语 → 建议译名 + 理由）

| 英文术语 | 建议译名 | 理由 / 出处 |
|---|---|---|
| chunk（recvmmsg 语境） | 分块 | udp.rst recvmmsg 说明高频词；与 datagram→数据报 区分 |
| socket domain | 套接字域 | uv_udp_init_ex 的低 8 位参数语境 |
| datagram contract | 数据报契约 | uv_udp_open Unix-only 段 |
| raw socket | 原始套接字 | 通行译名 |
| source-specific multicast (group) | 特定源组播（组） | SSM 组播标准术语 |
| membership | 成员关系 | 组播成员关系语境（set membership → 设置成员关系） |
| connectionless | 无连接 | 与已连接相对，网络通行译名 |
| unconnected mode | 未连接模式 | uv_udp_open 段 |
| packet（UDP packet / multicast packets） | 数据包 | 与 datagram→数据报 区分（上游两词混用，译文保持区分） |
| callee | 被调用方 | uv_udp_recv_cb 段 |
| null buffer | null 缓冲区 | base 为 NULL 的特指缓冲区，null 保留不译 |
| lazily / grow lazily | 延迟创建 / 惰性增长 | socket lazily created / thread stacks grow lazily |
| memory footprint | 内存占用 | threadpool 段 |
| throughput | 吞吐量 | threadpool 段 |
| load balancing | 负载均衡 | SO_REUSEPORT 段 |
| lightweight abstraction | 轻量抽象 | uv_udp_try_send2 段 |
| dgram（datagram 缩写） | 数据报（缩写未保留） | 上游口语缩写，按全称意译 |
| set the multicast ttl | 设置组播 TTL | 小写 ttl 指代 TTL 概念，缩写保留（对齐 glossary TTL 规则）；“Set the time to live.” 另译「设置生存时间」 |

## 4. neverwin 旧译文采纳情况

无。本批次全部条目为按 STYLE_GUIDE 原则的原创翻译，未整段参考/采纳 neverwin（github.com/neverwin/libuv-docs-chinese）译文，无需要署名的条目。

## 5. 存疑条目（原文含糊 / 疑似上游笔误）与处理方式

| 位置 | 原文问题 | 处理方式 |
|---|---|---|
| udp.rst:23（`Flags used in …`） | 句尾双句点 `..`（上游笔误） | 译文按单个句号「。」收尾，不保留双句点 |
| udp.rst:485（1.35.0 versionchanged） | `…on supported platforms).` 多余的右括号（上游笔误，括号不配对） | 译文丢弃该孤立「）」，语义不受影响 |
| udp.rst:456（uv_udp_try_send2 描述） | `call c:func:`uv_udp_bind`` —— role 缺少前导冒号（应为 `:c:func:`，上游笔误；照原样渲染会得到 “cuv_udp_bind” 坏输出，且「c」紧邻 role 会触发 check_markup 邻接 error） | 译文规范为 `:c:func:`uv_udp_bind``；check_markup 的 role 目标提取在 msgid/msgstr 两侧一致（均提取为 `uv_udp_bind`），门禁通过 |
| udp.rst:274（namelen 参数） | `On input it indicates the data of the `name` field.` 表述含糊（POSIX 语义应为“输入时表示 name 缓冲区大小”） | 按字面直译「输入时它表示 `name` 字段的数据」，未擅自补语义 |
| udp.rst:20（threadpool 1.45.0 versionchanged） | `threads now have an 8 MB stack instead of the (sometimes too low) platform default.` 插入语位置别扭 | 译「线程现在拥有 8 MB 的栈，而不是（有时过低的）平台默认值。」 |
| threadpool.rst:29 | `shared across all events loops` —— “events loops” 为上游笔误（应为 event loops） | 按正常语义译「在所有事件循环之间共享」 |

## 6. 遵循的既有全库约定（与已发布批次保持一致）

- “The :c:type:`uv_*_t` members/API functions also apply.” → 「…的成员/ API 函数也同样适用。」（对齐 async/dns/idle/fs_event 等）
- “0 on success, or an error code < 0 on failure.” → 「成功时返回 0，失败时返回小于 0 的错误码。」（对齐 async/request/dns）
- “added the `X` flag.” → 「新增了 `X` 标志。」（对齐 poll）
- 标题分隔符 `---` → 破折号「——」（`uv_udp_t —— UDP 句柄`）
- “Data types”→数据类型、“Public members”→公开成员、“API”→API（原样）
- `::`/行尾冒号引导条目以全角冒号收尾（本组仅 “The remaining bits can be used to set one of these flags:” 一条，按规则收「：」）
