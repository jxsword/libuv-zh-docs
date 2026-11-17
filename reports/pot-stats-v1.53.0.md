# pot 抽取精确统计（v1.53.0 基线，P0 步骤6）

> 生成时间：2026-11-18 ｜ 命令：`make -C workdir/docs gettext`（Sphinx 7.0.1，venv pin 同 requirements-zh.txt）
> 统计口径：`msgfmt --statistics`（LC_ALL=C）；msgid 单位 = Sphinx TextElement（literal block 默认不抽取，计划 §3）
> 回填依据：计划 §1 / §5 / §7 / §11 已按本表回填

## 总览

| 指标 | 数值 |
|---|---|
| rst 文件数 | 42 |
| pot / po 文件数 | 42 + sphinx.po（界面覆盖占位）= 43 |
| **msgid 总数** | **1728** |
| 批次切分 | P1=509 ｜ P2=799 ｜ P3=384 ｜ P4=36 |

## 分文件明细（msgid 数，降序）

| pot 文件 | msgid | 批次 |
|---|---:|---|
| misc.pot | 157 | P2 |
| fs.pot | 138 | P2 |
| udp.pot | 95 | P3 |
| errors.pot | 93 | P2 |
| guide/utilities.pot | 89 | P1 |
| guide/processes.pot | 81 | P1 |
| guide/threads.pot | 67 | P1 |
| guide/filesystem.pot | 61 | P1 |
| handle.pot | 59 | P2 |
| design.pot | 58 | P1 |
| guide/networking.pot | 58 | P1 |
| tcp.pot | 58 | P3 |
| stream.pot | 56 | P3 |
| loop.pot | 54 | P2 |
| guide/basics.pot | 41 | P1 |
| threading.pot | 48 | P3 |
| pipe.pot | 39 | P3 |
| process.pot | 38 | P3 |
| poll.pot | 37 | P2 |
| migration_010_100.pot | 33 | P4 |
| tty.pot | 31 | P3 |
| signal.pot | 29 | P2 |
| dns.pot | 28 | P2 |
| fs_event.pot | 28 | P2 |
| request.pot | 26 | P2 |
| timer.pot | 24 | P2 |
| index.pot | 22 | P1 |
| async.pot | 21 | P2 |
| fs_poll.pot | 19 | P2 |
| threadpool.pot | 19 | P3 |
| idle.pot | 18 | P2 |
| check.pot | 16 | P2 |
| prepare.pot | 16 | P2 |
| guide/introduction.pot | 16 | P1 |
| metrics.pot | 13 | P2 |
| version.pot | 12 | P2 |
| dll.pot | 11 | P2 |
| guide/eventloops.pot | 9 | P1 |
| guide/about.pot | 5 | P1 |
| guide.pot | 2 | P1 |
| upgrading.pot | 2 | P4 |
| api.pot | 1 | P4 |

批次小计核对：P1 = 22+58+2+5+16+41+9+58+61+81+67+89 = **509**；P2 = 93+12+54+59+26+24+16+16+18+21+37+29+138+28+19+28+11+13+157 = **799**；P3 = 56+58+39+31+95+38+48+19 = **384**；P4 = 1+33+2 = **36**。总计 **1728** ✓
