# libuv 中文文档（libuv-zh-docs）

libuv 官方文档的社区中文翻译，基于 gettext PO 工作流跟随上游持续增量更新。

- **在线阅读**: <https://jxsword.github.io/libuv-zh-docs/>
- **当前基线**: libuv v1.53.0（初译期锁定，见决策 DR-004；上游发新版会自动开 issue 记录，v1.0 全量发布后统一切换）
- **翻译资产**: [`locale/zh_CN/LC_MESSAGES/*.po`](locale/zh_CN/LC_MESSAGES/)（唯一翻译资产，站点由 Sphinx 构建自动发布）
- **仓库结构**: 见 [`docs/libuv-docs-zh-翻译计划.md`](docs/libuv-docs-zh-翻译计划.md) §4

> ⚠️ **非官方声明**：本项目为社区中文翻译，**非 libuv 官方项目**，与 libuv 官方无任何隶属关系。
> 中文内容仅供参考；如与官方英文文档有出入，**一律以官方英文文档为准**（[docs.libuv.org](https://docs.libuv.org/en/v1.x/)）。
> 译文问题欢迎[提 issue](https://github.com/jxsword/libuv-zh-docs/issues)。

## 参与翻译

翻译以 po 文件为单元、按批次推进（P1 入门 12 文件 → P2 核心 API 19 → P3 网络/进程/线程 8 → P4 收尾 3，共 42 文件 / 1728 条）。
流程、门禁与验收标准见翻译计划 §5；开工必读：

1. [`STYLE_GUIDE.md`](STYLE_GUIDE.md) —— 7 条硬性规则 + 标记保留细则
2. [`glossary.md`](glossary.md) —— 术语表（统一译名 / 禁用译名 / 错误描述惯用译法 / 不译清单）

每批次 PR 必须通过 `scripts/validate_po.sh` 全部门禁（msgfmt -c、fuzzy=0、标记对等、术语扫描、构建冒烟）。

## 版权与署名（TASL）

本项目译文基于 libuv 官方文档（CC BY 4.0 授权）翻译发布，按 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) 要求署名如下：

| 要素 | 内容 |
|---|---|
| **Title** | libuv documentation（对应上游 tag [v1.53.0](https://github.com/libuv/libuv/releases/tag/v1.53.0)） |
| **Author** | libuv contributors |
| **Source** | <https://docs.libuv.org/en/v1.x/> |
| **License** | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) |

- 译文许可: 本仓库译文以 [CC BY 4.0](LICENSE) 发布（与上游一致）。
- 上游代码: libuv 代码本身为 MIT 许可（与本文档仓库无关，仅译文相关）。
- 参考语料: 部分批次如采纳 [neverwin/libuv-docs-chinese](https://github.com/neverwin/libuv-docs-chinese)（CC BY 4.0，v1.26.0 旧译文）整段译文，将按批次报告在下方动态登记（P0 现状：无采纳）。

## 构建（本地复现）

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements-zh.txt
bash scripts/gen_workdir.sh        # upstream 快照 → workdir 镜像 + conf overlay
bash scripts/build_zh.sh           # po → .mo → 中文 HTML（workdir/docs/build/html）
```

详细工作流（pot 抽取 / po 合并 / 校验门禁 / 进度统计）见 `scripts/` 与翻译计划 §5–§6。
