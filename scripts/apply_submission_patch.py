#!/usr/bin/env python3
"""把提交的 change.patch 应用到冻结用例的源码包，生成一个新的用例目录。

validator 的 --patch 面向 case 目录布局（source/input/** 是 dsc/orig/debian 包文件），
不能直接给解包后的项目源码打补丁；这里改为：解包 dsc → 应用补丁 → dpkg-source -b 重新打包，
再让 validator 用修补后的 source/input 正常构建（日志仍走完整 obs-build 流程）。
"""
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

STRIP_LEVELS = ("1", "2", "0", "3", "4")


def copy_tree(source: Path, target: Path) -> None:
    def link(src, dst):
        try:
            os.link(src, dst)
        except OSError:
            shutil.copy2(src, dst)
    shutil.copytree(source, target, symlinks=True, copy_function=link)


def run(cmd, cwd, check=True):
    result = subprocess.run(cmd, cwd=cwd, text=True, capture_output=True)
    if check and result.returncode != 0:
        raise SystemExit(f"command failed: {' '.join(cmd)}\n{result.stdout}\n{result.stderr}")
    return result


def apply_patch(source_dir: Path, patch: Path, work: Path) -> str:
    patch_copy = work / "change.patch"
    shutil.copyfile(patch, patch_copy)
    errors = []
    for level in STRIP_LEVELS:
        for tool in ("git", "patch"):
            if tool == "git":
                result = subprocess.run(
                    ["git", "apply", f"-p{level}", "--whitespace=nowarn", str(patch_copy)],
                    cwd=source_dir, text=True, capture_output=True)
            else:
                result = subprocess.run(
                    ["patch", f"-p{level}", "--batch", "--forward", "--silent", "-i", str(patch_copy)],
                    cwd=source_dir, text=True, capture_output=True)
            if result.returncode == 0:
                return f"{tool} -p{level}"
            errors.append(f"{tool} -p{level}: {result.stderr.strip().splitlines()[:2]}")
            # 回滚半应用的改动
            subprocess.run(["git", "apply", "-R", f"-p{level}", str(patch_copy)],
                           cwd=source_dir, capture_output=True)
            subprocess.run(["patch", "-R", f"-p{level}", "--batch", "--forward", "--silent", "-i", str(patch_copy)],
                           cwd=source_dir, capture_output=True)
    raise SystemExit("change.patch 无法应用到源码：" + " | ".join(errors[-4:]))


def main() -> int:
    case_dir = Path(sys.argv[1]).resolve()
    patch_file = Path(sys.argv[2]).resolve()
    out_dir = Path(sys.argv[3]).resolve()
    if out_dir.exists():
        shutil.rmtree(out_dir)
    copy_tree(case_dir, out_dir)
    input_dir = out_dir / "source" / "input"
    dsc_files = sorted(input_dir.glob("*.dsc"))
    if len(dsc_files) != 1:
        raise SystemExit(f"expected exactly one .dsc in {input_dir}, got {len(dsc_files)}")
    dsc = dsc_files[0]
    work = Path(tempfile.mkdtemp(dir=out_dir.parent))
    try:
        run(["dpkg-source", "-x", str(dsc), str(work / "src")], cwd=work)
        source_dir = work / "src"
        pristine = work / "pristine"
        copy_tree(source_dir, pristine)
        how = apply_patch(source_dir, patch_file, work)
        # 把本地改动整理成 quilt 补丁（3.0 (quilt) 不允许源码树里有未登记的修改）
        diff = subprocess.run(
            ["diff", "-ruN", "--exclude=.git", str(pristine), str(source_dir)],
            text=True, capture_output=True)
        if diff.returncode not in (0, 1) or not diff.stdout.strip():
            raise SystemExit("补丁没有产生任何源码改动")
        body = diff.stdout.replace(str(pristine) + "/", "").replace(str(source_dir) + "/", "")
        lines = []
        for line in body.splitlines():
            if line.startswith("--- "):
                lines.append("--- a/" + line[4:])
            elif line.startswith("+++ "):
                lines.append("+++ b/" + line[4:])
            else:
                lines.append(line)
        quilt = "\n".join(lines) + "\n"
        # 把源码树恢复成未修改状态，让 dpkg-source 认为只有 quilt 补丁变化
        shutil.rmtree(source_dir)
        copy_tree(pristine, source_dir)
        patches = source_dir / "debian" / "patches"
        patches.mkdir(parents=True, exist_ok=True)
        (patches / "buildbench-submission.patch").write_text(quilt, encoding="utf-8")
        series = patches / "series"
        entries = series.read_text(encoding="utf-8").splitlines() if series.is_file() else []
        if "buildbench-submission.patch" not in entries:
            entries.append("buildbench-submission.patch")
        series.write_text("\n".join(entry for entry in entries if entry.strip()) + "\n", encoding="utf-8")
        # 重新打包：把 orig tar 放到工作目录供 dpkg-source -b 使用
        for orig in input_dir.glob("*.orig.tar.*"):
            shutil.copyfile(orig, work / orig.name)
        run(["dpkg-source", "-b", str(source_dir)], cwd=work)
        generated = list(work.glob("*.dsc")) + list(work.glob("*.debian.tar.*")) + list(work.glob("*.diff.gz"))
        for old in list(input_dir.iterdir()):
            if old.name.endswith((".dsc", ".debian.tar.xz", ".debian.tar.gz", ".diff.gz")):
                old.unlink()
        for item in generated:
            shutil.copyfile(item, input_dir / item.name)
        print(f"applied patch via {how}; rebuilt source package in {input_dir}")
    finally:
        shutil.rmtree(work, ignore_errors=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
