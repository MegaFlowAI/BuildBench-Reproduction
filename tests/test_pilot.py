import contextlib
import gzip
import io
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import compare_failure_log as compare
import check_baseline
import pilot
import prepare_frozen_runtime


class VerdictTests(unittest.TestCase):
    """Synthetic unit fixtures are deliberately separate from observed run evidence."""
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.cid = "launchpad-questing-amd64-arm64-golf-baef926efdc3"
        self.case = self.root / "case"
        self.case.mkdir()
        (self.case / "case.json").write_text(json.dumps({"case_id": self.cid, "platform": {"target_arch": "aarch64"}}))
        self.out = self.root / "output"
        self.out.mkdir()
        self.ref = self.root / "reference.log"
        self.diagnostic = "cc1: error: '-fcf-protection=full' is not supported for this target"
        self.ref.write_text(self.diagnostic + "\n", encoding="utf-8")
        self.lines = ["Using BUILD_ROOT=/tmp/root", "installing gcc...", "dpkg-source: info: extracting golf",
                      "dpkg-buildpackage: info: source package golf", "dpkg-buildpackage: info: host architecture arm64",
                      self.diagnostic, "dpkg-buildpackage: error: debian/rules binary-arch subprocess returned exit status 2",
                      '[build-case] [event] {"event":"stage","stage":"package_build","state":"failed"}']
        self.result = {"status": "failed", "build_exit_code": 1, "target_arch": "aarch64", "timed_out": False}

    def run_verdict(self, code=1):
        (self.out / "build.log").write_text("\n".join("[ 1s] " + line for line in self.lines) + "\n", encoding="utf-8")
        (self.out / "build-result.json").write_text(json.dumps(self.result), encoding="utf-8")
        dest = self.root / "verdict.json"
        with patch.object(sys, "argv", ["compare", str(self.case), str(self.ref), str(self.out), str(code), str(dest)]), contextlib.redirect_stdout(io.StringIO()):
            compare.main()
        return json.loads(dest.read_text(encoding="utf-8"))

    def test_architecture_failure_matches(self):
        self.assertEqual(self.run_verdict()["category"], "isa_failure_reproduced")

    def test_infrastructure_is_not_package_failure(self):
        self.lines = ["Using BUILD_ROOT=/tmp/root", "installing gcc...", "----- building golf",
                      "dpkg: error while loading shared libraries: libmd.so.0", 'failed "build golf"',
                      '[build-case] [event] {"event":"stage","stage":"build_setup","state":"failed"}']
        r = self.run_verdict()
        self.assertFalse(r["package_failed"])
        self.assertEqual(r["category"], "infrastructure")

    def test_extra_failure_rejected(self):
        self.lines.append("other.c:2: fatal error: missing_environment.h: No such file or directory")
        self.assertEqual(self.run_verdict()["category"], "diagnostic_mismatch")

    def test_missing_architecture_error_rejected(self):
        self.lines.remove(self.diagnostic)
        self.assertEqual(self.run_verdict()["status"], "mismatch")

    def test_wrong_target_rejected(self):
        self.result["target_arch"] = "x86_64"
        self.assertEqual(self.run_verdict()["status"], "mismatch")

    def test_timeout_rejected_despite_matching_error(self):
        self.result["timed_out"] = True
        self.assertEqual(self.run_verdict(124)["category"], "timeout")

    def test_success_rejected_despite_error_text(self):
        self.result.update(status="succeeded", build_exit_code=0)
        self.assertEqual(self.run_verdict(0)["category"], "unexpected_success")

    def test_empty_reference_rejected(self):
        self.ref.write_text("no diagnostic\n")
        self.assertEqual(self.run_verdict()["status"], "mismatch")

    def test_gzip_reference(self):
        raw = self.ref.read_bytes()
        self.ref = self.ref.with_suffix(".log.gz")
        self.ref.write_bytes(gzip.compress(raw))
        self.assertEqual(self.run_verdict()["category"], "isa_failure_reproduced")

    def test_compiler_source_excerpt_is_not_diagnostic(self):
        source = self.root / "excerpt.log"
        source.write_text('5955 | asprintf(&message, "RXTX Error: Unable");\nRawImp.c:131:12: error: implicit declaration of function ioperm\n')
        signatures = check_baseline.fingerprints(source, None)
        self.assertEqual(len(signatures), 1)
        self.assertIn("RawImp.c:131:12", next(iter(signatures)))

    def test_cmake_multiline_error_is_preserved(self):
        self.cid = "launchpad-noble-amd64-arm64-ectrans-50e45e72102d"
        (self.case / "case.json").write_text(json.dumps({"case_id": self.cid, "platform": {"target_arch": "aarch64"}}))
        diagnostic = 'CMake Error in src/trans/CMakeLists.txt:\n  Imported target "fiat" includes non-existent path\n    "/missing/fiat"'
        self.ref.write_text(diagnostic + "\n", encoding="utf-8")
        self.lines = [*self.lines[:5], *diagnostic.splitlines(), *self.lines[6:]]
        verdict = self.run_verdict()
        self.assertGreater(verdict["reference_diagnostics"], 0)
        self.assertEqual(verdict["category"], "historical_failure_reproduced")


class InputTests(unittest.TestCase):
    def test_binary_arch_build_omits_independent_dependencies(self):
        cid = "launchpad-jammy-amd64-arm64-python-hug-c0ae7695bec4"
        dsc = next((pilot.case_path(cid) / "source/input").glob("*.dsc"))
        omitted = prepare_frozen_runtime.independent_build_deps(dsc)
        self.assertIn("python3-falcon", omitted)
        self.assertIn("python3-pytest-cov", omitted)
        self.assertNotIn("python3-setuptools", omitted)

    def test_fontconfig_bootstrap_preserves_dependency_bytes(self):
        cid = "launchpad-resolute-amd64-arm64-qmidiarp-273b2ab7f12b"
        original = pilot.case_path(cid)
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            case, runtime = root / "case", root / "runtime"
            (case / "logs").mkdir(parents=True)
            (runtime / "input").mkdir(parents=True)
            (case / "logs/target-failure.log").write_bytes(pilot.reference_bytes(original / "logs/target-failure.log.gz"))
            shutil.copyfile(original / "manifest.json", case / "manifest.json")
            shutil.copytree(original / "config", runtime / "config")
            settings = root / "settings.json"
            prepare_frozen_runtime.prepare(case, runtime, settings)
            self.assertIn("libharfbuzz0b", pilot.read_json(settings)["bootstrap_preinstall"])
            self.assertEqual(pilot.read_json(runtime / "config/dependency-lock.json"), pilot.read_json(original / "config/dependency-lock.json"))

    def test_recovered_jpeg_package_resolves_provider_ambiguity(self):
        cid = "launchpad-mantic-amd64-arm64-r-cran-digest-7a42effc961f"
        original = pilot.case_path(cid)
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            case, runtime = root / "case", root / "runtime"
            (case / "logs").mkdir(parents=True)
            (runtime / "input").mkdir(parents=True)
            (case / "logs/target-failure.log").write_bytes(pilot.reference_bytes(original / "logs/target-failure.log.gz"))
            shutil.copyfile(original / "manifest.json", case / "manifest.json")
            shutil.copytree(original / "config", runtime / "config")
            lock_path = runtime / "config/dependency-lock.json"
            lock = pilot.read_json(lock_path)
            lock["dependencies"].append({"package": "libjpeg-dev", "version": "8c-2ubuntu11", "arch": "arm64", "filename": "libjpeg-dev.deb", "sha256": "unit-fixture"})
            lock_path.write_text(json.dumps(lock))
            prepare_frozen_runtime.prepare(case, runtime, root / "settings.json")
            config = next((runtime / "config").glob("*buildconfig")).read_text()
            self.assertRegex(config, r"Prefer: libjpeg-dev(?:\s|$)")
            self.assertTrue(any(i["package"] == "libjpeg-turbo8-dev" for i in pilot.read_json(lock_path)["dependencies"]))

    def test_ten_official_sources_and_root_signatures(self):
        self.assertEqual(len(pilot.pilots()), 10)
        for cid in pilot.pilots():
            self.assertEqual(pilot.audit(cid)["status"], "inputs_verified_build_not_run")

    def test_uutils_bootstrap_keeps_historical_sources_and_versions(self):
        cid = "launchpad-resolute-amd64-arm64-rust-hamming-rs-d570e1d85c81"
        original = pilot.case_path(cid)
        before = pilot.digest(original / "manifest.json")
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            case = root / "case"
            runtime = root / "runtime"
            (case / "logs").mkdir(parents=True)
            (runtime / "input").mkdir(parents=True)
            (case / "logs/target-failure.log").write_bytes(pilot.reference_bytes(original / "logs/target-failure.log.gz"))
            shutil.copyfile(original / "manifest.json", case / "manifest.json")
            shutil.copytree(original / "config", runtime / "config")
            settings = root / "settings.json"
            prepare_frozen_runtime.prepare(case, runtime, settings)
            result = pilot.read_json(settings)
            self.assertEqual(result["build_engine_override"], "none")
            self.assertIn("rust-coreutils", result["bootstrap_preinstall"])
            self.assertIn("libmd0", result["bootstrap_preinstall"])
            self.assertEqual(pilot.read_json(runtime / "config/dependency-lock.json"), pilot.read_json(original / "config/dependency-lock.json"))
        self.assertEqual(pilot.digest(original / "manifest.json"), before)


if __name__ == "__main__":
    unittest.main()

