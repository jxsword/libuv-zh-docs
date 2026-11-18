# P3 批次报告 —— 任务 T2（stream.po + tcp.po）

- 批次: P3 / 任务: T2
- 执行: zcode agent（GLM），2026-11-19
- 工作目录: `locale/zh_CN/LC_MESSAGES/`
- 规范依据: `STYLE_GUIDE.md`、`glossary.md` 全文通读；上游原文 `workdir/docs/src/stream.rst`、`workdir/docs/src/tcp.rst` 仅作上下文参考

## 1. 完成统计

| 文件 | 条目数（不含文件头） | 已翻译 | 跳过 | 备注 |
|---|---|---|---|---|
| `stream.po` | 56 | 56 | 0 | 全部为空 msgstr 起步，无 fuzzy 条目 |
| `tcp.po` | 58 | 58 | 0 | 含 2 条字段标签工件（「参数」「返回」），无 fuzzy 条目 |

跳过条目：无。两文件原有 `#, fuzzy` 条目数均为 0，无需 fuzzy 修订。

平台名条目（tcp.po 的 AIX、DragonFlyBSD、FreeBSD、illumos、Linux、macOS、NetBSD、Solaris、Windows 共 9 条）按 glossary §4 不译清单原样保留英文。

## 2. 自检结果（收尾实测，2026-11-19）

```text
msgfmt -c stream.po → 零错误;  msgfmt -c tcp.po → 零错误
fuzzy 计数: stream=0, tcp=0
check_markup: 2 文件，0 error / 0 warning
term_check:   2 文件，114 条译文，0 error
```

仅剩的 `msgstr ""` 为 po 文件头条目（规范要求保留），内容条目无遗漏。

## 3. 共用句式两文件一致性（任务要求 3）

以下句式在 stream.po 与 tcp.po 中严格同译（与 P1/P2 既有文件 phrasing 对齐）：

- "… members also apply." → 「……的成员也同样适用。」（对齐 poll/signal/fs_event.po 既有译文）
- "… API functions also apply." → 「……的 API 函数也同样适用。」（同上）
- 章节标题 "Data types" → 「数据类型」、"Public members" → 「公开成员」（STYLE_GUIDE §3.8）、"API" → 「API」
- 类标题 `---` 分隔符 → 破折号「——」：`:c:type:`uv_stream_t` —— Stream 句柄`、`:c:type:`uv_tcp_t` —— TCP 句柄`
- "… handle type." → 「……句柄类型。」（对齐 P2 各句柄文件）
- "Initialize the handle." → 「初始化句柄。」（对齐既有文件）

## 4. 新术语提议（未收录术语 + 建议译名 + 理由，供批次收尾裁决入库）

| 英文术语 | 本批采用的译名 | 理由 / 备注 |
|---|---|---|
| dual-stack | 双栈 | IPv4/IPv6 双栈为通行译名；tcp.po `UV_TCP_IPV6ONLY` 条目 |
| socket domain | 套接字域 | `uv_tcp_init_ex` 语境，AF_* 域的标准称谓 |
| Nagle's algorithm | Nagle 算法 | 通行译名，人名算法不译名 |
| keep-alive probe | keep-alive 探测 | "probe" 译「探测」；keepalive 本身按任务要求不译 |
| RST packet | RST 包 | 全库暂无 packet 先例；建议裁决 packet → 「包」（开发文档语域）或「分组」（教材语域），本批取「包」 |
| stream socket | 流套接字 | BSD socket 类型语境（SOCK_STREAM），与 stream 句柄类型名区分 |
| duplex communication channel | 双工通信信道 | stream.po 开篇句 |
| idempotent | 幂等的 | 通行技术译名 |
| listen / listening socket | 监听 / 监听套接字 | 网络编程通行译名 |
| incoming connection | 传入连接 | stream/tcp 高频 |
| linger interval | linger 间隔 | `SO_LINGER` 语境，linger 为套接字选项语义保留 |
| simultaneous accepts | 并发接受 | uv_tcp_simultaneous_accepts 语境 |
| multi-process setups | 多进程部署 | "setups" 取「部署」 |
| struct（字段说明中） | 结构体 | "shutdown request struct" → 「关闭请求结构体」 |

## 5. neverwin 旧译文采纳清单

无。本批全部条目为新译；neverwin（github.com/neverwin/libuv-docs-chinese）仅作参考未整段采纳，README 无需为 P3-T2 增加署名条目。

## 6. 存疑条目与处理方式

1. **stream.po `uv_try_write2` 条目上游笔误**：msgid `…over a pipe like c:func:`uv_write2`.` 缺 role 前导冒号（`c:func:` 不是合法 role，Sphinx 会按默认 role 渲染）。译文将 `c:func:`uv_write2`` 规范化为 `:c:func:`uv_write2``：role 括注目标逐字相等校验通过、语义等价（均指向 uv_write2），且规避了邻接规则误报（原文残片 `:func:…` 前邻接字母 `c` 会被 check_markup 判渲染损坏）。建议向上游报修。
2. **tcp.po `tcp.rst:92` 上游反引号笔误**：msgid `…then ``UV_EINVAL``` is returned.`（三个反引号；同函数 :90 行同句为两个）。译文逐字保留 ``UV_EINVAL``` 工件以维持 msgid↔msgstr 字面量对等校验，句子其余部分与 :90 行同句保持同译。建议向上游报修。
3. **tcp.po 字段标签工件 2 条**：`msgid "参数"`（`:param:` 标签）与 `msgid "返回"`（`:returns:` 标签），位置注释均无行号。任务书仅明示「返回」，「参数」属同类抽取工件，按同一原则恒填「参数」，非缺陷。
4. **stream.po `uv_write2` note 原文用词不严谨**："must be a TCP, pipe and UDP handle on Unix" 实义为「三者之一」，译文按语义译「TCP、pipe 或 UDP 句柄」（直译「和」会产生歧义）。
5. **版本注记短句**：`versionchanged`/`versionadded` 文本按 STYLE_GUIDE §3.8 作独立短句翻译，句末体例随原文（如 tcp.po "added … mapping" 原文无句号，译文不以「。」收尾）。

## 7. 其他说明

- 翻译过程中每 10 条左右用 Edit 写回一次，未攒批。
- 未运行任何改动 po 集合的脚本；未改动任何 msgid、位置注释与文件头。
- `::` 结尾条目：本批两文件 msgid 均无以 `::` 结尾者（stream.po "Example:" 为单冒号行文，译文以「示例：」收尾）。
