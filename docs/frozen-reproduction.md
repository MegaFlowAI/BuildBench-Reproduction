# 冻结用例发布与验收

1. 从官方开发集取每例的 `case.json`、`README.md`、`source/input`、`checksums` 和参考日志。对照源文件哈希，再从服务器冻结池补齐 `config`、`manifest.json` 和逐包 SHA256。
2. 每例打包上传到同一 GitHub Release，仓库保存可读元数据和资产的大小、SHA256、运行时版本。先从 x86_64 和 ARM64 各验证一例，再按批次发布其余用例。
3. 构建使用已校验的冻结材料和匹配架构的运行时。参考日志由宿主保管，构建进程只收到源码、配置及冻结依赖。
4. 每次保留构建退出、实际文件哈希、参考文件哈希和首个差异字节位置。逐字节一致、真实构建失败两项都通过后才计入该目标。

在 **Actions → BuildBench frozen baselines** 输入一个已发布的 case ID、逗号分隔的列表、`arm64`、`amd64` 或 `all`。作业摘要显示判定，附件保留真实构建日志、退出码和阶段事件。

活动依赖池沿用服务器冻结清单。额外找到的历史版本放在归档中的 `dependencies/historical-alternatives/`，供后续显式选择。每例的 `checksums/frozen-environment.json` 记录历史包版本与活动依赖池的差异。
