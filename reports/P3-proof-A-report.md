# P3 校对报告 —— A 组（udp.po + tcp.po + stream.po）

- 批次: P3 / 校对 A 组
- 执行: zcode 校对 agent（GLM），2026-11-19
- 范围: `locale/zh_CN/LC_MESSAGES/udp.po`（95 条）、`tcp.po`（58 条）、`stream.po`（56 条），合计 **209 条**
- 对照原文: `workdir/docs/src/udp.rst`、`tcp.rst`、`stream.rst`（v1.53.0），逐条 msgid ↔ msgstr 精校
- 规范依据: `STYLE_GUIDE.md`、`glossary.md` 全文通读；参考 `reports/P3-t1-report.md`、`P3-t2-report.md`

## 1. 逐文件统计

| 文件 | 复核条目数 | 修订条目数 | 确认无误（含认可既有处理） | 自检结果 |
|---|---|---|---|---|
| udp.po | 95 | 3 | 92 | msgfmt 0 错误；fuzzy 0；check_markup 0 error / 0 warning；term_check 0 error |
| tcp.po | 58 | 2 | 56 | 同上全绿 |
| stream.po | 56 | 1 | 55 | 同上全绿 |
| 合计 | 209 | 6（2.9%） | 203（97.1%） | 修订后三文件全部门禁零错误 |

修订纪律执行：全部改动仅涉及 msgstr 行（git diff 核验无 msgid / 位置注释 / 文件头改动）；未引入行尾空格；修订后逐文件重跑 msgfmt -c、check_markup、term_check 三条自检，全部零错误、零 fuzzy、0 error。

## 2. 修订清单（每条：msgid 片段 + 修订理由）

### udp.po（3 条）

1. `added ``0.0.0.0`` and ``::`` to ``localhost`` mapping`
   「将 …与… 加入 ``localhost`` 映射」→「新增了 ``0.0.0.0`` 和 ``::`` 到 ``localhost`` 的映射」。
   理由：与 tcp.po 同 msgid 译法统一（组内一致性清单 #3）；并与本库 "added …" → 「新增了 …」句式族（如 "added support for connected sockets" → 「新增了对已连接套接字的支持」）保持一致。
2. `…with the address and port of the remote peer.`（uv_udp_send 的 addr 参数）
   「包含远端对端的地址和端口」→「包含对端的地址和端口」。
   理由：glossary §2 peer → 对端；「远端对端」语义重复、行文生硬（对端本身即指远端一方），属表达偏差非信息缺失。
3. `Opens an existing file descriptor or Windows SOCKET as a UDP handle.`
   「…打开为 UDP 句柄。」→「…作为 UDP 句柄打开。」。
   理由：与 tcp.po 平行句（"Open an existing file descriptor or SOCKET as a TCP handle." → 「作为 TCP 句柄打开」）句式统一，更符合中文行文。

### tcp.po（2 条）

4. `the file descriptor is set to non-blocking mode.`
   「被设为非阻塞模式」→「被设置为非阻塞模式」。
   理由：已发布 poll.po 同 msgid 译法即「文件描述符被设置为非阻塞模式。」，按校对纪律第 7 条以先入库者为准（udp.po 同款亦为此译法）。
5. `0 on success, or an error code < 0 on failure.`
   「失败时返回 < 0 的错误码」→「失败时返回小于 0 的错误码」。
   理由：已发布 async.po 同 msgid 译法「成功时返回 0，失败时返回小于 0 的错误码。」，先入库者为准（与 udp.po、T1 报告 §6 登记的对齐约定一致）。

### stream.po（1 条）

6. `The callee is responsible for freeing the buffer, … may be a null buffer (where `buf->base` == NULL and `buf->len` == 0) on error.`
   「空缓冲区（其中 …）」→ 整条 msgstr 与 udp.po 同 msgid 逐字统一为「…出错时缓冲区可能是 null 缓冲区（即 `buf->base` == NULL 且 `buf->len` == 0）。」
   理由：与 udp.po（P3-T1 先译）同 msgid 保持一致；T1 报告已将 "null buffer → null 缓冲区" 登记为新术语提议；「空缓冲区」易与 empty buffer 混淆，且该术语特指 base 为 NULL 的缓冲区。

## 3. 一致性专项核验（任务清单第 5、7 条）

- **组内同 msgid**：以脚本对三文件 209 条做 msgid 全文比对，修订前发现 4 组同 msgid 不同译法（"0 on success…"、"null buffer"、"localhost mapping"、"non-blocking mode"），修订后复跑比对，**组内冲突 0**。
- **对已发布批次**：三文件全部 msgid 与其余 31 个 po（含 P1/P2 已发布文件）比对，除上述按先入库者修订的 2 条外无其他冲突。
- **stream/tcp 共用句式**（T2 声明对齐项复核）："Data types"→数据类型、"Public members"→公开成员、"API"→API、标题 `---`→「——」、「…的成员也同样适用。」/「…的 API 函数也同样适用。」、句柄类型名保留英文 —— 两文件均一致，复核通过。
- 工件条目：udp.po、tcp.po 的 `msgid "参数"`/`msgid "返回"` 均恒填「参数」「返回」；tcp.po 平台名 9 条（AIX/DragonFlyBSD/FreeBSD/illumos/Linux/macOS/NetBSD/Solaris/Windows）按 glossary §4 保留英文；`msgid "N/A"` → 「无」与已发布 5 个文件（check/fs_event/fs_poll/poll/prepare）一致。

## 4. 初译登记的上游笔误处理复核（任务清单第 8 条）

以下处理经复核均为合理且自检通过，予以确认：

| 位置 | 处理 | 复核结论 |
|---|---|---|
| udp.po `uv_udp_try_send2`（rst:456 role 缺前导冒号） | 译文规范化为 `:c:func:`uv_udp_bind`` | 合理；role 目标两侧一致，check_markup 通过 |
| stream.po `uv_try_write2`（rst:214 同类笔误） | 同上规范化 `:c:func:`uv_write2`` | 合理；同上通过 |
| tcp.po tcp.rst:92 三反引号工件 ``UV_EINVAL``` | msgstr 逐字保留 | 合理；字面量对等校验通过，句式与 rst:90 同句一致 |
| udp.rst:23 双句点 `..` / udp.rst:485 多余右括号 / rst:274 namelen 含糊表述 | 按语义规范处理 | 合理，未擅改 msgid |
| stream.po uv_write2 note "TCP, pipe and UDP handle" | 译「TCP、pipe 或 UDP 句柄」 | 正确；原文实义为三者之一，直译「和」会歧义 |

复核过程中未发现新的上游笔误，无需新增登记。

## 5. 仍存疑待主控裁决的条目（1 条）

- `msgid "UV_NONBLOCK_PIPE: Opens the specified socket handle for `OVERLAPPED` or `FIONBIO`/`O_NONBLOCK` I/O usage. …"`（tcp.po，uv_socketpair 段）
  与并行任务 T3 的 pipe.po（工作区未提交）同 msgid 译法用词不同：tcp.po「以 …I/O 用法打开指定的套接字句柄」vs pipe.po「为 …I/O 用途打开…」。已入库（HEAD）版本中该条 msgstr 为空，无先入库权威译法；两译文均正确、均通过门禁。因 pipe.po 属并行任务、超出本校对可改范围，未作改动；建议主控在 T3 收尾时择一统一。

## 6. 语义精校总体结论

- 未发现错译、漏译、增译；复合句信息点（如 uv_udp_recv_cb 的 recvmmsg 释放语义、uv_tcp_keepalive_ex 三参数与错误路径、uv_stream_set_blocking 的 warning 段、uv_write_nwritten 取消语义）均一一对应。
- 术语合规：组播/环回/数据报/数据包（区分 datagram 与 packet）/对端/套接字/缓冲区/生存时间 TTL/管道/电平触发（本组无）/双栈/幂等/监听等均按 glossary 及批次提议执行；term_check 全程 0 error。
- 标记与排版：role / ``…`` / `…` / **…** / URL 与 msgid 逐字对等；邻接规则无违规；中文弯引号、全角标点、中英文空格合规；无行尾空格。
