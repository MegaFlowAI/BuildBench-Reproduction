#!/usr/bin/env python3
"""Apply the recorded build invocation to a disposable OBS work directory."""

import hashlib
import json
import re
import shlex
import shutil
import sys
from pathlib import Path
from pilot import case_path, pilots


MLMMJ = "launchpad-questing-amd64-arm64-mlmmj-67f08081ad07"
HTML_XML_UTILS = "launchpad-resolute-amd64-arm64-html-xml-utils-fe68b3f14b84"
COWSQL = "launchpad-noble-arm64-amd64-cowsql-cfbcbf2fa889"
DNSCAP = "launchpad-resolute-arm64-amd64-dnscap-1198fcbd04b6"
LIBMAUS2 = "launchpad-oracular-amd64-arm64-libmaus2-12ed4994dfc2"
LIBAPACHE2 = "launchpad-oracular-amd64-arm64-libapache2-mod-auth-openidc-c9b2ba1cd30f"
ARCH_ONLY_RECIPE_CASES = {
    "launchpad-jammy-amd64-arm64-python-hug-c0ae7695bec4",
    "launchpad-mantic-amd64-arm64-haskell-tldr-e08dd2db85e1",
    "launchpad-noble-amd64-arm64-haskell-copilot-c99-1fb879daa3b8",
    "launchpad-oracular-amd64-arm64-python-msgspec-6f918d331f35",
    "launchpad-questing-amd64-arm64-kdsoap-95149c86d1d7",
}
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


def independent_build_deps(dsc):
    """Names listed only in Build-Depends-Indep, which -B must exclude."""
    fields = {}
    current = None
    for line in dsc.read_text(encoding="utf-8").splitlines():
        if line.startswith((" ", "\t")) and current:
            fields[current] += " " + line.strip()
        elif ": " in line:
            current, value = line.split(": ", 1)
            fields[current] = value
        else:
            current = None
    def names(field):
        return {match.group(1) for item in fields.get(field, "").split(",")
                for alternative in item.split("|")
                if (match := re.match(r"\s*([a-z0-9][a-z0-9+.-]*)", alternative))}
    return sorted(names("Build-Depends-Indep") - names("Build-Depends") - names("Build-Depends-Arch"))


def arch_only_recipe(source, target):
    """Make an unsigned disposable dsc whose dependencies match dpkg -B."""
    original = source.read_bytes()
    text = original.decode("utf-8")
    if text.startswith("-----BEGIN PGP SIGNED MESSAGE-----\n"):
        text = text.split("\n\n", 1)[1].split("\n-----BEGIN PGP SIGNATURE-----", 1)[0]
    text, removed = re.subn(r"(?m)^Build-Depends-Indep:.*(?:\n[ \t].*)*\n", "", text)
    if removed != 1:
        raise ValueError("Expected exactly one Build-Depends-Indep field")
    adjusted = (text.rstrip() + "\n").encode("utf-8")
    if target.is_file():
        temporary = target.with_name(target.name + ".buildbench-temp")
        temporary.write_bytes(adjusted)
        temporary.replace(target)  # cp -al created a hardlink; never edit its inode.
    else:
        target.write_bytes(adjusted)
    return {"reason": "OBS dsc parser includes Build-Depends-Indep despite recorded dpkg-buildpackage -B",
            "original_sha256": hashlib.sha256(original).hexdigest(),
            "effective_sha256": hashlib.sha256(adjusted).hexdigest(),
            "recipe": target.name}


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
    # Ubuntu's transition package contains links to a provider, not /bin/true.
    # Old debootstrap only extracts its fixed required list and omits that provider.
    # Keep OBS and the same historical packages; use OBS's native chroot bootstrap.
    bootstrap_reason = None
    providers = (("coreutils-from-uutils", "rust-coreutils"),
                 ("coreutils-from-gnu", "gnu-coreutils"))
    provider = next((pair for pair in providers if set(pair) <= lock_packages), None)
    if historical["architecture"] == "arm64" and provider and build_engine is None:
        for package in provider:
            if package not in bootstrap:
                bootstrap.append(package)
        config_text, count = re.subn(r"^buildengine: debootstrap$", "buildengine: none", config_text, flags=re.M)
        if count != 1:
            raise ValueError("Expected debootstrap engine before uutils bootstrap repair")
        build_engine = "none"
        bootstrap_reason = f"historical coreutils transition needs its {provider[1]} provider before chroot execution"
    if case_id == "launchpad-resolute-amd64-arm64-qmidiarp-273b2ab7f12b":
        # Fontconfig's fc-cache loads HarfBuzz through FreeType before OBS's
        # cyclic dependency ordering has installed it. Pre-extract the exact
        # historical library; retain fontconfig's original postinst and result.
        if "libharfbuzz0b" not in lock_packages:
            raise ValueError("Missing historical HarfBuzz for fontconfig bootstrap")
        bootstrap.append("libharfbuzz0b")
    if "libmd0" in lock_packages and "libmd0" not in bootstrap:
        bootstrap.append("libmd0")
    if (historical["mode"] == "-b" or case_id in ARCH_ONLY_RECIPE_CASES) and "fakeroot" in lock_packages and "fakeroot" not in bootstrap:
        # The recorded command requires fakeroot even when OBS's resolver
        # does not select it from the source's build dependencies.
        bootstrap.append("fakeroot")
    preferred = []
    ignored_indep = []
    recipe_adjustment = None
    if historical["mode"] == "-B":
        recipe = case_dir / build["recipe"]
        if not recipe.is_file():
            recipe = case_path(case_id) / build["recipe"]
        ignored_indep = independent_build_deps(recipe)
        if case_id in ARCH_ONLY_RECIPE_CASES:
            target = runtime / "input" / recipe.name
            recipe_adjustment = arch_only_recipe(recipe, target)
            shutil.copyfile(target, settings.parent / "effective-recipe-baseline-1.dsc")
    # Restoring the historical libjpeg-dev metapackage leaves two providers of
    # libjpeg-dev in OBS. Select the recorded real package, which depends on turbo.
    if "libjpeg-dev" in lock_packages and "libjpeg-dev" in historical["packages"]:
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
        "reproduction_conditions": conditions,
        "omitted_nonhistorical_duplicates": discarded,
        "omitted_independent_build_deps": ignored_indep,
        "runtime_recipe_adjustment": recipe_adjustment,
    })
    build["jobs"] = jobs
    build["recipe"] = "input/" + Path(build["recipe"]).name
    manifest["patch_policy"]["allowed_paths"] = ["input/**"]
    write_json(runtime / "manifest.json", manifest)


if __name__ == "__main__":
    prepare(*map(Path, sys.argv[1:]))
