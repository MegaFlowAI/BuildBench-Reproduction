# 交接给 Codex：BuildBench 原始构建与补丁验证（2026-11-22）

仓库：`MegaFlowAI/BuildBench-Reproduction`（public，main 分支）
本文件只讲“现状 + 接下来干什么 + 不能干什么”。历史背景见 `docs/HANDOVER-jarvis-2026-11-21.md`、`docs/frozen-reproduction.md`。

## 1. 一句话现状

只剩**一个**构建 workflow：`原始构建与补丁验证`（`.github/workflows/reproduce.yml`，输入只有 `selection` 和 `patch_pr`）。
它用冻结 release 资产 + 官方 validator（obs-build + chroot）完整重放原始构建，产出多阶段 `build.log`。
已验证两个样例，全量 200 例 sweep 刚跑完，**74 通过 / 123 失败 / 3 个长超时仍在跑**。失败原因已分类，见第 3 节。

## 2. 架构（就这几块）

```
cases.json                          200 例 catalog；每个 case 的 env 条件也在这里
cases/<方向>/<case>/                每个 case 的元数据：case.json、manifest.json、
                                    config/（buildconfig + dependency-lock.json）、checksums/
docs/public-baselines.csv           逐例公开验证台账（tier 字段）
scripts/
  select_cases.py                   逗号分隔 case ID → Actions matrix
  frozen_release.py                 fetch：从 Release frozen-cases-v1 下资产 + 运行时镜像
  fix_frozen_case.py                补 usr-is-merged stub（debootstrap suite 需要）
  prepare_frozen_runtime.py         生成 validator 的 runtime-settings（复现条件在此生效）
  apply_submission_patch.py         解包 dsc → 应用 PR 补丁 → 整理 quilt patch → 重打包 source
  run_frozen_case.sh                单例编排：基线完整构建 → compare →（可选）补丁构建
  compare_failure_log.py            与官方 target-failure.log 比对（诊断/阶段/行数）
  check_baseline.py                 诊断指纹归一化（被 compare 复用）
```

工作流每个 job：`frozen_release.py fetch` → `run_frozen_case.sh`（内部 fix → validator 基线 → compare → 可选补丁）→ 汇总 + 上传 artifact。

## 3. 全量结果与失败分类（run 44993227071）

- 通过 74（`baseline-verdict.json` 的 `status=matched`）：诊断全覆盖 + 关键阶段齐全 + 行数 ≥ 官方 15% + 包构建失败。
- 失败 123，分三类：
  1. **infrastructure 59**：重放只有 15–20 行，没进入构建阶段。典型：cysignals(focal)、alertmanager(groovy)、pyml(jammy)、v2ray(hirsute)、pyfftw(focal)。→ validator 在依赖安装/构建根准备阶段退出，冻结环境的 bootstrap 对不同 suite 支持不一致。
  2. **history_not_reproduced 43**：构建成功或失败点不同。典型：libinsane、biopython、gdb-mingw、cowsql、lua-luv、pyML。→ 依赖特殊环境（CPU 核数/绑定、nofile、并发度、超时、测试顺序等）。
  3. **diagnostics_missing 21**：进了构建，但官方日志里若干诊断没出现或没提取到。典型：reportlab（提取/拼接问题）、tmpreaper、dynarmic、spirv-llvm-translator、fenics-dolfinx。
- 仍在跑（长超时）：gcc-9-cross、python-pyppmd、libcrcutil。

## 4. 接下来按顺序做（每步有验收标准）

**P0 修 infrastructure（最大头 59 例）**
1. 从 `cysignals`（focal→amd64）开始，下载该 job 的 artifact，看 `result-baseline-*/build-output/build.log` 那 15 行到底停在哪（debootstrap？依赖 preflight？dpkg unpack？）。
2. 按 suite 逐个修 `fix_frozen_case.py` / 冻结资产 bootstrap（已知先例：usr-is-merged stub、usrmerge postinst、libpam-modules preinst、缺依赖修复）。
3. 验收：该 case 的 `baseline-verdict.json` 里 `stages.build_started=true` 且 `package_failed=true`（能进入真实构建并失败）。

**P1 接入复现条件（对应 43 例 history_not_reproduced）**
1. `prepare_frozen_runtime.py`（或 run_frozen_case 调用处）把 `cases.json` 的 `env`（nofile / cpuset / cpus / memory / timeout / attempts / vars）合并进 validator 的 `reproduction_conditions`；目前只接了 cpus。
2. 优先验证已知案例：cowsql(nofile=112)、lua-luv(单核/CPU 配额)、alertmanager(单核/双 GO 线程)、v2ray、libinsane(ninja 顺序)、biopython(3 核)。
3. 验收：这些 case 的 `status=matched`，或明确记录“公开 runner 无此硬件条件”。

**P2 修比对器（对应 21 例 diagnostics_missing）**
1. 先看 `reportlab` 的 `build.log.normalized`：是提取规则漏了，还是日志被拼接/截断。
2. 只在 `compare_failure_log.py` 里做归一化/拼接修复，不要放宽判定条件。
3. 验收：该 case `missing_diagnostics` 为空且输出到 summary。

**P3 全量回归 + 逐例台账**
跑 `selection=<200 个 case ID 的逗号列表>`（约 2–3 小时）。产出：
- 每例分类（matched / infrastructure / env-condition / hardware-unreproducible / comparator-bug）；
- 更新 `docs/public-baselines.csv` 的 tier；
- 对 CPU 型号相关（如 avo 需要无 AVX512 的 CPU）标 `hardware-unreproducible`，并写明需要自托管环境。

**P4 可选（不影响主线）**
把运行时镜像改为 `FROM ghcr.io/terriyyy/buildbench-validator-runtime:0.1.0-rc.3@<digest>` + 我们的补丁层构建，替代 release 里 190MB 的 tar（要 pin digest，tag 有 rc.3/rc.4 不一致历史）。

## 5. 硬约束（不要违反）

1. **不要引入第二个构建 workflow**，也不要退回“轻量容器 + 直接 dpkg-buildpackage”的旧路径（日志会只剩 100 多行）。
2. **判定标准不要放宽**：必须 `package_failed=true`、官方诊断全覆盖、关键阶段齐全、行数 ≥15%。放宽等于自欺。
3. **不要改 `logs/target-failure.log`**（参考日志只读），也不要伪造/补齐日志行。
4. **release 资产 `frozen-cases-v1` 只读**：除 `recover-frozen-debs` / `launchpad-chroot-audit` 这类维护工具外，不要改/删资产；新增资产也要校验 SHA256。
5. **补丁必须走 `submissions/<case-id>/change.patch`**，且 PR 只改这个文件、≤1MB。补丁要应用到**解包后的源码**，再整理成 `debian/patches/*.patch` 写入 `series`，然后 `dpkg-source -b` 重打包（3.0 quilt 不允许源码树有未登记修改）。不要直接用 validator 的 `--patch`（它的 patch_policy 只允许 `source/input/**`，正常源码补丁会被拒）。
6. **补丁成功判定**：`build-result.json` 的 `status == "succeeded"`（注意不是 `completed`）、`build_exit_code == 0`、artifacts 里有目标架构或 `all` 的 `.deb`。
7. **cases.json 只能按 key 局部更新**，整条替换会丢 `packages` 等字段（踩过）。
8. **workflow 文件必须 LF、无 BOM**（PowerShell 直接写会带 CRLF/BOM，用 python 写）。
9. **gh CLI 不可用**（本机 token 缺 `read:org`）：用 REST API + `Authorization: Bearer`，token 用完删除（`C:\Users\liu_z\.dsh\tmp\ghtok.txt` 是临时文件）。
10. **不要用 Launchpad PPA 跑构建**：EOL series 不接受上传，且当前归档 ≠ 历史快照。Launchpad 只作日志/chroot/元数据来源。
11. 单 job 355 分钟上限、public repo 并发 20；大资产（56GB 总量）下载慢，别在同一次 run 里重复拉。
12. 不要在 sweep 正在跑时改 main 上的 workflow/脚本（矩阵和代码可能不一致），改完先单例验证再批量。

## 6. 操作命令

```bash
# 跑单个/多个 case
curl -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/MegaFlowAI/BuildBench-Reproduction/actions/workflows/reproduce.yml/dispatches \
  -d '{"ref":"main","inputs":{"selection":"launchpad-... ,launchpad-..."}}'

# 带补丁
... -d '{"ref":"main","inputs":{"selection":"<case>","patch_pr":"2"}}'
```

看结果：job 的 artifact `evidence-<case>` → `baseline-verdict.json`、`result-baseline-*/build-output/build.log`、`patched-result.json`。

## 7. 已知坑（会浪费时间）

- validator `--patch` 的 policy 只允许 `source/input/**` → 已用“解包-应用-quilt 重打包”绕过。
- obs-build 并行构建会把进度行插到错误行中间（`(.text+0x..)[ 63%] Building...`）→ `compare_failure_log.py` 已有拆分/回并逻辑，改它时别破坏。
- `usr-is-merged`：debootstrap 对 kinetic+ 要求这个空 meta 包；冻结依赖集里没有，需要在 `fix_frozen_case.py` 里补（已实现，其他 suite 可能有类似问题）。
- 有些 case 历史失败是“测试超时/内核行为”，在公开 runner 上可能永远不复现，别硬凑。
- Actions 的 artifact 在 job 结束后才可见，轮询时别误判“没产物”。

## 8. 索引

- 上一份交接：`docs/HANDOVER-jarvis-2026-11-21.md`
- 冻结环境说明：`docs/frozen-reproduction.md`
- 逐例台账：`docs/public-baselines.csv`
- sweep 结果：run `44993227071`；本机分析脚本在 `D:\Users\liu_z\bb-scratch\md\`（categorize_sweep.py、wait_sweep_summary.py 等）
