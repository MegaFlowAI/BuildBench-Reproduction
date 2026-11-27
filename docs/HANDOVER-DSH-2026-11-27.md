# BuildBench / LangGraph 交接文档

更新时间：2026-11-27（Asia/Singapore）  
交接对象：DSH  
公开仓库：<https://github.com/MegaFlowAI/BuildBench-Reproduction>  
实验仓库：`MegaFlowAI/BuildBenchChallenge`

## 当前目标

围绕 `launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e` 做一次完整实验：

1. 在公开 GitHub Actions 上确认原始源码包会失败，并且失败诊断和比赛方的 `target-failure.log` 对齐。
2. 检查 Launchpad Bug 2169223 是否能为错误定位提供有效上下文。
3. 把 Bug 报告作为用户上下文交给服务器上的 LangGraph ReAct Agent，让模型生成源码补丁。
4. 通过公开仓库的补丁 PR 验证补丁后的目标架构构建。
5. 对跨架构案例增加源架构编译检查。这个例子是 `aarch64 → x86_64`，所以补丁验证应同时检查 x86_64 和 aarch64。

## 已确认的证据

### Launchpad 报告

报告地址：<https://bugs.launchpad.net/ubuntu/+source/taffybar/+bug/2169223>

已在服务器上通过 HTTP 抓取并保存摘要到 `/tmp/bug-2169223.md`。报告讨论的是 `taffybar`，不是 `haskell-config-value`，所以它属于相关技术上下文，不是本例的历史证据。报告指出：

- Ubuntu 的 LTO 构建参数会通过 `hlibrary.mk` 传给 GHC 链接阶段。
- amd64 Haddock 阶段出现 `R_X86_64_PC32` relocation 错误，根因与 `-fPIC`、`-flto=auto`、`-ffat-lto-objects` 的组合有关。
- 报告建议对受影响包关闭 LTO，并去掉 `-fllvm` 相关 workaround。

服务器上已有 `experiments/fault-patterns/patterns.json` 条目，把 Bug 2169223 关联到 `taffybar` case。它没有证明 2169223 就是 `haskell-config-value` 的同一个 bug。模型使用它做类比时，必须仍以本例冻结源码和官方失败日志为准。

### GitHub Actions 原始基线

本例在公开仓库中已经有一次成功的基线记录：

- Run：<https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44874513720>
- 台账：`docs/public-baselines.csv`
- 状态：`diagnostic_match`
- 这次运行在目标 x86_64 runner 上使用发布的冻结 case bundle、冻结依赖和 validator，官方诊断全部覆盖。

这证明公开仓库的原始构建入口已经能复现本例的失败情景。完整日志在对应 Actions job 的 artifact 中查看，不能只看 job 的成功或失败标志。

### LangGraph Agent 生成的补丁

服务器环境：

- 项目：`buildbench-langgraph`
- 模型服务：`http://127.0.0.1:28080/v1`
- 模型：`deepseek-v4.1-flash`
- 运行时：`/data/home/liuzhaofeng/lg-trace-venv/bin/python`
- 上下文文件：`/tmp/bug-2169223.md`

本次带 Bug 上下文的运行目录：

`/data/home/liuzhaofeng/GitHub/BuildBenchChallenge/runs/langgraph/haskell-config-value-bug2169223-20261127T1/launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e/`

结果文件：`result.json`  生成补丁：`agent.diff.patch`  
LangSmith 根 trace：`01a21b5c-a65c-74dd-bf40-e7d3738285a1`

模型生成的补丁在 `debian/rules` 中加入：

```make
# GHC's linker cannot handle the LTO flags injected by dpkg-buildflags on
# amd64 (R_X86_64_PC32 relocations overflow); strip them for this package.
export DEB_LDFLAGS_MAINT_STRIP = -flto=auto -ffat-lto-objects
```

服务器上的 Agent 实验完成了 source repack，`result.json` 状态为 `repaired+repacked`，修改文件只有 `debian/rules`。这只是模型输出和 source repack 证据，最终是否能通过公开 validator 要看 Actions 结果。

## 当前 PR 与提交

PR：<https://github.com/MegaFlowAI/BuildBench-Reproduction/pull/3>  
分支：`patch/haskell-config-value-bug2169223`  
当前分支头：`d7dbd0b`

提交顺序：

- `06f52e7`：加入模型生成的 `submissions/<case-id>/change.patch`。
- `0404197`：修复补丁整理脚本的硬链接污染。
- `d7dbd0b`：增加源架构编译检查和对应 workflow 矩阵。

第一次补丁验证 Run：<https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/45954686208>

结果是失败，但失败发生在补丁应用后的 source repack 阶段，不是模型补丁的编译结论。日志显示 `apply_submission_patch.py` 用硬链接复制解包后的源码，应用补丁时把 `pristine` 副本一起改掉，后续 `dpkg-source -b` 把补丁识别成 reversed patch。`0404197` 已改为独立文件复制，解决了这个具体问题。该 Run 使用的是修复前的提交，不能作为补丁失败结论。

## 已实现的双架构检查

`d7dbd0b` 在公开仓库中完成了以下改动：

- `scripts/select_cases.py` 从 case 的 `case.json` 读取 `source_arch`，为跨架构 case 生成第二个 source runner 矩阵。
- `scripts/frozen_release.py` 增加 `fetch-bundle`，源架构 job 只下载并解包源码 bundle，不加载目标架构 runtime image。
- 新增 `scripts/run_source_arch.sh`。它在 source runner 上解包 `.dsc`、应用 PR 补丁、用 runner 当前发行版仓库解析 Build-Depends，然后执行 `dpkg-buildpackage` 并检查目标架构 `.deb`。
- `.github/workflows/reproduce.yml` 增加 `source-arch` job。它只在补丁 PR 且 case 存在不同 source/target 架构时运行。

源架构检查使用 GitHub runner 当前的原生仓库依赖，并设置 `DEB_BUILD_OPTIONS=nocheck` 以聚焦编译和打包。它不是历史 Kinetic 冻结环境的第二份精确复现，目标架构 job 仍然负责冻结环境下的正式基线闸门和补丁验证。源架构 job 的首次实际结果仍待运行确认。

本地已验证：

- `python scripts/select_cases.py launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e` 输出目标 `ubuntu-24.04` 和源 `ubuntu-24.04-arm` 两个矩阵。
- `python -m py_compile scripts/select_cases.py scripts/frozen_release.py` 通过。
- 当前工作树干净，未提交文件为零。

## DSH 下一步

### 1. 用最新 PR 分支运行双架构补丁验证

因为 workflow 改动还在 PR 分支，dispatch 时要把 `ref` 指向 PR 分支，并继续把 `patch_pr` 设为 `3`。仓库当前没有可用的 `gh` CLI 登录，使用 GitHub REST API。请求体：

```json
{
  "ref": "patch/haskell-config-value-bug2169223",
  "inputs": {
    "selection": "launchpad-kinetic-arm64-amd64-haskell-config-value-4e922fd0713e",
    "patch_pr": "3"
  }
}
```

接口：

`POST https://api.github.com/repos/MegaFlowAI/BuildBench-Reproduction/actions/workflows/reproduce.yml/dispatches`

需要观察两个 job：

- `build (...)`：x86_64 冻结环境。应先看到 `status: matched`，随后 source repack 成功，最后 patched build exit 0 并产生 amd64 `.deb`。
- `source-arch (...)`：aarch64 runner。应通过补丁应用、Build-Depends 安装、`dpkg-buildpackage`，并产生 arm64 或 `all` `.deb`。

如果 source job 因当前 Ubuntu 仓库缺少旧版 GHC 或精确版本依赖失败，应保留完整 artifact 日志，并在结论中标记为“源架构当前仓库可见性不足”，不能把它写成历史环境失败。

### 2. 如果双架构 job 失败，按阶段排查

- `fetch-bundle` 失败：检查 Release asset 是否可下载，case bundle 是否仍与 `asset.json` SHA256 一致。
- `git apply` 失败：检查 PR 3 中 `change.patch` 的路径是否仍是 `debian/rules`，以及 patch 是否被重复应用。
- `dpkg-source -b` 失败：优先检查 source tree 是否再次出现硬链接，确认使用 `shutil.copytree(..., copy_function=shutil.copy2)` 的 `0404197`。
- x86 基线不匹配：先看 `baseline-verdict.json` 和 `build-output/build.log`，确认是否误用了 PR 分支中的 case/config 文件。
- ARM 编译失败：查看 `source-arch-build.log` 中 `mk-build-deps` 的缺失包和 GHC 版本，不要修改冻结 bundle 来掩盖差异。

### 3. 通过后再更新主分支台账

补丁 PR 通过两个架构 job 后，记录：

- Actions run URL、两个 job URL、artifact 名称。
- x86 基线的 `reference_lines`、`replay_lines`、`missing_diagnostics`、`extra_diagnostics`。
- x86 patched build 的 `build_exit_code` 和 binary package 路径。
- ARM source-arch build 的退出码、GHC 版本、生成的 `.deb` 架构。

再决定是否把 PR 合入 `main`。当前 PR 仍是开放状态，未合并。

## 运行环境与约束

- 服务器源码目录：`/data/home/liuzhaofeng/GitHub/BuildBenchChallenge`
- 公开仓库本地 clone：`C:\Users\liu_z\Documents\Codex\BuildBench-Reproduction`
- 3090 服务器 SSH 按项目 `AGENTS.md` 中的配置连接。
- LangSmith 发送逻辑仍保留。历史 DeepAgents 代码和本地旧 trace 文件已清理，不能为了本实验关闭 LangSmith tracing。
- 不要把 GitHub token、LangSmith key 或 OBS 密码写入仓库和交接文档。
- 公开仓库只保存业务逻辑、case metadata、校验信息和 release asset 引用，源码输入和冻结依赖从经过 SHA256 校验的 Release bundle 获取。
