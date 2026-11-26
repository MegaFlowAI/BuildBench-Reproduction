# 10 项试点实测结果（2026-11-26）

**10/10 复现成功。** 未修改的官方项目源码在原生 ARM runner 中构建失败，失败诊断与官方日志一致，并命中逐项审查过的架构根因。最终一轮没有未解决的环境失败、缺失诊断或新增失败诊断。

[最终 Actions 运行](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/45841541212) · [代码分支](https://github.com/MegaFlowAI/BuildBench-Reproduction/tree/codex/isa-pilot-20261126) · [机器可读结果及逐例作业链接](isa-pilot-results.json) · [项目结构与复跑说明](isa-pilot.md)

实测代码提交：`3590f725b410786e59681ea1e330e0a94e57c8eb`。本轮范围是 x86_64 → aarch64 的 10 个任务，覆盖六个 Ubuntu suite；没有执行 ARM → x86 对照批次或全部 200 例。

## 结果与时间

最终运行北京时间 **22:41:26–22:44:48**，含任务选择、排队、checkout、并行构建、附件和汇总约 **3 分 22 秒**。单例环境准备至判定为 **57.98–153.46 秒**，中位数 **75.55 秒**。这些是本次观测值；网络和 runner 排队会影响复跑耗时。

| 项目 | Ubuntu suite | 环境准备至判定（秒） | validator 执行（秒） | 官方架构故障 |
| --- | --- | ---: | ---: | --- |
| golf | questing | 57.98 | 45 | ARM 不支持 `-fcf-protection=full` |
| rust-generator | jammy | 66.69 | 54 | 构建脚本拒绝 aarch64 |
| libcrypt-xxhash-perl | mantic | 69.59 | 57 | x86 专用分派与 `emmintrin.h` |
| r-cran-digest | mantic | 80.07 | 66 | x86 prefetch 依赖 `xmmintrin.h` |
| rust-criterion-cycles-per-byte | noble | 113.31 | 99 | cycle counter 仅支持 x86 |
| xmbmon | noble | 79.60 | 64 | ARM 缺少 x86 端口 I/O 的 `sys/io.h` |
| harec | plucky | 65.51 | 51 | ARM 汇编器收到 x86 `movq` / `syscall` |
| qmidiarp | resolute | 153.46 | 138 | ARM GCC 不认识 SSE 编译选项 |
| rust-hamming-rs | resolute | 71.50 | 57 | 无保护的 x86_64 intrinsics 与 AVX2 |
| rxtx | resolute | 107.47 | 90 | ARM 上调用 `ioperm/inb/outb/inw/inl/outl` |

validator 时间包含 chroot 初始化和依赖安装，不能当成纯编译时间。三次完整运行依次得到 [8/10](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/45839801607)、[9/10](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/45840959896)、[10/10](https://github.com/MegaFlowAI/BuildBench-Reproduction/actions/runs/45841541212)。以上最终耗时不包含前期代码审核与排障时间。

## 已排除的非架构问题

- 核查并沿用已有的 `libmd0` 预安装、虚拟依赖消歧和受损 `.deb` 同版本恢复机制。
- 补上缺失历史 `libjpeg-dev` 的实际恢复路径，校验包身份与 SHA256，并明确选择正确的 JPEG 依赖提供者。
- 对 uutils 过渡时期的任务预安装历史命令提供者，使用同一 OBS/validator 的原生 chroot 引导，解决旧 debootstrap 缺 `rm` / `true` 的问题。
- 实测定位 `qmidiarp` 的 `fc-cache` 失败为 HarfBuzz 安装顺序问题，预安装原版本 `libharfbuzz0b`。用于定位的临时诊断改动已移除，最终字体包未重打包、postinst 未跳过。
- 修正验收证据不足、基础设施失败误计为包构建失败，以及 GCC 源码摘录中字符串误报为诊断的问题。

未修改官方参考日志、项目源码、`cases.json` 或既有 Release 资产，未跳过测试、禁用警告或升级项目工具链。临时构建配置及依赖锁的变化均保存在附件中。

## 验证与交付

1. 14 项本地及 CI 单元测试通过，包括提前环境失败、缺失/新增诊断、错误架构、意外成功、超时等反例。
2. 10 份完整证据已下载，逐文件 SHA256 校验通过。
3. 使用下载的原始 `build.log`、官方压缩参考日志和 `build-result.json` 在本地再次运行判定器，**10/10 匹配**。
4. `results/run-45841541212/` 保存最终全部原始证据，`results/final-recheck.json` 保存本地复核结果。前两轮证据位于相应 run 目录。

Actions 的 **build job 和整个运行显示红色是预期的包构建失败**；“试点复现汇总”job 为绿色，每例 `report.json.category=isa_failure_reproduced`。不能把红色状态直接解释为复现失败。

结论：这批明确的架构编译错误适合用 GitHub Actions 快速复现，建立好冻结依赖与引导流程后，10 项并行只需数分钟。主要工程难度在历史环境恢复和可靠验收；这批结果不能外推到依赖特定 CPU、内核、嵌入式设备或长时间测试的其他任务。
