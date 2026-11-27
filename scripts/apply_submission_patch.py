#!/usr/bin/env python3
"""把提交的 change.patch 应用到冻结用例的源码包，生成一个新的用例目录。

做法（不依赖 quilt 补丁栈）：解包 dsc → 应用 change.patch → 用补丁后的源码树
重建 orig tar 与 debian tar → 重新生成 .dsc 校验和 → 替换 source/input。
validator 之后照常从 dsc 解包构建，补丁已经真正进入源码包。
"""
import hashlib
import shutil
import subprocess
import sys
import tarfile
import tempfile
from pathlib import Path

STRIP_LEVELS = ("1", "2", "0", "3", "4")


def copy_tree(source: Path, target: Path) -> None:
    shutil.copytree(source, target, symlinks=True, copy_function=shutil.copy2)


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
            subprocess.run(["git", "apply", "-R", f"-p{level}", str(patch_copy)],
                           cwd=source_dir, capture_output=True)
            subprocess.run(["patch", "-R", f"-p{level}", "--batch", "--forward", "--silent", "-i", str(patch_copy)],
                           cwd=source_dir, capture_output=True)
    raise SystemExit("change.patch 无法应用到源码：" + " | ".join(errors[-4:]))


def digests(path: Path) -> tuple[str, str, str, int]:
    data = path.read_bytes()
    return hashlib.md5(data).hexdigest(), hashlib.sha1(data).hexdigest(), hashlib.sha256(data).hexdigest(), len(data)


def make_tar(tar_path: Path, root: Path, arcname: str, skip_debian: bool) -> None:
    suffix_map = {".xz": "w:xz", ".gz": "w:gz", ".bz2": "w:bz2"}
    mode = None
    for suffix, candidate in suffix_map.items():
        if tar_path.name.endswith(suffix):
            mode = candidate
            break
    if mode is None:
        raise SystemExit(f"unsupported tar suffix: {tar_path.name}")

    def _filter(info):
        if skip_debian and (info.name == "debian" or info.name.startswith("debian/")):
            return None
        return info

    with tarfile.open(tar_path, mode) as handle:
        handle.add(root, arcname=arcname, filter=_filter)


def parse_dsc_fields(text: str) -> tuple[dict[str, str], list[str]]:
    fields: dict[str, str] = {}
    order: list[str] = []
    key = None
    for line in text.splitlines():
        if line[:1] in (" ", "\t") and key:
            fields[key] += "\n" + line
            continue
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        fields[key] = value.strip()
        order.append(key)
    return fields, order


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
    dsc_fields, dsc_order = parse_dsc_fields(dsc.read_text(encoding="utf-8", errors="replace"))
    work = Path(tempfile.mkdtemp(dir=str(out_dir.parent)))
    try:
        run(["dpkg-source", "-x", str(dsc), str(work / "src")], cwd=work)
        source_dir = work / "src"
        how = apply_patch(source_dir, patch_file, work)
        source = dsc_fields["Source"]
        version = dsc_fields["Version"]
        upstream = version.rsplit("-", 1)[0] if "-" in version else version
        orig_name = f"{source}_{upstream}.orig.tar.gz"
        debian_ext = ".debian.tar.xz" if list(input_dir.glob("*.debian.tar.xz")) else ".debian.tar.gz"
        debian_name = f"{source}_{version}{debian_ext}"
        orig_path = work / orig_name
        debian_path = work / debian_name
        make_tar(orig_path, source_dir, arcname=f"{source}-{upstream}", skip_debian=True)
        make_tar(debian_path, source_dir / "debian", arcname="debian", skip_debian=False)
        entries = []
        for path in (orig_path, debian_path):
            md5, sha1, sha256, size = digests(path)
            entries.append((path.name, size, md5, sha1, sha256))
        dsc_fields["Files"] = "\n " + "\n ".join(f"{md5} {size} {name}" for name, size, md5, _s1, _s256 in entries)
        dsc_fields["Checksums-Sha1"] = "\n " + "\n ".join(f"{s1} {size} {name}" for name, size, _m, s1, _s256 in entries)
        dsc_fields["Checksums-Sha256"] = "\n " + "\n ".join(f"{s256} {size} {name}" for name, size, _m, _s1, s256 in entries)
        out_dsc = work / dsc.name
        out_dsc.write_text("\n".join(f"{key}: {dsc_fields[key]}" for key in dsc_order) + "\n", encoding="utf-8")
        for old in list(input_dir.iterdir()):
            if old.name.endswith((".dsc", ".orig.tar.gz", ".orig.tar.xz", ".orig.tar.bz2",
                                  ".debian.tar.xz", ".debian.tar.gz", ".diff.gz")):
                old.unlink()
        shutil.copyfile(out_dsc, input_dir / dsc.name)
        shutil.copyfile(orig_path, input_dir / orig_name)
        shutil.copyfile(debian_path, input_dir / debian_name)
        print(f"applied patch via {how}; rebuilt source package in {input_dir}")
        print("files:", sorted(p.name for p in input_dir.iterdir()))
    finally:
        shutil.rmtree(work, ignore_errors=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
