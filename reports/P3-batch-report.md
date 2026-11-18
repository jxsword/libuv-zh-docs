# P3 批次报告 —— 网络/进程/线程 8 文件（384 条）

- 批次: P3（stream、tcp、pipe、tty、udp、process、threading、threadpool）
- 执行: 主控 zcode agent（GLM）+ 3 翻译 agent（T1/T2/T3）+ 2 校对 agent（A/B），2026-11-19
- 分支: `p3-net-proc-thread` → 目标 main@c71ad21
- 门禁终态: msgfmt 8 文件零错误 ｜ fuzzy=0 ｜ check_markup 全库 0 error ｜ term_check 全库 0 error（黑名单 51 词）｜ 构建 error 2=基线 2、**warning 9=基线 9（零增量）** ｜ `validate_po.sh` 批次模式 exit=0

## 1. 完成统计

| 文件 | 条目 | 初译 | 校对修订 | 备注 |
|---|---:|---|---|---|
| udp | 95 | T1 | 3 | 含「参数」「返回」工件各 1 |
| threadpool | 19 | T1 | 1 | |
| tcp | 58 | T2 | 2 + 主控 1 | 含「参数」「返回」工件各 1；平台名 9 条保留英文 |
| stream | 56 | T2 | 1 + 主控 1 | |
| threading | 48 | T3 | 2 | |
| pipe | 39 | T3 | 5 | |
| process | 38 | T3 | 1 | |
| tty | 31 | T3 | 1 | |
| **合计** | **384** | **384** | **校对 16 + 主控 7 = 23** | 初译确认率 ~94% |

执行编排: 2 波 × 2 并发内（T1 udp+threadpool 114 条、T2 tcp+stream 114 条并行；T3 threading+pipe+process+tty 156 条次波），agent 粒度 114/114/156，同文件零并发写。

## 2. 主控终态统一

1. **跨文件同 msgid 对齐（校对移交裁决项）**:
   - `UV_NONBLOCK_PIPE: Opens the specified socket handle…`（pipe vs tcp）→ 裁决取 pipe.po 译法（「为…I/O 用途打开…」更贴合 "for … I/O usage"），tcp.po 回改 1 条；
   - `added ``0.0.0.0`` and ``::`` to ``localhost`` mapping`、null buffer 句、tcp 返回值句、非阻塞句 → A 组修订已统一，复核一致；
   - **fs.po 2 条**「同样适用」→「也同样适用」（P1/P2 内部少数派，对齐 17 文件多数派 + dns.po 先例，B 组建议采纳）。
2. **communication channel 词根统一**: stream.po「双工通信信道」→「双工通信通道」（与 process.po 统一，IPC/管道语域）。
3. **上游 role 缺冒号笔误处置（DR-005，用户裁决方案 A）**: udp.po `uv_udp_try_send2`、stream.po `uv_try_write2` 两条 msgstr 由「规范化为真 role」回改为**逐字镜像笔误残片**（`c:func:` 原样）；check_markup.py 邻接 role 正则加 `(?<![\w])` 负向前瞻消除误报（docutils 中反笔误残片渲染不损坏）。构建 warning 回到基线 9=9。
4. **术语裁决**: glossary 新增 **§2.2 P3 批次 45 条**（分块/套接字域/数据报契约/原始套接字/特定源组播/成员关系/无连接/未连接模式/数据包/被调用方/null 缓冲区/惰性地/内存占用/吞吐量/负载均衡/轻量抽象/双栈/Nagle 算法/keep-alive 探测/RST 包/流套接字/双工通信通道/通信通道/幂等的/监听套接字/传入连接/linger 间隔/并发接受/多进程部署/句柄传递/抽象命名空间套接字/线上传输的字节/前导结尾 nul 字节/管道实例/虚假唤醒/分离线程/线程局部键/一次性初始化/提升的特权/僵尸进程回收/尽力而为/stdio 容器/虚拟终端序列/TTY 模式/阻塞式写入）；§5.1 黑名单 +1（**远端对端**，51 词）并全量复扫 0 error；§4 不译清单 +1 行（P3 裁决: uv_once guard、serializer thread、keepalive）。
5. **不收录登记**（无争议不冻结）: dgram（按全称意译）、struct/auto-detected/affinity setting/round up to the nearest page boundary（通用词或派生短语）、streaming files（个案译「用作流的文件」，「流式」已在黑名单）、guard/serializer（见 §4 P3 裁决行）。

## 3. 上游笔误登记（本批累计，msgid 均未改动）

| 位置 | 笔误 | 处理 |
|---|---|---|
| udp.rst:456 / stream.rst:214 | `c:func:` 缺前导冒号（2 处） | DR-005: 译文逐字镜像，建议上游报修 |
| tcp.rst:92 | 三反引号 ``UV_EINVAL``` | 译文逐字保留，句式与 :90 同句一致 |
| udp.rst:23 / :485 / process.rst:194 等 | 双句点、括号不配对、连写句、缺撇号、主谓不一致、"other the other"、"specially"、events loops、in case 等 | 均按语义翻译并在 t1/t2/t3/proof 报告登记（明细见各报告 §存疑） |
| threading.rst:172 | Linux 平台数值疑漏 (16) | 照原文直译，待上游修复后随 sync 处理 |

## 4. neverwin 旧译文采纳

无。384 条全部为原创翻译，README 署名段无需新增（计划 §9）。

## 5. 产出文件清单

- po: `locale/zh_CN/LC_MESSAGES/{udp,tcp,stream,threading,pipe,process,tty,threadpool}.po`（384 条）+ `fs.po`（对齐 2 条）
- 脚本: `scripts/check_markup.py`（DR-005 邻接正则修正）
- 规范: `glossary.md`（§2.2 + §4 + §5.1）、`STYLE_GUIDE.md`（§2 补「返回/参数」工件定案）、`docs/decision_log.md`（DR-005）
- 报告: `reports/P3-t1/t2/t3-report.md`、`reports/P3-proof-A/B-report.md`、本报告、`reports/progress.md`（97%）

## 6. P4 入口

- 剩余: api(1) / migration_010_100(33) / upgrading(2)，共 36 条 + sphinx.po 界面串（当前 0 条译入，视需求裁决）；
- P4 需含: 全文术语一致性 sweep（含 fs.po 类内部分歧复查）、obsolete 清理检查、交叉校对复审。
