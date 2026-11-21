# BuildBench 双架构构建验证

这个公开仓库提供 BuildBench Development Cases v0.1 的构建实验。目录包含 ARM64 和 x86_64 各 100 例。每例记录目标架构、Ubuntu 发行版、历史依赖版本、快照时间、构建模式和并行度。[官方数据发布页](https://matrix.cstcloud.cn/build-bench/data-downloads.html)

## 公开复现进度

[逐例台账](docs/public-baselines.csv)记录 200 个用例和已匹配用例的公开作业链接。`diagnostic_match` 表示该次作业通过诊断比对，`diagnostic_match_rejudged` 表示用更新的判定器复核旧作业的原始日志后通过。`control_signature_match` 是使用预先定义诊断的两个补丁对照。`test_summary_match` 核对测试结果、失败用例及构建退出。`idle_timeout_match` 核对静默时长和终止前日志。`variant_match` 记录在特定实验条件下匹配的作业。`pending` 表示还没有足够的公开 runner 匹配证据。台账记录已观察到的匹配，复跑的稳定性需要继续验证。

## 运行原始构建

在 **Actions → BuildBench original and patched builds → Run workflow** 输入一个 case ID。还可选择 `pending`（交接时等待复现的 10 例）、`pilot`（另加两个对照）、`arm64`、`amd64` 、`unverified`（逐例台账中尚未核验）或 `all`。

Runner 按固定 SHA256 校验并提取官方源码归档，依照 `cases.json` 从 Ubuntu Snapshot 和 Launchpad 恢复历史包。Ubuntu Snapshot 提供校验值时验证包 SHA256。所有恢复出的包都检查 Debian 元数据并保存下载来源和 SHA256。容器安装完依赖后，逐项检查实际安装版本。

每次执行都会保留重新生成的完整 `baseline.log`、真实退出码、`baseline-result.json` 和可用的依赖来源证据。基线通过要求原始包进入构建、真实退出失败，并达到自动诊断匹配条件。全日志中的时间戳、系统信息和非诊断行仍可与官方日志存在差异。对于待复现用例，自动比对未通过的结果仍需逐例审核。历史日志明确记录静默超时时，构建会按对应阈值监控，并与终止前的历史日志尾部比较。目录中的历史状态来自此前的交接台账。

## 验证环境条件

可对 `cases.json` 中已有 `variants` 的用例启用工作流的 `variants` 选项。每组条件运行相同的官方源码和版本冻结依赖，单独记录结果。Docker 的 CPU、内存和文件描述符限额在构建容器内生效。实验变体只运行原始构建，补丁验证使用经复验的默认条件。

## 理解 Actions 的状态

| 原始包构建 | 历史日志比对 | Actions 结果 |
| --- | --- | --- |
| 非零退出，且命中历史的失败情景 | 匹配 | 绿色。仅运行基线时，作业完成复现目标 |
| 非零退出，报错阶段或诊断不同 | 未匹配 | 红色 |
| 退出 0 | 未复现历史失败 | 红色 |
| 依赖恢复、容器准备或源码解包失败 | 未取得目标构建的证据 | 红色 |

提交补丁时，绿色还要求补丁版退出 0 并生成目标架构的软件包。原始包退出码在 `baseline.exit`，比对结论在 `baseline-result.json`。静默超时用例还会保存实际静默时长和终止信号。

## 查看完整日志

打开一次 Actions 运行的 Summary，在底部 Artifacts 下载 `evidence-<case-id>`。条件变体的附件名还带变体后缀。目前附件保留 7 天。

- `baseline.log` 保存原始构建，`baseline-attempt-*.log` 保存重试输出。
- `patched.log` 保存补丁验证。基线比对通过后才会执行补丁构建。
- `environment.log` 保存冻结依赖镜像的构建输出，`baseline-result.json` 记录判定结果。

手动运行工作流时勾选 `live_logs`，展开对应构建任务的步骤即可看到实时编译和测试输出。实时日志可能受 GitHub 的显示限制，完整文本可在任务结束后下载。

```bash
gh run download RUN_ID -R MegaFlowAI/BuildBench-Reproduction -n 'evidence-CASE_ID' -D evidence
```

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
- x86_64 的 `globalplatform` 原始构建退出 2，匹配三条 `__wrap_RAND_bytes` 链接错误。补丁保留 LTO 和原有测试，运行 5 项 CTest 后退出 0，生成 4 个 amd64 `.deb`。[补丁 PR](https://github.com/MegaFlowAI/BuildBench-Reproduction/pull/2) · [验证作业](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44872561219/job/136752128831)
- 交接时待复现的 10 例也已在公开 runner 调度。CI 保留原样构建成功、诊断差异及环境失败的结果，由各用例的日志指出实际停留阶段。[优先批次](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44854932430)

补丁验证沿用比赛将修改应用到干净源码并检查构建产物的思路。比赛的正式提交是可运行的修复 Agent，当前仓库的输入是单例补丁。[比赛规则](https://matrix.cstcloud.cn/build-bench/rules.html)
