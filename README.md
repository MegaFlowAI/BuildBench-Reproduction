# BuildBench 双架构构建验证

这个公开仓库提供 BuildBench Development Cases v0.1 的构建实验。目录包含 ARM64 和 x86_64 各 100 例。每例记录目标架构、Ubuntu 发行版、历史依赖版本、快照时间、构建模式和并行度。[官方数据发布页](https://matrix.cstcloud.cn/build-bench/data-downloads.html)

## 公开复现进度

[逐例台账](docs/public-baselines.csv)记录 200 个用例和已匹配用例的公开作业链接。`diagnostic_match` 表示该次作业通过诊断比对，`diagnostic_match_rejudged` 表示用更新的判定器复核旧作业的原始日志后通过。`control_signature_match` 是使用预先定义诊断的两个补丁对照。`test_summary_match` 核对测试结果、失败用例及构建退出。`idle_timeout_match` 核对静默时长和终止前日志。`variant_match` 记录在特定实验条件下匹配的作业。`pending` 表示还没有足够的公开 runner 匹配证据。台账记录已观察到的匹配，复跑的稳定性需要继续验证。

逐字节验收使用 [冻结用例工作流](docs/frozen-reproduction.md)。每例的清单、配置和校验值位于 [cases](cases)，源码、历史日志和依赖按用例发布到 [GitHub Release](https://github.com/MegaFlowAI/BuildBench-Reproduction/releases/tag/frozen-cases-v1)。

## 运行原始构建与补丁验证

在 **Actions → 原始构建与补丁验证 → Run workflow** 填写 `selection`（必填）：一个或多个 case ID，多个时用英文逗号分隔（逗号前后不要加空格）。单个示例：`launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e`。

每个 job 会：

1. 从 `frozen-cases-v1` Release 下载该 case 的冻结环境（官方源码、官方失败日志、历史依赖 `.deb`），并按大小与 SHA256 校验；
2. 加载目标架构对应的官方 validator 运行时镜像；
3. 用官方 validator（obs-build + chroot）完整重放原始构建，产出与官方同类的多阶段日志 `build.log`（包含 chroot 准备、依赖安装、`dpkg-buildpackage` 构建等阶段）；
4. 与官方 `target-failure.log` 比对：必须真正进入包构建并失败、官方日志里的失败诊断全部出现、关键阶段齐全、日志行数达到官方日志的至少 15%；
5. 如果填了 `patch_pr`，基线通过后再把 PR 中的 `change.patch` 应用到干净源码重新构建，要求构建成功并产出目标架构的 `.deb`。

## 环境条件

冻结用例自带 `runtime-settings.json`（CPU 等复现条件）和按官方失败日志锁定的历史依赖版本；运行时自动应用，不需要手动开关。依赖安装前会逐项校验锁文件与实际 `.deb` 的数量、架构和 SHA256。

## 理解 Actions 的状态

| 原始包构建 | 历史日志比对 | Actions 结果 |
| --- | --- | --- |
| 非零退出，且命中历史的失败情景 | 匹配 | 绿色。仅运行基线时，作业完成复现目标 |
| 非零退出，报错阶段或诊断不同 | 未匹配 | 红色 |
| 退出 0 | 未复现历史失败 | 红色 |
| 依赖恢复、容器准备或源码解包失败 | 未取得目标构建的证据 | 红色 |

提交补丁时，绿色还要求补丁版退出 0 并生成目标架构的软件包。原始包退出码在 `baseline.exit`，比对结论在 `baseline-result.json`。静默超时用例还会保存实际静默时长和终止信号。

## 查看日志

在 Actions 运行的底部 Artifacts 下载 `build-log-<case-id>`，里面只有完整构建日志：

- `build.log`：原始构建的完整多阶段日志（chroot 准备、依赖安装、构建等阶段）；
- 如果跑了补丁验证，还有 `patched-build.log`。

附件保留 7 天。比对结果不再上传，需要时在本地对日志跑 `scripts/compare_failure_log.py`。

## 提交补丁

### 1. 创建补丁文件

从 `main` 拉一个新分支（例如 `patch/<case-id>`），在仓库中添加：

```
submissions/<case-id>/change.patch
```

要求：

- 是针对**解包后的项目源码根目录**的统一 diff（`git diff` / `diff -u` 均可）；
- 路径使用 `a/`、`b/` 前缀（即 `git diff` 默认格式，`git apply -p1` 能直接应用）；
- 补丁只允许修改源码，不要包含提交产物（除非修复确实需要）；
- 单文件大小不超过 1 MB。

示例（以 haskell-config-value 为例）：

```bash
git checkout -b patch/launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e
mkdir -p submissions/launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e
# 在解包好的源码里改完后生成 diff，写入上面目录
git diff > submissions/launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e/change.patch
git add submissions/
git commit -m "patch: fix launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e"
git push origin patch/launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e
```

### 2. 发起 PR

向 `main` 发起 Pull Request，记下 PR 编号（PR 地址 `/pull/12` 中的 `12`）。PR 只应改动该 case 的 `change.patch`。

### 3. 在 Actions 里验证

到 **Actions → BuildBench 原始构建与补丁验证 → Run workflow**：

- `selection` 填该 case ID（只填一个）；
- `patch_pr` 填 PR 编号（只填数字）。

也可以用 GitHub CLI：

```bash
gh workflow run reproduce.yml -R MegaFlowAI/BuildBench-Reproduction --ref main \
  -f selection=launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e -f patch_pr=12
```

### 4. 判定规则与 job 状态

- **job 状态跟软件构建结果一致**：原始构建失败（这批历史失败 case 的正常结局）就是红色；只有「打了补丁且补丁构建成功」才是绿色。
- 复现是否匹配历史失败不再体现在 job 状态里，需要时在本地对下载的 `build.log` 跑 `scripts/compare_failure_log.py` 判断。
- Artifact 只上传 `build.log`（补丁模式另加 `patched-build.log`），不再上传比对 JSON 等中间产物。

### 4.1 判定规则

- 基线（未打补丁）：必须进入包构建并失败，官方失败诊断全部出现、关键阶段齐全（见 `baseline-verdict.json`）；否则直接判失败，不进入补丁阶段。
- 打补丁后：validator 退出码 0、`build-result.json` 的 status 为 `completed`，且 `artifacts` 非空（目标架构或 `all` 的 `.deb`）；摘要见 `patched-result.json`。
- 完整日志与证据见该 job 的 artifact（`evidence-<case-id>`）。

### 5. 安全与限制

Workflow 由维护者发起；构建时把 PR 内容只作为补丁输入，容器禁用网络，以非特权用户运行；每次构建使用独立工作目录。公开 PR、构建日志和附件可被第三方读取。

## 已验证的试点

- ARM64 的 `golf` 命中历史 `-fcf-protection=full` 错误，原始构建退出 2。补丁限制该选项的使用架构，构建退出 0 并生成 `golf_601.4.32-1_arm64.deb`。[补丁 PR](https://github.com/MegaFlowAI/BuildBench-Reproduction/pull/1) · [验证作业](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44855366948)
- x86_64 的 `globalplatform` 原始构建退出 2，匹配三条 `__wrap_RAND_bytes` 链接错误。补丁保留 LTO 和原有测试，运行 5 项 CTest 后退出 0，生成 4 个 amd64 `.deb`。[补丁 PR](https://github.com/MegaFlowAI/BuildBench-Reproduction/pull/2) · [验证作业](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44872561219/job/136752128831)
- 交接时待复现的 10 例也已在公开 runner 调度。CI 保留原样构建成功、诊断差异及环境失败的结果，由各用例的日志指出实际停留阶段。[优先批次](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44854932430)

补丁验证沿用比赛将修改应用到干净源码并检查构建产物的思路。比赛的正式提交是可运行的修复 Agent，当前仓库的输入是单例补丁。[比赛规则](https://matrix.cstcloud.cn/build-bench/rules.html)
