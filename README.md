# BuildBench 双架构构建验证

这个公开仓库提供 BuildBench Development Cases v0.1 的构建实验。目录包含 ARM64 和 x86_64 各 100 例。每例记录目标架构、Ubuntu 发行版、历史依赖版本、快照时间、构建模式和并行度。[官方数据发布页](https://matrix.cstcloud.cn/build-bench/data-downloads.html)

## 运行原始构建

在 **Actions → BuildBench original and patched builds → Run workflow** 输入一个 case ID。还可选择 `pending`（交接时等待复现的 10 例）、`pilot`（另加两个对照）、`arm64`、`amd64` 或 `all`。

Runner 按固定 SHA256 校验并提取官方源码归档，依照 `cases.json` 从 Ubuntu Snapshot 和 Launchpad 恢复历史包。Ubuntu Snapshot 提供校验值时验证包 SHA256。所有恢复出的包都检查 Debian 元数据并保存下载来源和 SHA256。容器安装完依赖后，逐项检查实际安装版本。

每次执行都会保留重新生成的完整 `baseline.log`、真实退出码、`baseline-result.json` 和可用的依赖来源证据。基线通过要求原始包进入构建、真实退出失败，并达到自动诊断匹配条件。全日志中的时间戳、系统信息和非诊断行仍可与官方日志存在差异。对于待复现用例，自动比对未通过的结果仍需逐例审核。历史日志明确记录静默超时时，构建会按对应阈值监控，并与终止前的历史日志尾部比较。目录中的历史状态来自此前的交接台账。

## 验证环境条件

可对 `cases.json` 中已有 `variants` 的用例启用工作流的 `variants` 选项。每组条件运行相同的官方源码和版本冻结依赖，单独记录结果。Docker 的 CPU、内存和文件描述符限额在构建容器内生效。实验变体只运行原始构建，补丁验证使用经复验的默认条件。

## 提交补丁

1. 以 PR 提交 `submissions/<case-id>/change.patch`。此文件是相对于解包后的项目源码根目录的统一 diff，使用 `a/`、`b/` 路径前缀。PR 只允许改动所选用例的补丁文本。
2. 在默认分支上手动运行 workflow，填写该 case ID 和 PR 编号。也可以用 GitHub CLI。

```bash
gh workflow run reproduce.yml -R MegaFlowAI/BuildBench-Reproduction --ref main \
  -f selection=<case-id> -f patch_pr=<PR编号>
```

3. Actions 读取该 PR 的补丁文本，记录 PR 提交 SHA 和补丁 SHA256。基线通过后，使用同一个容器镜像和全新的源码目录应用补丁。补丁通过要求原始包构建命令退出 0 并产出至少一个属于目标架构或 `all` 的有效 `.deb`。日志见 `patched.log`，产物文件名见 `binary-packages.txt`。

Workflow 由维护者发起。构建时把 PR 内容作为补丁输入，容器禁用网络，以非特权用户运行。每次构建使用独立工作目录。公开 PR、构建日志和日志附件可被第三方读取，未公开的比赛提交请保留在私有工作区。

基线匹配证据目前使用关键诊断集合，两个试点对照使用指定的编译或链接诊断。不可从公开归档恢复的历史依赖、依赖配置失败、构建成功的基线、不同错误或无法提取历史诊断，均会阻止补丁验证。

公开仓库的标准托管 ARM64 和 x86_64 runner 无应计构建分钟数。GitHub 托管 job 仍有单次运行时间、并发和存储限制。[GitHub Actions 计费](https://docs.github.com/en/actions/concepts/billing-and-usage) · [系统限制](https://docs.github.com/en/actions/reference/limits)

## 已验证的试点

- ARM64 的 `golf` 命中历史 `-fcf-protection=full` 错误，原始构建退出 2。补丁限制该选项的使用架构，构建退出 0 并生成 `golf_601.4.32-1_arm64.deb`。[补丁 PR](https://github.com/MegaFlowAI/BuildBench-Reproduction/pull/1) · [验证作业](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44855366948)
- x86_64 的 `globalplatform` 原始构建退出 2，匹配了三条 `__wrap_RAND_bytes` 链接错误。[试点作业](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44854932430/job/136694832335)
- 交接时待复现的 10 例也已在公开 runner 调度。CI 保留原样构建成功、诊断差异及环境失败的结果，由各用例的日志指出实际停留阶段。[优先批次](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44854932430)

补丁验证沿用比赛将修改应用到干净源码并检查构建产物的思路。比赛的正式提交是可运行的修复 Agent，当前仓库的输入是单例补丁。[比赛规则](https://matrix.cstcloud.cn/build-bench/rules.html)
