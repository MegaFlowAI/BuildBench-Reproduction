# BuildBench 双架构构建复现

仓库包含 BuildBench Development Cases v0.1 的 200 个任务，目标 ARM64、amd64 各 100 个。官方源码与失败日志位于 `cases/`；历史依赖与 validator 镜像位于 [冻结 Release](https://github.com/MegaFlowAI/BuildBench-Reproduction/releases/tag/frozen-cases-v1)。复现脚本、依赖锁和旧台账是本仓库的补充材料。

## 当前 10 项试点

详见 [试点说明](docs/isa-pilot.md) 和 [固定任务与根因清单](pilots/isa-10.json)。这轮选取 10 个有明确源码证据的 x86 → ARM 错误，覆盖六个 Ubuntu suite。环境修复保留项目本来的架构错误，避免依赖安装失败冒充复现成功。

在 **Actions → 原始构建与补丁验证** 选择试点分支，填写：

- `selection=pilot`：运行 10 项；也支持一个或多个逗号分隔的 case ID。
- `patch_pr` 留空：复现未修改源码的历史失败。

`codex/isa-pilot-20261126` 分支的脚本、配置提交自动触发同一 workflow。其他分支使用手动入口。

本地预检：

```powershell
python -X utf8 scripts/pilot.py audit --output results/pilot-input-audit.json
python -X utf8 -m unittest discover -s tests -v
```

预检不是实际构建。实际构建使用原生 ARM/x86 GitHub runner、历史依赖、官方 validator / OBS / chroot；历史 Ubuntu 用户态由依赖池恢复，宿主内核不等同于历史内核。

## 判定与证据

**原始软件包构建失败是预期结果，build job 会红；复现结果以证据里的判定为准。**

| `report.json.category` | 含义 |
| --- | --- |
| `isa_failure_reproduced` | 试点目标架构真实构建失败，官方诊断和架构根因匹配，未发现新增失败诊断 |
| `historical_failure_reproduced` | 非试点任务匹配历史失败；不额外声称已证明 ISA 因果关系 |
| `infrastructure` | 下载、依赖、构建根或其他环境阶段失败 |
| `diagnostic_mismatch` | 失败位置或诊断不同，需要排查 |
| `unexpected_success` | 原始构建成功，历史故障未复现 |
| `timeout` / `evidence_missing` | 超时或缺证据，不能计为复现成功 |

每例必须进入真实包构建，官方失败诊断全部出现、关键阶段完整、日志行数至少为官方的 15%。10 个试点还验证根因签名、目标架构并拒绝新增失败诊断。参考日志只读，不伪造日志、不通过跳测试或关警告掩盖差异。

附件：

- `evidence-<case-id>`：全部尝试的原始日志、构建结果、判定、实际环境配置、依赖锁、修复记录、机器/镜像信息、耗时与 SHA256，保留 30 天。
- `reproduction-summary`：全部期望任务的结果和完整流程耗时；丢失任务也会列入。
- `build-log-<case-id>`：单日志兼容下载，保留 7 天。

下载后可以用 `scripts/compare_failure_log.py` 再判定，参数见 [试点说明](docs/isa-pilot.md)。

## 可选：验证架构修复补丁

在公开 PR 中提供 `submissions/<case-id>/change.patch`，使用针对解包后源码的统一 diff（`a/`、`b/` 前缀，≤1 MB）。`selection` 只填这一例，`patch_pr` 填 PR 编号。

工作流先验证未打补丁的基线，再把补丁应用到干净源码、重打包并重建。补丁验收要求 validator 退出 0、结果 `status=succeeded`，且产出目标架构或 `all` 的 `.deb`。当前试点任务不要求修复架构缺陷。

构建禁用容器网络，但官方 OBS/chroot 路径使用 privileged 容器；这是一次性 GitHub runner 上的受信任构建流程，不是用于执行不可信补丁的安全沙箱。

## 历史记录

[公开台账](docs/public-baselines.csv) 和 `docs/HANDOVER-*.md` 保留此前工作结果；其中旧状态语义、附件说明和待办可能已过时，当前流程以上述说明和代码为准。历史匹配不能替代当前分支的实跑结果。

[官方数据发布页](https://matrix.cstcloud.cn/build-bench/data-downloads.html) · [冻结环境说明](docs/frozen-reproduction.md)
