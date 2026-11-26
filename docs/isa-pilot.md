# 10 项架构迁移复现试点

本轮以未修改的官方源码在目标架构失败、根因与官方日志一致为目标。环境修复只作用于临时依赖池和构建配置，不修复这 10 个项目的架构缺陷。所有结论以本轮 Actions 的实际证据为准；静态审核和旧台账不等同于本轮复现完成。

## 结构与来源

工作区是 `MegaFlowAI/BuildBench-Reproduction` 的源码快照，没有 `.git`。它包含官方开发集输入，以及此前复现工作增加的脚本、历史依赖和台账；不能把整个仓库都视为未经修改的官方构建环境。

- `cases.json`：200 个任务，ARM64 与 amd64 各 100 个，记录历史 Ubuntu suite、包版本、构建参数及运行条件。
- `cases/<迁移方向>/<case-id>/case.json`、`source/input/`、`logs/target-failure.log.gz`、`checksums/source-input.sha256.json`：任务身份、官方源码包、官方失败日志、源码哈希。
- 同目录 `manifest.json`、`config/`、`asset.json`：复现构建配置、依赖锁、冻结归档的大小和 SHA256。
- `cases/runtimes.json`：两种架构的 validator 镜像归档及 SHA256；镜像来自已有冻结发布，amd64 带历史 shim。
- `cases/recovered-packages.json`、`integrity-repairs.json`：缺失与损坏的历史依赖恢复清单。
- `.github/workflows/reproduce.yml`：唯一构建入口；调用 `frozen_release.py`、`run_frozen_case.sh`、官方 validator / OBS / chroot、`compare_failure_log.py`。
- `scripts/run_case.sh` 等：此前轻量构建路径，当前试点不调用。
- `docs/public-baselines.csv` 与旧交接文档：历史证据和历史约束，不能用作本次实际通过数。
- `pilots/isa-10.json`：本轮固定 10 例、架构根因签名及源码定位。

## 选择依据

这 10 例均为 x86_64 → aarch64，覆盖六个 Ubuntu suite。选择集中在能从源码与诊断直接解释的架构错误；反向迁移、时间敏感测试、CPU 型号相关错误另作后续批次。

| 项目 | Suite | 官方失败的架构原因 | 源码证据 |
| --- | --- | --- | --- |
| golf | questing | ARM 不支持 `-fcf-protection=full` | Makefile:102 无条件加入 `-fcf-protection` |
| rust-generator | jammy | 构建脚本拒绝 aarch64 | build.rs:28–30 仅选择 x86_64 后端 |
| libcrypt-xxhash-perl | mantic | 编译 x86 分派实现与 SSE2 头文件 | xxh_x86dispatch.c:56、179 |
| r-cran-digest | mantic | 硬编码启用 x86 prefetch | crc32c_config.h:15；crc32c_prefetch.h:18 |
| rust-criterion-cycles-per-byte | noble | cycle counter 实现只支持 x86 | src/lib.rs:33–34 `compile_error!` |
| xmbmon | noble | 使用目标架构没有的端口 I/O 头文件 | io_cpu.h:5 `sys/io.h` |
| harec | plucky | ARM 汇编器收到 x86 `movq` / `syscall` | configs/linux.mk:7 默认 `ARCH = x86_64` |
| qmidiarp | resolute | ARM GCC 收到 SSE 编译选项 | configure.ac:298 `-msse -msse2 -mfpmath=sse` |
| rust-hamming-rs | resolute | 无架构保护的 x86_64 intrinsics / AVX2 | src/lib_avx2.rs:1、9 等 |
| rxtx | resolute | ARM 上调用 x86 端口 I/O 函数 | src/RawImp.c 中的 `ioperm/inb/outb/inw/inl/outl` |

源码行号来自原始 tar 内文件；Debian 补丁可能改变解包后行号，以官方日志的精确诊断为验收依据。此轮没有重建 x86 对照组，不声称完成双架构差分证明。

## 环境修复与边界

读取 2026-11-22 公开作业的原始附件，确认过以下非架构故障：

| 故障 | 处理 |
| --- | --- |
| `dpkg` 启动缺 `libmd.so.0` | 保留并核查已有的 `libmd0` 预安装逻辑 |
| `pkg-config` 与 `pkgconf` 提供者冲突 | 保留按冻结 Ignore/Prefer 配置消歧的逻辑 |
| `r-cran-digest` 历史 `libjpeg-dev` 未进入冻结池 | 从已有 Release 恢复相同版本，核对 SHA256 与包身份，加入临时依赖锁 |
| 恢复 JPEG 元包后，OBS 看到两个 `libjpeg-dev` 提供者 | 显式 Prefer 历史 `libjpeg-dev`，保留它依赖的 `libjpeg-turbo8-dev` |
| `qmidiarp` 的 `fc-cache` 缺 `libharfbuzz.so.0` | 循环依赖安装顺序使字体缓存生成早于 HarfBuzz 安装；预安装原版本 `libharfbuzz0b`，不修改字体包或跳过 postinst |
| `systemd`、`rust-coreutils`、LLVM/JDK 等冻结 `.deb` 截断 | 沿用已有同版本修复清单，记录修复结果 |
| uutils 过渡时期的 `coreutils` 仅含链接，旧 debootstrap 未抽取实际提供者，缺 `rm` / `/bin/true` | 对试点中包含该组合的任务，使用 OBS 自身的 chroot 引导，并显式预安装历史 `coreutils-from-uutils` / `rust-coreutils`；记录 engine 变更 |
| 日志路径、OBS 时间前缀不同；源码字符串被误判为诊断 | 对双方做同样归一化，排除 GCC `行号 | 源码` 摘录，保留真正文件位置和错误文本 |

保留官方源码、官方参考日志和原 Release 资产；不跳过测试、不关 `-Werror`、不替换成新版本工具链、不注入目标错误。原生 ARM runner 上仍用历史依赖版本构建。GitHub 宿主提供执行资源，历史 suite 在 chroot 内恢复；chroot 共用宿主内核，不能宣称恢复了历史内核或 CPU 型号。

## 运行与验收

在 Actions → 原始构建与补丁验证选择分支 `codex/isa-pilot-20261126`，`selection=pilot`，`patch_pr` 留空。该试点分支的脚本/配置提交也会自动触发同一 workflow。10 项并行、失败互不取消。

本地 Windows 可先运行：

```powershell
python -X utf8 scripts/pilot.py audit --output results/pilot-input-audit.json
python -X utf8 -m unittest discover -s tests -v
python scripts/select_cases.py pilot
```

`audit` 只校验输入与源码证据，明确输出 `inputs_verified_build_not_run`。真正构建在 Actions 执行。每例必须同时满足：

1. 官方输入哈希验证通过；冻结归档、镜像、恢复包校验通过；validator 使用锁定依赖。
2. 日志确实出现 `dpkg-buildpackage` 包构建开始，结果为非超时的失败，实际架构为 arm64。
3. 保留原有全部官方诊断覆盖、关键阶段与至少 15% 行数要求。
4. 命中试点专属根因签名；没有参考日志之外的新失败诊断。新增诊断须查明原因，不能直接计为成功。

原始包预期失败，所以 build job 仍可能是红色。**复现是否完成看 `report.json.category=isa_failure_reproduced` 和汇总，不看红绿颜色。** `infrastructure`、`diagnostic_mismatch`、`timeout`、`unexpected_success`、`evidence_missing` 都不能算复现完成。

每例 `evidence-<case-id>` 保存原始构建日志、validator 结果、判定、每次尝试的实际配置和依赖锁、环境修复记录、宿主信息、镜像信息、耗时、证据 SHA256；保留 30 天。`reproduction-summary` 给出全部期望任务结果，缺失任务仍列出。`build-log-<case-id>` 保持单日志下载兼容。

下载附件后可再次验证（无需重新构建；路径按附件中的实际 result 目录填写）：

```powershell
python -X utf8 scripts/compare_failure_log.py <evidence目录> <evidence目录>/target-failure.log.gz <evidence目录>/result-baseline-1-XXXXXXXX <validator退出码> <输出verdict.json>
```

## 时间与难度的计量

官方 `Build-Time` 只计包构建阶段，这批为 2–117 秒；环境安装最高 644 秒，不能直接据此承诺 Actions 完整耗时。10 个归档合计约 2.41 GB，另每 job 下载约 189 MB ARM runtime，实际总流量还包括依赖修复和 checkout。完整耗时包含下载、验包、环境准备和构建，由每例 `wall_seconds` 与 `timing-baseline-*.json` 实测；排队时间需另看 Actions。

目前难度集中在冻结环境恢复与验收证据，确定性 ISA 错误本身触发较快。最终通过数、实测耗时和未解决项应以本轮运行结果更新，不用历史通过率替代。

参考：[GitHub runner 架构与规格](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)、[已有冻结资产](https://github.com/MegaFlowAI/BuildBench-Reproduction/releases/tag/frozen-cases-v1)。
