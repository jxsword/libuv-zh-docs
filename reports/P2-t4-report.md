# P2-t4 批次报告：fs.po 翻译

> 批次: P2-t4｜文件: `locale/zh_CN/LC_MESSAGES/fs.po`｜上游: `upstream/v1.53.0/docs/src/fs.rst`
> 完成日期: 2026-11-18｜引擎: zcode agent（GLM）

## 1. 完成条目数表

| 指标 | 数值 |
|---|---|
| msgid 条目数（不含文件头） | 138 |
| 已翻译（msgstr 填写） | 138 |
| 未翻译 | 0 |
| `#, fuzzy` 条目 | 0 |
| msgfmt -c | 零错误（PASS） |
| check_markup.py | 0 error / 2 warning（见下） |
| term_check.py | 0 error（黑名单 43 词，138 条译文全扫描） |

自检命令与结果：

```text
msgfmt -c -o /dev/null locale/zh_CN/LC_MESSAGES/fs.po        → PASS（零错误）
msgfmt --statistics -o /dev/null ...                         → 138 条已翻译消息（0 未翻译）
grep -c '^#, fuzzy' fs.po                                    → 0
python3 scripts/check_markup.py fs.po                        → 0 error / 2 warning
python3 scripts/term_check.py fs.po                          → 0 error
```

2 条 warning 均为规范允许项，非缺陷：

- `#41`（fs.rst:309，uv_fs_readdir 段）：单反引号 token 顺序 `dir` 与 `uv_fs_opendir()` 因中文语序（"由……调用返回的目录流 `dir`"）与英文不同而互换，内容本身逐字一致，仅顺序 warning。
- `#87`（fs.rst:493）：链接文本 `here` 译为 `此处`（STYLE_GUIDE §2「链接文本可译」），URL 逐字保留。

进度保存：按批次 prompt 要求，138 条分 8 个批次用编辑工具写回，未攒批一次性写入。

## 2. 新术语提议（未收录术语 + 建议译名 + 理由）

以下术语本次文件内使用且 glossary.md 未收录，建议批次收尾时裁决入库：

| 英文术语 | 建议译名 | 理由 / 出现位置 |
|---|---|---|
| directory stream | 目录流 | uv_fs_opendir/readdir/closedir 核心概念，与 stream→流 一致 |
| directory entry | 目录项 | scandir/readdir/uv_dirent_t 语境通行译法（dirent = directory entry） |
| null terminated string | 以空字符结尾的字符串 | mkdtemp/mkstemp 描述；通行译法 |
| junction point | 联接点 | Windows NTFS 术语，微软官方中文用「联接」（fs.rst:464） |
| copy-on-write reflink | 写时复制的 reflink | reflink 为 btrfs 特有行话，保留英文（对齐 §4 不译清单惯例） |
| controlling terminal | 控制终端 | POSIX 术语（O_NOCTTY），通行译法 |
| drive letter | 盘符 | Windows 通行译法（fs.rst:487） |
| Volume Manager | 卷管理器 | Windows 组件名通行译法（fs.rst:485） |
| ramdisk volume | ramdisk 卷 | ramdisk 暂保留英文；如需全译可作「内存盘卷」，请裁决 |
| sub-second precision | 亚秒精度 | fs.rst:448（上游拼作 precission，见 §4） |
| man page | 手册页 | getdents(2) 引用处通行译法 |
| C runtime | C 运行时 | uv_get_osfhandle / uv_open_osfhandle 段 |
| OS-dependent handle | 与操作系统相关的句柄 | 同上段；亦作「操作系统相关的句柄」 |
| exclusive lock | 独占锁 | UV_FS_O_EXLOCK；与 mutex→互斥锁 区分 |
| metadata | 元数据 | O_DSYNC / O_SYNC 描述，通行译法 |
| append mode | 追加模式 | O_APPEND，通行译法 |
| file caching | 文件缓存 | O_RANDOM / O_SEQUENTIAL 提示语境（注意与 buffer→缓冲区 区分） |
| corner case | 边缘情况 | realpath 警告段 |
| fallback | 回退 | io_uring 段、FICLONE 段（libuv 行为描述惯用） |
| nanosecond resolution | 纳秒精度 | uv_timespec_t 描述；「分辨率/精度」二者取「精度」更自然 |
| Y2K38 | Y2K38（保留） | 2038 年问题缩写，无通行中文缩写，保留原文 |
| entry（entries read from the stream） | 目录项 | uv_fs_readdir 返回值描述，与 directory entry 统一 |

另：章节标题 "API" 保留英文不译（通行缩写，且与全库其他文件标题习惯一致，请裁决是否统一）。

## 3. 采纳 neverwin 旧译文条目清单

无。fs.po 初始状态为全空 msgstr（无历史译文），本批全部为新译，未整段采纳任何旧译文。

## 4. 存疑条目与处理方式

| 位置 | 原文 | 疑点 / 处理 |
|---|---|---|
| fs.rst:448 | "sub-second precission is supported on Windows" | 上游拼写错误（precission → precision）。msgid 不可改，译文按正确含义译「Windows 上支持亚秒精度」；建议向上游报 typo |
| fs.rst:507 | "implemented uv_fs_lchown" | versionchanged 短句无句号、无大写，为上游笔记式原文；译「实现了 uv_fs_lchown」保持无句号、信息不增不减 |
| fs.rst:168 | "streaming directory iteration" | glossary 禁用「流式」（针对 stream 误译），本批改译「以流方式遍历目录」规避黑名单；语义等价，请裁决是否正式定名 |
| fs.rst:417 | "Limited equivalent to :man:`sendfile(2)`." | "limited" 修饰等价关系，直译「有限的等价物」生硬；译「等价于 :man:`sendfile(2)`，但功能受限」，语义等价 |
| fs.rst:485-488 | realpath Windows 警告段（ramdisk、subst'd drives、casing） | Windows 特有概念：subst 为命令名保留，"subst'd drives" 译「经 subst 映射的驱动器」；"Resolved path" 译「解析出的路径」 |
| fs.rst:480 | "macOS and other BSDs" | BSDs 复数指各 BSD 系统；译「macOS 及其他 BSD」 |
| fs.rst:36 | "Y2K38-unsafe data type" | 无通行中文；译「不具备 Y2K38 安全性」，Y2K38 保留，避免增译「（2038 年问题）」括注 |
| fs.rst:196 | "FS request type." | FS 为 file system 缩写，为与条目 "File system request type."（同一文件两处共享 msgid）术语一致，统一译「文件系统请求类型」 |
| fs.rst:315 | "an integer >= 0" | 不等式为代码语义，保留 ASCII ">= 0" 不译 |
| fs.rst:237 | "the O_BINARY and O_TEXT flags" | msgid 中 O_BINARY/O_TEXT 无反引号（上游未加标记），译文同样以纯文本保留，未擅自加标记 |

## 5. 硬性禁区遵守情况

- 仅填写 msgstr；msgid、位置注释（# 行）、文件头均未改动。
- `uv_*` / `UV_*` / errno / 打开标志（O_RDONLY、O_CREAT、O_EXCL 等）/ 文件名 / URL / role 括注 C 标识符逐字保留（term_check 0 error 佐证）。
- 未增删段落、未合并拆分条目、未重排顺序；无繁体/日文汉字变体。
- 未运行 gen_workdir / merge_po / init_po / validate_po.sh；未做任何 git 操作；未触碰任务外其他 po 文件。
- msgstr 无行尾空格；`::` 结尾条目本文件无（无需处理）；引号统一中文弯引号。
