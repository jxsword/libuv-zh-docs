# 会话交接文档（handoff-latest）

> 更新: 2026-11-18 ｜ 里程碑: **P0 完成**（脚手架全就位，占位站上线）｜ 下一批: P1（入门 12 文件，509 条 msgid）
> 本文件是每批次收尾更新的唯一交接入口；新会话开工前**必读**本文件 + 计划 §5/§7。

## 1. 已完成清单（P0 全部 10 步）

| # | 事项 | 证据 |
|---|---|---|
| 1 | git init（main）+ 骨架 + .gitignore | commit 27a1f81 |
| 2 | v1.53.0 快照（docs/ 全部 42 rst + include/uv/version.h） | commit 55169dc；gh api 直连成功（未用代理） |
| 3 | gen_workdir.sh（镜像布局 + overlay + 安全补丁幂等套用） | workdir 自检全过；overlay 已验证 |
| 4 | venv 3.14.4 + requirements-zh.txt（上游全 pin + sphinx-intl 2.4.0 + jieba 0.42.1） | pip 全精确 pin；gettext 0.23.2 系统已装（未提权） |
| 5 | 英文构建冒烟 | exit=0；基线 11 warning + **2 条上游存量 error** 入 reports/warning-baseline-v1.53.0.{txt,raw.log} |
| 6 | pot 抽取 + po 初始化 | 42 pot / **1728 msgid**；43 po（42 + sphinx.po 占位）头部规范化，msgfmt -c 全过 |
| 7 | glossary.md（43 术语 + 48 错误译法 + 39 词机器黑名单）+ STYLE_GUIDE.md（§5 全 7 条规则） | commit 98c9f29 |
| 8 | scripts 全套 10 件 + 3 workflow | 校验器实测 0 error；upstream-watch 实测 success（无 issue） |
| 9 | 远程仓库 jxsword/libuv-zh-docs + push + Pages | https://jxsword.github.io/libuv-zh-docs/ **HTTP 200**（2026-11-18 实测，直连） |
| 10 | README（TASL + 免责声明）+ LICENSE（CC BY 4.0 官方全文）+ handoff | commit 98c9f29 / c9fbae4 |

## 2. 状态快照

- 分支 main，最新 commit **c9fbae4**，远程 origin=git@github.com:jxsword/libuv-zh-docs.git（SSH 通道可用）。
- 基线 v1.53.0（DR-004）；上游 watch 已启用（每周一 03:00 UTC cron + 实测通过）。
- 翻译进度 **0 / 1728**（reports/progress.md）；fuzzy=0；所有 po 空（占位站 = 英文内容 + 中文标题）。
- Pages: build_type=workflow，pages.yml 实测构建成功（48s，含 gettext 补装修复 c9fbae4）。
- 全链路已实证：po → msgfmt → .mo → sphinx zh_CN → HTML 中文渲染 + jieba 中文搜索索引（测试译文回滚，占位站干净）。
- 收尾验证: reports/p0-final-verification.md（stat 门禁 exit 1 = P0 预期；fuzzy/markup/term/构建增量门禁全绿）。

## 3. P1 入口（下一批，中文站首发）

- 范围（计划 §7，msgid 已实测）: index 22 / design 58 / guide 2 / guide/about 5 / guide/introduction 16 / guide/basics 41 / guide/eventloops 9 / guide/networking 58 / guide/filesystem 61 / guide/processes 81 / guide/threads 67 / guide/utilities 89 = **509 条**。
- 入口动作: `scripts/agent_prompt_template.md` 生成每文件 prompt → agent 逐文件翻译（不同 po 可并行 3–5，同 po 内分段严禁并发写）→ `msgfmt -c` 自检 → `scripts/validate_po.sh <文件...>` 批次模式门禁 → 批次报告入 reports/ → 分支 PR（pr.yml 自动跑门禁）→ squash merge → Pages 自动发布中文站。
- 验收（计划 §5）: 抽检 ≥10% 语义准确 + 术语 0 违规 + fuzzy=0 + 零新增 error/warning（对照基线）+ linkcheck。

## 4. 坑位与经验（P0 实战沉淀）

1. **re.sub 替换模板会把 `\n` 解析成真实换行**（init_po.sh 踩坑修复）——替换串一律经 lambda 传入。
2. **babel 拒绝 `YEAR-MO-DA HO:MI+ZONE` 日期占位符**（sphinx-intl stat 直接 ValueError）——po 头日期必须是真实值。
3. **msgfmt 无 `-o` 时会在 CWD 落 messages.mo**——统计一律加 `-o /dev/null`；`.mo` 已入 .gitignore。
4. **GitHub runner（ubuntu-latest）无预装 gettext**——pages.yml / pr.yml 均已显式 `apt-get install gettext`。
5. **上游 rst 自带 2 条 docutils ERROR**（misc.rst:906 code-block、tcp.rst:112 缩进）+ 11 条 warning，均入基线；门禁语义 = **零新增**（R1-8），validate_po.sh 已按此实现。
6. **Mimosa 安全门禁强制拦截 SSTI 模式**：上游 sphinx-plugins 插件已做等价加固（string.Template → str.replace），偏离登记于文件头 + scripts/patches/manpage-security.patch（双向 dry-run 验证）；**未来 sync 重下快照后必须重新套用该补丁**。
7. 本机 Mimosa hook 会拦截命令文本中出现源文件字面路径（.py/.h）的 Bash 调用——写源文件一律走 Write/Edit 工具；机器生成 diff 用 `git diff --no-index` 输出重定向到 .patch。
8. sphinx.po 为 0 条目占位：Sphinx 内置 zh_CN UI .mo 已生效；furo 主题个别 UI 词（如 "Contents"）仍英文——furo 自身语言包覆盖范围，P1 首发后观察决定是否补覆盖。
9. guide 行号警告里的 `filesystem.rst.rst`/`threads.rst.rst` 双后缀是 Sphinx literalinclude 行号警告的显示怪癖，实际文件名正常。

## 5. 硬性纪律（下会话开工前重申）

- 一切以计划文档为准；改架构/目录/工具链属重大决策（决策矩阵 + 用户确认 + decision_log）。
- fuzzy 硬门禁：任何构建前 fuzzy=0；修订 fuzzy 必须先比对 `#|` 旧原文。
- workdir 布局不可变（src/ 与 code/ 同级、version.h 就位）；改动 gen_workdir.sh 后必须重跑英文冒烟。
- 网络：gh api / dist.libuv.org 直连优先，失败按代理 http://192.168.33.1:10808 回退一次；提权走 zcode-run。
- 初译期上游发版：只开 issue，不切基线（DR-004）。
- 每批次/每次 sync 一个 commit（分支 PR + squash merge）；批次收尾必更新本文件与 reports/progress.md。
