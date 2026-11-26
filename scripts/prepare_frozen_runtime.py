#!/usr/bin/env python3
"""Apply the recorded build invocation to a disposable OBS work directory."""

import json
import re
import shlex
import hashlib
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from pilot import pilots


MLMMJ = "launchpad-questing-amd64-arm64-mlmmj-67f08081ad07"
HTML_XML_UTILS = "launchpad-resolute-amd64-arm64-html-xml-utils-fe68b3f14b84"
COWSQL = "launchpad-noble-arm64-amd64-cowsql-cfbcbf2fa889"
DNSCAP = "launchpad-resolute-arm64-amd64-dnscap-1198fcbd04b6"
LIBMAUS2 = "launchpad-oracular-amd64-arm64-libmaus2-12ed4994dfc2"
LIBAPACHE2 = "launchpad-oracular-amd64-arm64-libapache2-mod-auth-openidc-c9b2ba1cd30f"
BUILD_COMMAND = re.compile(
    rb"Command: dpkg-buildpackage (?P<sanitize>--sanitize-env )?-us -uc "
    rb"-m(?P<maintainer>Launchpad Build Daemon <buildd@[a-z0-9-]+(?:\.buildd)?>) "
    rb"(?P<mode>-[Bb]) -rfakeroot"
)


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def build_flags(reference, mode):
    if mode not in {"-B", "-b"}:
        raise ValueError("Invalid historical binary build mode")
    with reference.open("rb") as log:
        for line in log:
            if line.startswith(b"Command: dpkg-buildpackage "):
                match = BUILD_COMMAND.fullmatch(line.strip())
                if not match or match["mode"].decode("ascii") != mode:
                    raise ValueError("Historical dpkg-buildpackage command differs from the recorded form")
                sanitize = ["--sanitize-env"] if match["sanitize"] else []
                return [*sanitize, "-us", "-uc", "-m" + match["maintainer"].decode("ascii"),
                        mode, "-rfakeroot"], "recorded_command"
            if line.startswith(b"dpkg-buildpackage: info: source package "):
                break
    return ["-us", "-uc", mode, "-rfakeroot"], "catalog_build_mode"


def select_historical_versions(runtime, lock_path, build, versions):
    lock = read_json(lock_path)
    candidates = lock["dependencies"]
    available = {(item["package"], item["version"]) for item in candidates}
    directories = {name.rsplit("-", 1)[1]: runtime / name for name in build["dependency_dirs"]}
    selected = []
    discarded = []
    for item in candidates:
        package = item["package"]
        historical = versions.get(package)
        if item["version"] != historical and (package, historical) in available:
            (directories[item["arch"]] / item["filename"]).unlink(missing_ok=True)
            discarded.append(item["filename"])
        else:
            selected.append(item)
    lock["dependencies"] = selected
    lock["dependency_count"] = len(selected)
    write_json(lock_path, lock)
    return sorted(set(discarded))


def cowsql_command(runtime, command):
    helper = runtime / "input/buildbench-runtime"
    with helper.open("x", encoding="utf-8") as script:
        script.write(
            "#!/bin/sh\nset -eu\n"
            "mkdir -p /var/lib/sbuild\n"
            "cat >/var/lib/sbuild/apt.conf <<'EOF'\n"
            'APT::Install-Recommends "false";\n'
            'APT::AutoRemove::SuggestsImportant "false";\n'
            'APT::AutoRemove::RecommendsImportant "false";\n'
            'Acquire::Languages "none";\n'
            'APT::Keep-Downloaded-Packages "false";\n'
            "EOF\n"
            "chown abuild /usr/src/packages\n"
            "exec su -s /bin/sh abuild -c " + shlex.quote(
                "ulimit -n 112 && cd /usr/src/packages/BUILD && "
                "env HOME=/sbuild-nonexistent LC_ALL=C.UTF-8 LANG=C.UTF-8 "
                "V=1 TERM=unknown APT_CONFIG=/var/lib/sbuild/apt.conf " + command
            ) + "\n"
        )
    helper.chmod(0o755)
    return "/usr/src/packages/SOURCES/buildbench-runtime"


def prepare(case_dir, runtime, settings):
    manifest = read_json(case_dir / "manifest.json")
    case_id = manifest["case_id"]
    build = manifest["build"]
    # A diagnostic-only maintainer-script trap preserves fontconfig's actual
    # failure and prints its otherwise discarded chroot log. No payload changes.
    diagnostic_adjustments = []
    if case_id == "launchpad-resolute-amd64-arm64-qmidiarp-273b2ab7f12b":
        lock_path = runtime / build["dependency_lock"]
        lock = read_json(lock_path)
        for entry in lock["dependencies"]:
            if entry["package"] != "fontconfig":
                continue
            directory = next(runtime / name for name in build["dependency_dirs"] if name.endswith("-" + entry["arch"]))
            target = directory / entry["filename"]
            with tempfile.TemporaryDirectory(dir=runtime) as tmp:
                extracted = Path(tmp) / "package"
                subprocess.run(["dpkg-deb", "-R", str(target), str(extracted)], check=True, capture_output=True)
                script = extracted / "DEBIAN/postinst"
                original = script.read_text(encoding="utf-8")
                trap = "trap 'code=$?; if [ \"$code\" -ne 0 ]; then cat /var/log/fontconfig.log >&2 || :; fi; exit \"$code\"' 0\n"
                script.write_text(original.replace("set -e\n", "set -e\n" + trap, 1), encoding="utf-8")
                rebuilt = Path(tmp) / "fontconfig.deb"
                subprocess.run(["dpkg-deb", "--build", str(extracted), str(rebuilt)], check=True, capture_output=True)
                new_sha = hashlib.sha256(rebuilt.read_bytes()).hexdigest()
                diagnostic_adjustments.append({"package": "fontconfig", "original_sha256": entry["sha256"],
                                               "runtime_sha256": new_sha, "reason": "print fontconfig log on failure; preserve exit status"})
                target.unlink()  # Break cp -al link; never modify the frozen package.
                shutil.copyfile(rebuilt, target)
                entry["sha256"] = new_sha
        write_json(lock_path, lock)
    historical = read_json(Path("cases.json"))[case_id]
    jobs = historical["jobs"]
    if type(jobs) is not int or jobs < 1:
        raise ValueError("Invalid historical build parallelism")
    flags, command_source = build_flags(case_dir / "logs/target-failure.log", historical["mode"])
    command = shlex.join(["dpkg-buildpackage", *flags])
    bootstrap = []
    build_engine = None
    conditions = dict(historical.get("env") or {})
    if case_id == MLMMJ:
        bootstrap = ["libmd0", "libbsd0", "libpcre2-8-0"]
        build_engine = "none"
        command = (
            "chown --reference=/usr/src/packages/BUILD /usr/src/packages && "
            "runuser --user=abuild -- env HOME=/sbuild-nonexistent LANG=C.UTF-8 "
            "LC_ALL=C.UTF-8 V=1 TERM=unknown " + command
        )
    elif case_id == LIBAPACHE2:
        bootstrap = ["libmd0"]
    elif case_id == HTML_XML_UTILS:
        bootstrap = ["coreutils-from-uutils", "rust-coreutils"]
        build_engine = "none"
    elif case_id == COWSQL:
        command = cowsql_command(runtime, command)
        conditions.update({"build_user": "abuild", "nofile": 112})
    elif case_id == DNSCAP:
        conditions.update({"cpus": 3})
    elif case_id == LIBMAUS2:
        command = (
            "mount -t tmpfs -o ro,nosuid,nodev,noexec historical-cache-mask "
            "/sys/devices/system/cpu/cpu0/cache && " + command
        )
        conditions.update({"mask_cpu_cache": True})
    config = runtime / build["buildconfig"]
    config_text = config.read_text(encoding="utf-8").rstrip()
    if re.search(r"^Substitute:\s+dsc:build_cmd\s", config_text, re.M):
        raise ValueError("Frozen config declares its own package build command")
    if build_engine:
        config_text, count = re.subn(r"^buildengine: debootstrap$", "buildengine: " + build_engine,
                                     config_text, flags=re.M)
        if count != 1:
            raise ValueError("Expected one recorded debootstrap engine")
    preference_map = {
        "libncurses-dev": "libncurses5-dev",
        "libncurses5-dev": "libncurses-dev",
        "libfontconfig-dev": "libfontconfig1-dev",
        "libfontconfig1-dev": "libfontconfig-dev",
        "libldap-dev": "libldap2-dev",
        "libldap2-dev": "libldap-dev",
        "pkg-config": "pkgconf",
        "pkgconf": "pkg-config",
    }
    lock_packages = {item["package"] for item in read_json(runtime / build["dependency_lock"])["dependencies"]}
    # Ubuntu's transition package contains links to rust-coreutils, not /bin/true.
    # Old debootstrap only extracts its fixed required list and omits that provider.
    # Keep OBS and the same historical packages; use OBS's native chroot bootstrap
    # for these audited pilots, as already done for html-xml-utils.
    bootstrap_reason = None
    if case_id in pilots() and {"coreutils-from-uutils", "rust-coreutils"} <= lock_packages:
        for package in ("coreutils-from-uutils", "rust-coreutils"):
            if package not in bootstrap:
                bootstrap.append(package)
        config_text, count = re.subn(r"^buildengine: debootstrap$", "buildengine: none", config_text, flags=re.M)
        if count != 1:
            raise ValueError("Expected debootstrap engine before uutils bootstrap repair")
        build_engine = "none"
        bootstrap_reason = "historical coreutils transition needs its rust-coreutils provider before chroot execution"
    if "libmd0" in lock_packages and "libmd0" not in bootstrap:
        bootstrap.append("libmd0")
    preferred = []
    # Restoring the historical libjpeg-dev metapackage leaves two providers of
    # libjpeg-dev in OBS. Select the recorded real package, which depends on turbo.
    if case_id in pilots() and "libjpeg-dev" in lock_packages and "libjpeg-dev" in historical["packages"]:
        preferred.append("libjpeg-dev")
    for line in config_text.splitlines():
        if line.startswith("Ignore:"):
            for ignored in line.split()[1:]:
                candidate = preference_map.get(ignored)
                if candidate in lock_packages and candidate not in preferred:
                    preferred.append(candidate)
    if preferred:
        preference = "Prefer: " + " ".join(preferred)
        if "\nMacros:" in config_text:
            config_text = config_text.replace("\nMacros:", "\n" + preference + "\nMacros:", 1)
        else:
            config_text += "\n" + preference
    overrides = ["Substitute: dsc:build_cmd " + command]
    if bootstrap:
        overrides.append("Preinstall: " + " ".join(bootstrap))
        overrides.append("ExpandFlags: preinstallexpand")
    config.write_text("\n".join([*overrides, config_text, ""]), encoding="utf-8")
    discarded = select_historical_versions(
        runtime, runtime / build["dependency_lock"], build, historical["packages"],
    )
    write_json(settings, {
        "frozen_jobs": build["jobs"],
        "historical_jobs": jobs,
        "build_mode": historical["mode"],
        "build_command_source": command_source,
        "dpkg_buildpackage_arguments": flags,
        "bootstrap_preinstall": bootstrap,
        "build_engine_override": build_engine,
        "bootstrap_reason": bootstrap_reason,
        "diagnostic_adjustments": diagnostic_adjustments,
        "reproduction_conditions": conditions,
        "omitted_nonhistorical_duplicates": discarded,
    })
    build["jobs"] = jobs
    build["recipe"] = "input/" + Path(build["recipe"]).name
    manifest["patch_policy"]["allowed_paths"] = ["input/**"]
    write_json(runtime / "manifest.json", manifest)


if __name__ == "__main__":
    prepare(*map(Path, sys.argv[1:]))
