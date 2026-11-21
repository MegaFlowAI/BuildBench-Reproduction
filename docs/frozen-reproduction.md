# 冻结用例发布与验收

1. 从官方开发集取每例的 `case.json`、`README.md`、`source/input`、`checksums` 和参考日志。对照源文件哈希，再从服务器冻结池补齐 `config`、`manifest.json` 和逐包 SHA256。
2. 每例打包上传到同一 GitHub Release，仓库保存可读元数据和资产的大小、SHA256、运行时版本。先从 x86_64 和 ARM64 各验证一例，再按批次发布其余用例。
3. 构建使用已校验的冻结材料和匹配架构的运行时。参考日志由宿主保管，构建进程只收到源码、配置及冻结依赖。
4. 每次保留构建退出、实际文件哈希、参考文件哈希和首个差异字节位置。逐字节一致、真实构建失败两项都通过后才计入该目标。

在 **Actions → BuildBench frozen baselines** 输入一个已发布的 case ID、逗号分隔的列表、`arm64`、`amd64` 或 `all`。作业摘要显示判定，附件保留真实构建日志、退出码和阶段事件。

活动依赖池沿用服务器冻结清单。额外找到的历史版本放在归档中的 `dependencies/historical-alternatives/`，供后续显式选择。每例的 `checksums/frozen-environment.json` 记录历史包版本与活动依赖池的差异。

[补回的历史依赖](../cases/recovered-packages.json)列出 Release 中额外发布的 ARM64 `libjpeg-dev` 历史包、原始下载地址、SHA256 和所涉及的 9 个用例。现有归档和回放仍使用各自锁定的依赖。补回版本对历史失败的影响需要单独构建验证。

[受损依赖修复清单](../cases/integrity-repairs.json)记录冻结池里被截断的 21 个包及对应的同版本原始下载。Actions 校验归档和旧文件的 SHA256 后，在临时构建目录换成已校验的完整包，再更新该次构建的依赖锁。实际应用的修复会写入作业附件的 `dependency-repairs.json`。

官方 200 份日志都记录了构建阶段失败，并引用了 22 个不同的 Launchpad chroot SHA-1。[历史构建机清单](../cases/historical-hosts.json)记录每例的原始构建链接、内核、chroot 和宿主侧工具版本。当前仓库的运行时来自已保存的 OBS Validator 镜像。逐字节比对会保留 Launchpad 日志中的构建机、时间和调度器输出，供核验这些环境差异。
