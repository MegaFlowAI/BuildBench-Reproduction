#!/usr/bin/env python3
"""Apply the recorded build invocation to a disposable OBS work directory."""

import json
import re
import shlex
import sys
from pathlib import Path


MLMMJ = "launchpad-questing-amd64-arm64-mlmmj-67f08081ad07"
HTML_XML_UTILS = "launchpad-resolute-amd64-arm64-html-xml-utils-fe68b3f14b84"
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


def prepare(case_dir, runtime, settings):
    manifest = read_json(case_dir / "manifest.json")
    case_id = manifest["case_id"]
    build = manifest["build"]
    historical = read_json(Path("cases.json"))[case_id]
    jobs = historical["jobs"]
    if type(jobs) is not int or jobs < 1:
        raise ValueError("Invalid historical build parallelism")
    flags, command_source = build_flags(case_dir / "logs/target-failure.log", historical["mode"])
    command = shlex.join(["dpkg-buildpackage", *flags])
    bootstrap = []
    build_engine = None
    if case_id == MLMMJ:
        bootstrap = ["libmd0", "libbsd0", "libpcre2-8-0"]
        build_engine = "none"
        command = (
            "chown --reference=/usr/src/packages/BUILD /usr/src/packages && "
            "runuser --user=abuild -- env HOME=/sbuild-nonexistent LANG=C.UTF-8 "
            "LC_ALL=C.UTF-8 V=1 TERM=unknown " + command
        )
    elif case_id == HTML_XML_UTILS:
        bootstrap = ["coreutils-from-uutils", "rust-coreutils"]
        build_engine = "none"
    config = runtime / build["buildconfig"]
    config_text = config.read_text(encoding="utf-8").rstrip()
    if re.search(r"^Substitute:\s+dsc:build_cmd\s", config_text, re.M):
        raise ValueError("Frozen config declares its own package build command")
    if build_engine:
        config_text, count = re.subn(r"^buildengine: debootstrap$", "buildengine: " + build_engine,
                                     config_text, flags=re.M)
        if count != 1:
            raise ValueError("Expected one recorded debootstrap engine")
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
        "omitted_nonhistorical_duplicates": discarded,
    })
    build["jobs"] = jobs
    build["recipe"] = "input/" + Path(build["recipe"]).name
    manifest["patch_policy"]["allowed_paths"] = ["input/**"]
    write_json(runtime / "manifest.json", manifest)


if __name__ == "__main__":
    prepare(*map(Path, sys.argv[1:]))
