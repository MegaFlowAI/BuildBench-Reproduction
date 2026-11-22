# 冻结用例发布与验收

1. 从官方开发集取每例的 `case.json`、`README.md`、`source/input`、`checksums` 和参考日志（`logs/target-failure.log`）；对照源文件哈希，再从服务器冻结池补齐 `config`、`manifest.json` 和逐包 SHA256。
2. 每例打包上传到同一个 GitHub Release（`frozen-cases-v1`），仓库保存可读元数据和资产的大小、SHA256、运行时版本。
3. 构建使用已校验的冻结材料和匹配架构的运行时：ARM64 目标用比赛官方 arm64 validator 镜像，x86_64 目标用官方 amd64 镜像加本地补丁的 shim。参考日志只由工作流读取，构建进程只收到源码、配置和冻结依赖。
4. 验收标准不是逐字节一致：重放必须真的进入包构建并失败；官方 `target-failure.log` 里的失败诊断必须全部出现；关键阶段（构建根准备、依赖安装、源码解包、构建开始、构建失败）必须齐全；重放日志行数至少达到官方日志的 15%。判定结果写在 `baseline-verdict.json`。

日常入口只有 **Actions → 原始构建与补丁验证**：`selection` 填一个或多个 case ID（英文逗号分隔），可选 `patch_pr` 填公开 PR 编号。补丁创建与提交流程见仓库 README。

[补回的历史依赖](../cases/recovered-packages.json)列出 Release 中额外发布的 ARM64 `libjpeg-dev` 历史包、原始下载地址、SHA256 和所涉及的 9 个用例。

[受损依赖修复清单](../cases/integrity-repairs.json)记录冻结池里被截断的 21 个包及对应的同版本原始下载。工作流校验归档和旧文件的 SHA256 后，在临时构建目录换成已校验的完整包，再更新该次构建的依赖锁；实际应用的修复写入作业附件的 `dependency-repairs.json`。

## Git 树和 Release 资产

Git 树中的 `cases/<方向>/<case-id>` 保留可审查的元数据，包括 `case.json`、`README.md`、`manifest.json`、`config/`、`checksums/` 和归档的 `asset.json`。源码和依赖文件不通过 Git blob 分发。

每个用例的完整 Release 资产使用相同的 case ID 命名。解包后的结构是：

```text
<case-id>/
├── case.json
├── README.md
├── manifest.json
├── checksums/
│   ├── source-input.sha256.json
│   └── frozen-environment.json
├── config/
│   ├── *-buildconfig
│   └── dependency-lock.json
├── logs/target-failure.log
├── source/input/                 # 官方 .dsc、debian.tar、orig.tar 和补丁输入
└── dependencies/                 # dependency-lock.json 列出的实际 .deb
    ├── ubuntu-<series>-<arch>/
    └── ubuntu-<series>-all/
```

`frozen-environment.json` 是来源摘要，不替代实际依赖。每个锁定包的文件名、版本、架构和 SHA256 在 `dependency-lock.json` 中，包本体在同一 Release 资产的 `dependencies/` 中。工作流会先核验归档 SHA256，再逐个核验源码和包的 SHA256。

完整资产下载示例：

```bash
gh release download frozen-cases-v1 \
  -R MegaFlowAI/BuildBench-Reproduction \
  -p 'launchpad-noble-amd64-arm64-ectrans-50e45e72102d.tar.zst'
```
