# BuildBench 公开复现仓库 — 交接给 Codex（2026-11-21，Jarvis）

> 仓库：<https://github.com/MegaFlowAI/BuildBench-Reproduction>（public，分支 `main`）
> 上一位交接：`docs/reproduce-200-handover-20261121.md`（Codex 原文档，190/200 为服务器侧带条件匹配）
> 本文记录 Jarvis 在 2026-11-21 11:00–13:40 的接手工作：全量 sweep、根因修复、env 条件落地、未完成项与下一步。

---

## 0. 一句话状态

公开仓库骨架可用、免费 ARM/x86 runner 可用；**裸跑基线通过率：x86 34/100、arm 63/100**（不含 Codex 服务器侧的 nofile/CPU/核数等特殊条件）。剩余失败已从「容器建不起来」收敛为「历史失败在 runner 上不复现（baseline_success）」和「诊断差异（diag_mismatch）」两类，需要下一阶段做**条件变体矩阵**和**逐例诊断对齐**。

## 1. 仓库结构（当前 main）

```
cases.json                 200 例 catalog（每例：architecture/suite/distribution/snapshot/
                           mode/jobs/options/packages/handover_status/env）
scripts/
  fetch_case.py            从官方发布页下载 dataset zip，按 SHA256 校验，只取该 case 的 source/input 与 target-failure.log
  prepare_environment.py   用历史包版本从 snapshot/Launchpad 恢复依赖；自动探测 suite；生成 bootstrap root
  ubuntu_archive.py        snapshot index 解析（.xz/.gz）、Launchpad 兜底下载、SHA256/架构校验
  install.sh               在 scratch 容器里安装历史依赖（见第 4 节修复）
  environment.Dockerfile   scratch + bootstrap.tar.xz + pool + install.sh + build-case
  run_case.sh              单例编排：env 条件 → 准备环境 → baseline（可多次尝试）→ 基线闸门 → 可选 patch
  check_baseline.py        基线诊断比对（全日志回退、PID 归一化、退出证据）
  run_baseline.py          按历史 TERM-after-N-minutes 监控静默超时
  select_cases.py          workflow 的 matrix 选择（case id / pilot / pending / arm64 / amd64 / all / 逗号列表）
  export_catalog.py        从 200 例 status 台账重新生成 cases.json（含 distribution 字段）
.github/workflows/reproduce.yml
                           唯一 workflow：workflow_dispatch(selection, patch_pr)，matrix 并行 12
```

`patch_pr` 模式：PR 里必须存在 `submissions/<case-id>/change.patch`，workflow 用 `git fetch refs/pull/<n>/head` 取补丁 → 基线校验通过后在同一镜像里应用补丁 → 要求退出 0 且产出目标架构 `.deb`（`binary-packages.txt`）。

## 2. 数据与环境

- 免费额度：public repo 的标准 runner 不计分钟；`ubuntu-24.04`（x86）与 `ubuntu-24.04-arm` 都可用；**并发 20 job、单 job 上限 6h**。
- 历史依赖来源：`snapshot.ubuntu.com`（按日志 `Build finished at` 的时间戳）+ `launchpad+files` 兜底；官方 dataset zip 从 `matrix.cstcloud.cn` 下载并有固定 SHA256。
- 本机（Windows）分析目录：`C:\Users\liu_z\.dsh\tmp\bb-repro\`（repo 克隆、runs 日志/分析 JSON）。
- GitHub 认证：本机 `gh` 未登录（git credential 里的 token 缺 `read:org`，`gh auth login --with-token` 会失败）。Jarvis 的做法：把 token 临时写到 `C:\Users\liu_z\.dsh\tmp\ghtok.txt`，全程用 REST API（`Authorization: Bearer`）。**注意该文件含 token，Codex 接手时如继续用，结束请删除或换自己的方式。**
- 服务器（3090）只作为外部证据源：`/data/home/liuzhaofeng/runs/repro-200/codex-20261120/`（190/200 台账、OBS 实验、status-200.csv、verified-increments.json）；`/data/home/liuzhaofeng/datasets/buildbench/buildbench-200-exact-v1`（31GB 冻结包，含所有历史 .deb）。公开 runner 不直接访问服务器。

## 3. 本次已 push 的提交（`50573d1..cbaf8aa`）

| commit | 内容 |
|---|---|
| 9a65579 | matrix 并行 6→12 |
| a121edb | 去掉 workflow 的 UTF-8 BOM（PowerShell 写文件会带） |
| f70d546 | snapshot `Packages.gz` 回退；catalog 增加 `distribution`（200 例全是 `*-proposed`）；失败日志更详细 |
| 9ace396 | **suite 自动探测**：按历史版本命中率依次试 distribution → base-proposed → base → updates → security → 上一/两个 series。关键：`launchpad-jammy-arm64-amd64-libbpp-seq` 日志标 `jammy-proposed`，实际包版本属于 **impish**（gcc-11 11.2.0-7ubuntu2、libicu67）；选中 impish 后 missing 从 5–6 变 0 |
| 1712a45 | `selection` 支持逗号分隔 case 列表（按失败类别批量重跑） |
| b0af616 | 基线比对：历史诊断提取为空时回退全日志；segfault/test-driver 的 PID、临时路径归一化（修 libevtx/zvbi 这类只差 PID 的假失败） |
| 203acd8 | 绕过 `usrmerge` postinst（裸容器无 /proc 挂载时迁移失败） |
| 3cf65b0 | install 逐包 unpack + 失败包维护脚本 no-op 重试（离线覆盖不足） |
| 8bdc477 | **cases.json 增加 `env` 字段**；run_case.sh 应用 nofile/cpus/cpuset/user/vars/attempts；配置 19 例 |
| 935615a / 6507b0c | 修正 run_case.sh 行尾与 `set -e` 下的 `[[ ]] &&` 陷阱 |
| 3dd445a | 修复被 env 补丁误覆盖的两条 catalog 条目（biopython、inetutils）——**改 cases.json 时务必按 key 局部更新，不要整条替换** |
| 874e000 | install 修复 v3：`libpam-modules` 的 preinst 无法预置 no-op（dpkg 会从 deb 重建），改为 **repack**：`dpkg-deb -R` → 删 `DEBIAN/{pre,post}{inst,rm}` → `dpkg-deb -b` → 重打包安装 |
| cbaf8aa | `env.timeout`（默认 7200s，`timeout --signal=KILL` + `docker rm -f` 兜底） |

## 4. 关键根因与验证结果

1. **容器安装失败（原 24 例）**：`usrmerge` postinst + `libpam-modules` preinst 在裸 scratch 容器里无法执行。v3 repack 方案生效后，13 例重跑中 **7 例已能正常构建**（转为 baseline_success），容器路径基本打通。
2. **suite/快照错配**：见 9ace396；另有大量 `*-proposed` 版本在 snapshot 中不存在（devel 阶段），自动探测 + Launchpad 兜底解决大部分。
3. **attempts 对 flaky 无效**：alertmanager 连续 3 次都构建成功（历史是 Go test 10 分钟超时类失败）。说明这类是**环境/负载条件**，不是低概率抖动；需要更硬的条件（CPU 数量/型号、内存、负载、mount/namespace 差异），或判定为“公开 runner 不可复现”。
4. **卡死**：amd64 sweep 有 4 个 job 跑了 2h+（pynfft/python-intbitset/rocm-device-libs/libcrcutil），已取消，并加 `env.timeout` 兜底；这 4 例正在用新逻辑重跑（run 44870524392）。

## 5. 当前实测数字（截至 13:40）

| run | 覆盖 | 通过 | 失败 | 备注 |
|---|---|---|---|---|
| [44858834517](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44858834517) amd64 sweep（旧代码，已取消） | 100 | 34 | 62 | 5 未完成；失败分类：docker 24 / diag 21 / baseline_success 17 |
| [44863494167](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44863494167) arm64 sweep | 100 | 63 | 34 | 3 长跑；失败分类：diag 29 / baseline_success 5 |
| [44868950949](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44868950949) env 条件重跑 | 35 | 2 | 30 | 多为 baseline_success（构建成功） |
| [44869540169](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44869540169) install-repack 重跑 | 13 | 1 | 9 | **7 例转为 baseline_success**，install 修复生效 |
| [44870524392](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44870524392) 4 个卡死例 + timeout | 4 | — | — | 运行中 |
| [44866205303](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/44866205303) diag 重跑（旧 checker 部分） | 21 | 3 | 18 | 见第 6 节 |

逐例清单（baseline_success / diag_mismatch 的 case id、缺失/多余诊断）见 `C:\Users\liu_z\bb-scratch\repro200-ci\handover-state.json` 和 `runs\analyzed-*.json`。

## 6. 剩余问题（下一阶段工作）

### 6.1 baseline_success（构建成功 = 历史失败没复现）
- x86（17，旧 sweep 口径）：libinsane、v2ray-core、biopython、alertmanager、avo、cowsql、lua-luv、zim-tools、gnome-shell、dqlite、pyppmd、qtpim、qtorganizer、inetutils、dnscap、libselinux、pyinstrument。
- arm（5）：本轮统计新增，需重新确认（见 handover-state.json `arm_baseline_success`）。
- 已尝试：attempts 重试无效（alertmanager 3/3 成功）。
- **建议下一步：变体矩阵**——同一 case 用多组 `env` 组合重试：`cpuset=0`（单核）、`cpus=1`、`cpus=2`、限制内存（docker `--memory`）、`nofile` 小值；把结果记录到 `cases.json` 的 `env`（可加 `variant` 字段），找出能触发历史失败的组合。dnscap 的 3 核条件已配置待验证；cowsql 的 nofile=112 待验证（它现在 install 通过后重建成功）。
- CPU 型号相关（avo 需要无 FMA/BMI2 的 CPU；cython-blis 需要 zen3 内核分派）：公开 runner 无法改 CPU 型号，除非用 QEMU/自托管 runner；建议先标记“不可复现”，或接受“签名级”降级。

### 6.2 diag_mismatch
- **“empty=True” 类（大量）**：旧 checker 下历史诊断没提取出来（Counter() 两边空）→ 旧代码直接判失败。新 checker 已加全日志回退 + 无诊断降级闸门，但这些 case 还没用新代码重跑；先重跑这一批（x86 21 例清单见 analyzed JSON；arm 29 例同理）。
- 真实差异（需要逐例）：
  - `gcc-9-cross`（x86）：缺 gcc-9 自测错误链；已配置 `CROSS_ARCHS=powerpc`（attempts=2），待验证。
  - `cython-blis`：CPU 内核分派不同（zen3 vs skx），需限定 CPU 或设置 BLIS 配置。
  - `libgnomecanvasmm2`：缺 `dot`（graphviz），doc 构建失败；需要把 graphviz 补进依赖或忽略 doc 构建。
  - `nginx`：`DEBIAN/control` 报错行号差 1（第 7 行 vs 第 8 行），可能是 dpkg/生成顺序差异，逐字比对可考虑归一化行号。
  - `eztrace`：OTF2 错误不同（无效 handle vs 文件已存在），构建目录/顺序相关。
  - `libyuv`（arm）：失败测试集合不同（I010ToARGB* vs I420*），CPU 特性/实现路径差异。
  - `liboqs`、`tinycbor`、`gtk3bindings`、`gcc-15-cross`、`mlmmj` 等：见 analyzed JSON 的 missing/extra 诊断。
- **注意**：sweep 用的是旧 checker（9a65579）；新 checker（b0af616+）尚未全量重跑，统计会变。

### 6.3 补丁 PR 验证（x86 侧尚未演示）
- ARM 侧 golf 已通过（PR #1）。x86 侧建议选 globalplatform（基线已匹配）做示例补丁 PR：
  1. 在 `submissions/launchpad-noble-arm64-amd64-globalplatform-df0b1ad38fd5/change.patch` 放一个修复 `__wrap_RAND_bytes` 链接错误的补丁；
  2. 用 `gh workflow run reproduce.yml -R MegaFlowAI/BuildBench-Reproduction --ref main -f selection=<case> -f patch_pr=<PR号>` 验证：基线必须失败且诊断匹配 → 应用补丁后构建成功 + 产出 amd64 .deb。
- 并建议加一个 workflow 校验：PR 只允许修改 `submissions/**/change.patch`，防止破坏基线。

### 6.4 全量回归
所有修复落地后跑 `selection=all`（200 例，注意 20 并发 + 6h 上限，必要时分批 arm64/amd64）。目标：200/200 基线匹配后再启用补丁验证作为测试环境。

## 7. 操作备忘（Codex 接手直接可用）

```bash
# 单例 / 逗号列表 / 全量
curl -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/MegaFlowAI/BuildBench-Reproduction/actions/workflows/reproduce.yml/dispatches \
  -d '{"ref":"main","inputs":{"selection":"launchpad-... ,launchpad-..."}}'

# 带补丁 PR
... -d '{"ref":"main","inputs":{"selection":"<case>","patch_pr":"1"}}'
```

- 分析脚本（Windows）：`D:\Users\liu_z\bb-scratch\md\poll_repro_run.py`（简单汇总）、`analyze_repro_run.py`（抓失败 job 日志并分类）、`summarize_runs.py`（多 run 汇总）。
- 每次重跑前先看 `runs\analyzed-*.json`，避免重复跑已通过的 case。
- **坑**：
  - PowerShell 写 YAML/JSON 会带 BOM/CRLF（workflow 文件必须 LF 无 BOM）；改文件用 python 写 `\n`。
  - 改 `cases.json` 必须按 key 局部更新，整条替换会丢 `packages`（本次踩过，已恢复）。
  - GitHub 免费并发 20 job，排队很慢；批量用 `max-parallel: 12` 已经较优。
  - 单 job 6h 上限；带静默超时的 case（gir2pas/sphde 9000s）会占用很久，建议单独跑。
  - 有 4 个 case 历史上会卡死（pynfft/python-intbitset/rocm-device-libs/libcrcutil），`env.timeout` 兜底已在 cbaf8aa。
  - `gh` CLI 本机不可用（token 缺 read:org），请直接用 REST API 或换 token。

## 8. 交付物索引

- 本文：`docs/HANDOVER-jarvis-2026-11-21.md`（本文件）、本地 `D:\Users\liu_z\bb-scratch\repro200-ci\HANDOVER-jarvis-2026-11-21.md`
- 状态汇总：`D:\Users\liu_z\bb-scratch\repro200-ci\STATUS-2026-11-21.md`
- 逐例状态：`D:\Users\liu_z\bb-scratch\repro200-ci\handover-state.json`
- 失败 job 原始日志与分类：`C:\Users\liu_z\.dsh\tmp\bb-repro\runs\`
- Codex 原始交接：`docs/reproduce-200-handover-20261121.md`（仓库内）
