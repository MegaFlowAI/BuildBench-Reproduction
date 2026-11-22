# 冻结用例发布与验收

1. 从官方开发集取每例的 `case.json`、`README.md`、`source/input`、`checksums` 和参考日志（`logs/target-failure.log`）；对照源文件哈希，再从服务器冻结池补齐 `config`、`manifest.json` 和逐包 SHA256。
2. 每例打包上传到同一个 GitHub Release（`frozen-cases-v1`），仓库保存可读元数据和资产的大小、SHA256、运行时版本。
3. 构建使用已校验的冻结材料和匹配架构的运行时：ARM64 目标用比赛官方 arm64 validator 镜像，x86_64 目标用官方 amd64 镜像加本地补丁的 shim。参考日志只由工作流读取，构建进程只收到源码、配置和冻结依赖。
4. 验收标准不是逐字节一致：重放必须真的进入包构建并失败；官方 `target-failure.log` 里的失败诊断必须全部出现；关键阶段（构建根准备、依赖安装、源码解包、构建开始、构建失败）必须齐全；重放日志行数至少达到官方日志的 15%。

**job 状态跟软件构建结果一致**：这批 case 的历史结局就是构建失败，所以无补丁跑原始构建时 job 是红色（预期）；只有「补丁构建成功」才是绿色。复现是否匹配不在 CI 里判定，下载 artifact 里的 `build.log` 后在本地跑 `scripts/compare_failure_log.py`。

日常入口只有 **Actions → 原始构建与补丁验证**：`selection` 填一个或多个 case ID（英文逗号分隔），可选 `patch_pr` 填公开 PR 编号。补丁创建与提交流程见仓库 README。

[补回的历史依赖](../cases/recovered-packages.json)列出 Release 中额外发布的 ARM64 `libjpeg-dev` 历史包、原始下载地址、SHA256 和所涉及的 9 个用例。

[受损依赖修复清单](../cases/integrity-repairs.json)记录冻结池里被截断的 21 个包及对应的同版本原始下载。工作流校验归档和旧文件的 SHA256 后，在临时构建目录换成已校验的完整包，再更新该次构建的依赖锁；实际应用的修复写入作业附件的 `dependency-repairs.json`。

## Git 树和 Release 资产

Git 树中的 `cases/<方向>/<case-id>` 与官方开发集保持一致：`case.json`、`README.md`、`checksums/`、`logs/`（官方参考日志，见下）和 `source/input/`（官方源码包）都在仓库里，另外还有本项目补充的 `manifest.json`、`config/` 和 `asset.json`。

例外：源码包里有 5 个文件名包含 `:`（Debian epoch，例如 `fenics-dolfinx_1:0.6.0-4_1:0.6.0-5.diff.gz`），Windows 文件系统不允许这种文件名，直接放 Git 会让 Windows 上无法 clone。因此这 5 个文件打包在 `cases/source-epoch-files.tar.gz`，清单和 SHA256 见 `cases/source-epoch-files.json`（Linux/Actions 上解包后与官方开发集完全一致）。

依赖 `.deb` 池太大（约 56GB），仍放在 Release 资产里；每个 case 的参考日志本来就在 Release 资产中，Git 里不重复存放（少数日志超过 GitHub 单文件 100MB 限制，例如 libyuv 的 2.3GB 日志）。

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

`frozen-environment.json` 是来源摘要，不替代实际依赖。`source/input/` 在 Git 树和 Release 资产中都存在（同一份官方源码，工作流会核对两边 SHA256）。每个锁定包的文件名、版本、架构和 SHA256 在 `dependency-lock.json` 中，包本体在同一 Release 资产的 `dependencies/` 中。工作流会先核验归档 SHA256，再逐个核验源码和包的 SHA256。

完整资产下载示例：

```bash
gh release download frozen-cases-v1 \
  -R MegaFlowAI/BuildBench-Reproduction \
  -p 'launchpad-noble-amd64-arm64-ectrans-50e45e72102d.tar.zst'
```
