# libuv 官方文档中文翻译计划

> 版本：v1.1（三轮复审修订版，2026-11-18）｜ 状态：待启动 P0
> 决策依据：DR-001（gettext PO 工作流）、DR-002（全量分批翻译）、DR-003（GitHub 公开仓库托管）、DR-004（初译期锁定基线），见 [decision_log.md](decision_log.md)
> 复审记录：v1.0 → v1.1 的全部修订依据见 §13（R1/R2/R3 共 26 项）

## 1. 目标与产出

将 libuv 官方文档（docs.libuv.org，Sphinx 源码位于 [libuv/libuv](https://github.com/libuv/libuv) `v1.x` 分支 `docs/`）翻译为中文：

- 产出 1：git 仓库 `libuv-zh-docs`，翻译资产以 **gettext PO 文件**管理，托管于 GitHub 公开仓库 `github.com/jxsword/libuv-zh-docs`（DR-003）；
- 产出 2：Sphinx 构建的中文 HTML 文档站，发布到 GitHub Pages：**https://jxsword.github.io/libuv-zh-docs/**；
- 产出 3：**增量同步机制**——初译期锁定基线（DR-004），全量完成后随上游 release 增量更新：仅翻译新增/变更段落，既有译文自动复用；
- 产出 4：术语表与风格指南，保证跨批次译文一致性。

上游现状（2026-11-18 实测核实）：

| 项目 | 事实 |
|---|---|
| 官方文档 | https://docs.libuv.org/en/v1.x/ 仅英文，无中文（Sphinx 7.0.1 + Furo 主题） |
| 最新版本 | v1.53.0（2026-09-24 发布，GitHub API 实测） |
| 文档源码 | [libuv/libuv](https://github.com/libuv/libuv) `v1.x` 分支 `docs/src/`，41 个 `.rst` 共约 296 KB |
| 文档许可证 | CC-BY-4.0（仓库根 `LICENSE-docs`）；代码 MIT。翻译发布合法，须署名 |
| 官方中文版 | 无。组织下亦无独立文档仓库（`libuv/api-docs` 2015 年已废弃） |

## 2. 既有翻译项目调研结论（先找轮子）

> 2026-11-18 经 GitHub API / curl 实测核实；Gitee API 搜索 `libuv 中文` 无结果。

| 项目 | 对象 | 许可证 | 活跃度 | 增量机制 | 结论 |
|---|---|---|---|---|---|
| [neverwin/libuv-docs-chinese](https://github.com/neverwin/libuv-docs-chinese)（[在线阅读](https://libuv-docs-chinese.readthedocs.io/zh/latest/)） | ✅ 官方 sphinx 文档 | CC-BY-4.0 | 8★，2019-02 停更（对应 v1.26.0，落后 27 个 minor） | ❌ 直译 rst，人工比对 | 唯一同对象项目；**作为未变更段落的译文参考语料**（CC-BY-4.0 兼容，署名即可复用） |
| [luohaha/Chinese-uvbook](https://github.com/luohaha/Chinese-uvbook) | ❌ 社区教程书 | ❌ 无 | 1530★，2022 停更 | ❌ | 仅作术语/行文风格参考，文本不可复用（无许可证） |
| [forhappy/uvbook](https://github.com/forhappy/uvbook) | ❌ 社区教程书 | ❌ 无 | 259★，2014 停更 | ❌ | 仅历史参考 |

**结论**：无可直接复用的现成项目与增量同步机制，需自建；可借鉴 neverwin 的「sphinx 镜像式仓库结构」与译文语料、上游 `docs/requirements.txt` 的构建版本 pin。

## 3. 总体架构（DR-001：gettext PO 工作流）

```
上游 rst 原文 ──make gettext(sphinx -b gettext)──▶ .pot 模板 ──sphinx-intl update──▶ locale/zh_CN/*.po（翻译发生地）
                                                    （babel 合并：未变 msgstr 自动保留，
                                                      变更条目自动标 fuzzy 并写 #| 旧原文）      │
                                                                                                ▼
                                                            sphinx 构建（language=zh_CN）──▶ 中文 HTML 站
```

选型理由：增量能力**原生**（babel 模糊匹配自动复用旧译文，精确变更清单）；业界成熟（pandas / numpy / scikit-learn 中文文档同路线）；校验工具链完善（`msgfmt -c` + `sphinx-intl stat` 可机器校验）；对 agent 翻译友好（结构化、逐条、无需处理 rst 排版）。

已实证的抽取行为（2026-11-18，Sphinx 7.0.1 源码级核实）：段落/标题/列表项/表格单元格文本均进 msgid（抽取单位为 TextElement）；**literal block（代码块）默认不抽取**（`gettext_additional_targets=[]`）；image alt 文本（Sphinx 4.0+）与 math_block 默认会被抽取。

弃用路线（详见 DR-001）：B（直译 rst + 段落哈希清单，自研同步工具长期维护成本高）、C（rst 转 Markdown，丢失 C-domain 交叉引用、转换漂移）。

## 4. 仓库结构与构建布局

```
libuv-zh-docs/
├── README.md                    # 项目说明、在线地址、署名四要素、免责声明
├── LICENSE                      # CC-BY-4.0（译文许可，与上游一致）
├── requirements-zh.txt          # 上游 requirements + sphinx-intl + jieba（P0 查证后 pin）
├── glossary.md                  # 术语表：英文术语 → 统一译名 → 首次出现章节 → 禁用译名
├── STYLE_GUIDE.md               # 翻译风格指南（agent 每批次必读，含 §5 全部硬性规则）
├── docs/
│   ├── decision_log.md          # 决策记录
│   ├── handoff-latest.md        # 会话交接文档（每批次收尾更新，§12）
│   ├── 新会话启动提示词.md        # 新会话可直接粘贴的启动提示词
│   └── libuv-docs-zh-翻译计划.md  # 本文件
├── upstream/
│   └── v1.53.0/
│       ├── docs/                # 上游文档快照（src/ code/ Makefile requirements.txt），按 tag 提交入库，只读
│       └── include/uv/version.h # ← 上游 conf.py::get_libuv_version() 读取此文件取版本号，快照必须包含
├── workdir/                     # gen_workdir.sh 生成 → .gitignore（不入库，可确定性重建）
│   ├── docs/                    # 上游 docs/ 完整镜像：src/ 与 code/ 同级（literalinclude ../../code 依赖此布局）
│   │   ├── src/…                # rst 原样复制；conf.py 尾部追加 overlay（见下）
│   │   ├── code/ …              # guide 示例代码（与 src/ 同级）
│   │   └── build/               # 构建输出（含 gettext 抽取产物）
│   └── include/uv/version.h
├── locale/
│   └── zh_CN/LC_MESSAGES/
│       ├── *.po                 # 与 rst 一一对应（41 个）+ sphinx.po（界面字符串）
├── scripts/
│   ├── gen_workdir.sh           # upstream 快照 → workdir 镜像 + conf.py overlay
│   ├── extract_pot.sh           # make -C workdir/docs gettext（复用上游 Makefile 目标）
│   ├── init_po.sh               # sphinx-intl update 首次生成空 po
│   ├── merge_po.sh              # sphinx-intl update（增量合并主工具，babel 行为见 §6）
│   ├── check_markup.py          # msgid ↔ msgstr 内联标记 token 对等校验（比 msgfmt -c 更强）
│   ├── validate_po.sh           # msgfmt -c + sphinx-intl stat + check_markup + 术语检查 + 构建冒烟
│   ├── build_zh.sh              # 构建中文 HTML（language=zh_CN 已在 overlay 固化）
│   ├── po_stats.sh              # 进度统计 → reports/progress.md（文件 × translated/fuzzy/untranslated）
│   ├── term_check.py            # 术语一致性扫描（po 中出现禁用译名即报错）
│   └── agent_prompt_template.md # 每批次 agent 统一 prompt 模板
├── reports/                     # 批次报告、sync 差异清单、progress.md
└── .github/workflows/
    ├── pages.yml                # push main → gen_workdir → build → deploy GitHub Pages
    ├── upstream-watch.yml       # 每周一 cron 查上游 latest release → 变更则自动开 issue
    └── pr.yml                   # PR 跑 validate_po.sh（防标记破坏）
```

**conf.py overlay**（gen_workdir.sh 追加到 workdir/docs/src/conf.py 尾部，Python 后行赋值覆盖前行）：

```python
# --- libuv-zh-docs overlay ---
language = 'zh_CN'
locale_dirs = ['../../../locale']   # 相对 conf.py 所在目录（workdir/docs/src/）→ 仓库根 locale/
gettext_compact = False             # 按 rst 文件拆分 pot/po
html_title = 'libuv documentation（中文翻译）'
```

**设计要点**：

- `upstream/` 快照提交入库（自包含、diff 可溯源、CI 无额外网络依赖）；快照范围 = 上游 `docs/` **全部** + `include/uv/version.h`——后者缺失时构建虽不崩（get_libuv_version 有 try/except 兜底返回 unknown），但站点版本号显示 unknown，不可接受。
- `workdir/` 镜像上游 `docs/` 内部布局（`src/` 与 `code/` 同级）：guide 各页 literalinclude 使用 `../../code/...` 相对路径，布局错位会导致全部示例代码断链。
- `workdir/` 不入 git（派生物易漂移），CI 与本地均由 `gen_workdir.sh` 确定性重建。
- 增量合并主工具为 `sphinx-intl update`（底层 babel Catalog.update）：精确匹配保留 msgstr、变更条目以 difflib cutoff 0.6 模糊匹配自动标 fuzzy 并写 `#|` 旧原文、obsolete 条目默认保留写出（`--no-obsolete` 可丢弃）；`sphinx-intl stat` 在存在 fuzzy/未翻译时退出码 1，用作构建门禁。msgmerge（阈值 ~0.8）仅作备选，不进主链路。
- 上游 Makefile 自带 `gettext` 与 `linkcheck` 目标，直接复用；上游 CI（CI-docs.yml）以 Python 3.14 跑 `make html + linkcheck`，不做部署——我们的 requirements 锁上游 pin，Python ≥3.11 即可。
- 构建依赖补充 **jieba**：Sphinx 内置 `sphinx.search.zh` 分词器在 `language=zh_CN` 时自动回退激活，但未安装 jieba 时中文内容完全不进搜索索引。
- 本机 `raw.githubusercontent.com` 直连失败（2026-11-18 实测）：快照下载一律走 `gh api`（认证通道）或 dist.libuv.org，失败按代理 `http://192.168.33.1:10808` 回退（对齐全局网络回退规则）。

## 5. 翻译工作流（agent 批次翻译）

**翻译单元**：1 个 po 文件 = 1 个 agent 任务（个别大文件如 `fs.rst` 超限时按 msgid 区间拆为顺序子任务——**同一 po 文件的多段任务严禁并发写**，不同 po 可并行 3–5 个 agent）。每文件预计 50–300 条 msgid（P0 抽取后出精确清单）。

**Agent 输入**（统一 prompt 模板 `scripts/agent_prompt_template.md`）：
1. 目标 po 文件路径；2. `glossary.md` + `STYLE_GUIDE.md`（强制全文遵守）；3. 上游对应 rst 原文路径（供上下文）；4. 批次报告输出路径（`reports/`）。

**Agent 硬性规则**：
1. 只填 `msgstr`，禁止改动 `msgid`、位置注释、文件头；
2. 内联标记原样保留：`:c:type:\`...\``、`:c:func:`、`:ref:`、`**…**`、`` `…` `` 等及其中括注的 C 标识符一律不译；
3. 函数 / 类型 / 宏 / 常量 / 文件名不译；literal block 默认不进 po；**例外：image alt 文本与 math_block 默认会被抽取**，alt 中若为装饰性内容可保持原样；
4. **fuzzy 处理**：对 `#, fuzzy` 条目必须先读 `#|` 保留的旧 msgid 与新 msgid 逐句比对，确认译文对齐新原文后修订 msgstr **并删除 fuzzy 标志**——fuzzy 条目在 msgfmt（默认不编译）与 Sphinx babel（`use_fuzzy=False`）两条编译路径下均不进 .mo，不清除则译文静默回退为英文；
5. 术语以 `glossary.md` 为准；中英文之间加空格、全角标点；
6. 语义等价，不增不减；对 neverwin 旧译文仅作参考重译，若整段采纳需在批次报告中登记（供署名）；
7. 完成后自跑 `msgfmt -c <file>.po` 必须零错误，且该文件 fuzzy 计数为 0。

**质检链**（每批次收尾）：`validate_po.sh`（msgfmt -c 全量 + `sphinx-intl stat`（fuzzy>0 退出码 1）+ `check_markup.py` 标记对等校验 + term_check 术语扫描 + 构建冒烟 + linkcheck）→ 第二个校对 agent 对照 msgid 抽查 + 处理告警 → 全部达标 → 批次报告落盘 → 分支 PR → squash merge 进 main。

**批次验收标准**（全部满足才算完成）：抽检 ≥10% 条目语义准确；术语违规 0；fuzzy=0；构建零 error 且增量 warning 清零（对照 P0 建立的上游 warning 基线）；linkcheck 通过。

**翻译引擎**：zcode agent（GLM）。可选加速项（P1 试点后决定）：先机器翻译预填 msgstr，再由 agent 逐条润色校对。

## 6. 增量同步流程（跟随官方更新）

**基线锁定策略（DR-004）**：初译期（P0–P4）**锁定基线 v1.53.0**。期间上游发新版：`upstream-watch.yml` 照常自动开 issue 记录，但**不切基线、不重抽 pot、不合并 po**；v1.0 全量发布后才切换到下一个 release，一次性处理增量。

**切换执行**：`scripts/sync_upstream.sh v1.54.0`（在独立分支执行；执行前对 `locale/` 全量快照备份，保证脚本幂等可重跑）
1. 下载 release tarball（dist.libuv.org 或 `gh api` tag archive；网络失败走代理回退，见 §4）；
2. 写入 `upstream/v1.54.0/`（docs/ + include/uv/version.h）并 commit；
3. `gen_workdir.sh` 重建 workdir；`make gettext` 重抽 pot；`sphinx-intl update` 全量合并 po——未变条目 msgstr 自动保留，变更条目（相似度 ≥0.6）自动标 fuzzy 并写 `#|` 旧原文，新增条目留空；
4. 生成 `reports/sync-v1.54.0.md`：新增 / fuzzy / obsolete 条目清单与统计；
5. agent 按 §5 流程补译（fuzzy 条目比对 `#|` 旧原文后修订并清除标志）→ `validate_po.sh` 门禁全绿 → PR → 合并 → Pages 自动发布；
6. obsolete（`#~`）条目默认保留供回溯，必要时以 `--no-obsolete` 或 msgattrib 清理（防 po 无限膨胀）。

**结构性变更**（文件改名 / 拆分）：脚本检测 po 与 rst 的对应断裂，尝试旧 po 重映射，无法映射的列入重译清单（低频事件，接受）。

**回滚预案**：po 是唯一翻译资产；每批次/每次 sync 一个 commit，引入大面积错误时 `git revert` 对应 commit 即可；`workdir/` 与构建产物不入库，可随时重建。

## 7. 范围与批次（DR-002：全量 41 文件，分 5 期）

| 期 | 内容 | 文件数 | 发布点 |
|---|---|---|---|
| **P0** | 脚手架：git init、目录与脚本、workdir 链路、pot 抽取与 po 初始化、术语表/风格指南初版、Pages 上线、远程仓库创建 | 0 | 站点骨架上线（英文占位） |
| **P1** | 入门：index、design、guide.rst、guide/about|introduction|basics|eventloops|networking|filesystem|processes|threads|utilities | 12 | **中文站首次发布** |
| **P2** | 核心 API：errors、version、loop、handle、request、timer、prepare、check、idle、async、poll、signal、fs、fs_event、fs_poll、dns、dll、metrics、misc（**errors.rst 优先**：错误码描述是高频引用文本，错误信息惯用译法先行入术语表） | 19 | 增量发布 |
| **P3** | 网络/进程/线程：stream、tcp、pipe、tty、udp、process、threading、threadpool | 8 | 增量发布 |
| **P4** | 收尾：freertos、api.rst、全文术语一致性 sweep、obsolete 清理、交叉校对复审 | 2 | **v1.0 全量发布**（此后进入随上游 release 的增量模式） |

合计 41 个 rst（12+19+8+2）。规模估算：约 296 KB 原文，非代码文本估 1500–2500 条 msgid（P0 抽取后出精确数并回填本节与 §11）。

## 8. 质量保障与风险

| 风险 | 对策 |
|---|---|
| 长 msgid（表格/列表/复杂结构）翻译破坏 rst 标记 | `msgfmt -c` + `check_markup.py` 标记对等校验 + 构建零 error 门禁 + 校对 agent 复查 |
| **fuzzy 译文静默不生效**（两条编译路径均默认排除 fuzzy） | fuzzy=0 硬门禁（`sphinx-intl stat` 退出码）；agent 规则 4 强制比对 `#|` 旧原文 |
| 上游 conf.py 依赖 `include/uv/version.h`，快照缺失导致版本号 unknown | 快照固定含 `include/uv/version.h`；gen_workdir 后先跑英文构建冒烟 |
| **初译中途上游发版**，基线漂移导致返工 | 基线锁定策略（DR-004）：P0–P4 不切基线，只开 issue 记录 |
| 术语跨批次漂移 | glossary 强制 + `term_check.py` 扫描禁用译名 + P4 全量 sweep |
| 上游 rst 结构性重组导致 po 失配 | 同步脚本检测与重映射（§6），无法映射列入重译 |
| 上游构建链升级改变抽取行为 | requirements 全 pin；同步时构建冒烟比对 msgid 总数 |
| neverwin 语料版本陈旧（v1.26.0） | 仅参考不整段拷贝；采纳需登记署名 |
| 本机网络限制（raw.githubusercontent 直连失败） | 脚本统一 gh api / dist 域名 + 代理回退（全局网络规则） |

## 9. 许可证与署名

- 译文以 **CC-BY-4.0** 发布（与上游一致）。README 与站点 footer 按四要素（TASL）署名：
  - Title: libuv documentation（对应上游 tag vX.Y.Z）
  - Author: libuv contributors
  - Source: https://docs.libuv.org/en/v1.x/（附上游 tag 链接）
  - License: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- **非官方声明**（README 头部 + 站点可见位置）：本项目为社区中文翻译，非 libuv 官方项目；如与官方英文文档有出入，以官方为准；译文问题请提 issue。
- po 文件头元数据规范化：`Project-Id-Version`（libuv docs vX.Y.Z）、`Language: zh_CN`、attribution 注释行；`init_po.sh` 生成后统一回填。
- 复用 neverwin 语料的批次：README 署名段追加 "部分译文参考 neverwin/libuv-docs-chinese (CC BY 4.0)"（按批次报告登记动态更新）。

## 10. P0 立即执行清单（等用户指令后启动）

1. `git init`（main 分支）+ 目录骨架 + `.gitignore`（`workdir/`、`build/`、`__pycache__/` 等）；
2. 获取 v1.53.0 快照入 `upstream/`（gh api tarball / tag archive；网络失败走代理回退），范围 = `docs/` 全部 + `include/uv/version.h`；
3. 编写并运行 `gen_workdir.sh` 生成 `workdir/`（镜像布局 + conf.py overlay，§4）；
4. 构建环境：python venv ≥3.11 + `requirements-zh.txt`（上游 pin + sphinx-intl + jieba，P0 查证最新稳定版后 pin）；系统 `gettext` 包经 zcode-run 包裹安装（`sudo apt` 需提权）；
5. 英文构建冒烟：`make -C workdir/docs html` 通过；记录上游 warning 基线清单；
6. `make -C workdir/docs gettext` 抽取 pot → 统计 msgid 精确数并回填 §7/§11 → `sphinx-intl update` 初始化 41+1 个 po（含文件头元数据回填）；
7. 编写 `glossary.md`（种子 ≈30 条，含错误信息惯用译法与 UV_E* 常量不译规则）与 `STYLE_GUIDE.md` 初版（含 §5 全部 agent 硬性规则）；
8. 编写 `scripts/` 全套（§4 清单）与 3 个 GitHub workflow；
9. 创建远程公开仓库 `jxsword/libuv-zh-docs`（DR-003 已确认公开托管）并 push，启用 GitHub Pages（Source: GitHub Actions），确认英文占位站可访问；
10. 更新 `docs/handoff-latest.md`；校对 README 署名四要素与免责声明（§9）。

P0 完成后跑全链路验证（占位站构建 + po_stats + stat 门禁），汇报后再进 P1。

## 11. 工作量与节奏估算（粗估，P0 精确化后回填）

- 翻译单元：1500–2500 条 msgid（41 文件，~296 KB 原文，非代码文本约 60%）。
- Agent 成本粗估：每条目翻译 + 校对两遍约 0.5–1.5k tokens（含上下文），**全量初译约 5M–15M tokens 量级**，仅供排期参考。
- 节奏：**每会话 1 个批次**（对齐 §12）；批内不同 po 文件 agent 并行 3–5 个，同文件分段串行。

## 12. 会话连续性与交接约定

- 每批次 / 每次 sync 收尾更新 `docs/handoff-latest.md`：已完成批次清单、当前基线 tag、下批次入口（文件清单 + po 状态）、坑位与经验、硬性纪律提醒。
- 上下文过半或遇里程碑（P0 / P1 首发 / v1.0）时，主动建议开新会话，并提供按「必读清单 → 状态快照 → 本次任务 → 硬性纪律」组织的启动提示词（模板见 [新会话启动提示词.md](新会话启动提示词.md)）。
- 未完成的半成品不入库：调试脚本、临时产物一律放 `workdir/`（已 gitignore）或 `/tmp/`。

## 13. 三轮复审记录（v1.0 → v1.1，2026-11-18）

**核实方式**：Explore 子代理核对 Sphinx 7.0.1 源码（gettext.py / nodes.py / search/zh.py）、GNU gettext 手册、sphinx-intl 文档与源码；直接抓取上游 `docs/Makefile`、`docs/src/conf.py`、`docs/src/guide/basics.rst`、`.github/workflows/CI-docs.yml` 原文。所有 URL 实测可达（WebFetch / webReader / gh api，2026-11-18）。

**R1 技术正确性（8 项，全部采纳）**：
- R1-1 🔴 快照缺 `include/uv/version.h`（上游 conf.py 启动即读取）→ §4 快照范围修正；
- R1-2 🔴 目录树 code/ 放 src/ 下，与 literalinclude `../../code/` 冲突 → §4 布局重设计（workdir 镜像）；
- R1-3 🟡 增量合并主工具定为 `sphinx-intl update`（babel：cutoff 0.6、自动 fuzzy + `#|`、stat 门禁），msgmerge（阈值 ~0.8）降为备选 → §3/§4/§6；
- R1-4 🟡 fuzzy 条目两条编译路径（msgfmt 默认、babel use_fuzzy=False）均不进 .mo → §5 规则 4、§8 门禁；
- R1-5 🟡 zh 搜索需 jieba（缺失则中文不入索引）→ §4 依赖；
- R1-6 🟢 image alt / math_block 默认被抽取的例外 → §3/§5；
- R1-7 🟢 复用上游 Makefile `gettext`/`linkcheck` 目标；上游 CI 用 Python 3.14 → §4；
- R1-8 🟢 构建 warning 门禁改为「零 error + 增量 warning 基线比对」（上游 conf 存在既有 warning）→ §5。

**R2 流程完备性（11 项，全部采纳）**：基线锁定策略（R2-1，DR-004）；同文件分段串行/跨文件并行 3–5（R2-2）；progress.md 进度看板（R2-3）；本地环境前置清单含 zcode-run 提权（R2-4）；obsolete 清理策略（R2-5）；分支 PR 策略（R2-6）；回滚预案（R2-7）；批次验收标准（R2-8）；errors.rst 优先 + 错误信息译法入术语表（R2-9）；sync 幂等（R2-10）；P0 清单更新（R2-11）。→ 分布于 §5/§6/§7/§10。

**R3 合规与长期维护（7 项，全部采纳）**：CC-BY-4.0 四要素署名模板（R3-1）；非官方免责声明 + 标题标识（R3-2）；po 文件头元数据规范（R3-3）；会话连续性约定与 handoff 文档（R3-4，§12）；成本估算 5M–15M tokens（R3-5，§11）；DR-003/DR-004 决策落盘（R3-6）；风险表新增 3 条（R3-7，§8）。→ 分布于 §9/§11/§12/§8。
