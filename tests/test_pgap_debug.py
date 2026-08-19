#!/usr/bin/env python3
"""Focused tests for pgap.py debug-retention behavior."""

from contextlib import redirect_stderr, redirect_stdout
import importlib.util
import io
import os
from pathlib import Path
import subprocess
import sys
import tempfile
from types import SimpleNamespace
import unittest


REPO_ROOT = Path(__file__).resolve().parents[1]
PGAP_PATH = REPO_ROOT / "scripts" / "pgap.py"
SPEC = importlib.util.spec_from_file_location("pgap_script", PGAP_PATH)
PGAP = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(PGAP)


class DebugCommandLineTests(unittest.TestCase):
    def test_argument_normalization(self):
        debug_levels = ("none", "failed", "all")
        cases = [
            (["--debug", "failed", "input.yaml"],
             ["--debug", "failed", "input.yaml"]),
            (["--debug", "input.yaml"], ["--debug=all", "input.yaml"]),
            (["-d", "input.yaml"], ["--debug=all", "input.yaml"]),
            (["input.yaml", "--debug"], ["input.yaml", "--debug=all"]),
            (["-d=none", "input.yaml"], ["--debug=none", "input.yaml"]),
        ]
        for arguments, expected in cases:
            with self.subTest(arguments=arguments):
                self.assertEqual(
                    expected,
                    PGAP.normalize_debug_argv(arguments, debug_levels),
                )

    def test_help_and_invalid_value(self):
        help_result = subprocess.run(
            [sys.executable, str(PGAP_PATH), "--help"],
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(0, help_result.returncode)
        self.assertIn("--debug [LEVEL]", help_result.stdout)
        self.assertIn("Default (no -d/--debug): failed", help_result.stdout)
        self.assertIn("-d or --debug alone means all", help_result.stdout)

        invalid = subprocess.run(
            [sys.executable, str(PGAP_PATH), "--debug=everything"],
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(2, invalid.returncode)
        self.assertIn("invalid choice: 'everything'", invalid.stderr)


class DebugPolicyTests(unittest.TestCase):
    def make_pipeline(self, output, level, runtime):
        pipeline = PGAP.Pipeline.__new__(PGAP.Pipeline)
        pipeline.params = SimpleNamespace(
            args=SimpleNamespace(
                cpus=0,
                no_internet=False,
                memory=None,
                debug=level,
                container_name=None,
                container_path=None,
            ),
            docker_cmd=runtime,
            docker_type=runtime,
            docker_user_remap=False,
            docker_image="example/pgap:test",
            outputdir=str(output),
        )
        pipeline.data_dir = str(output / "input-data")
        pipeline.input_dir = str(output / "user-input")
        return pipeline

    def test_full_runtime_debugging_is_all_only(self):
        builders = (
            ("docker", "make_docker_cmd", "/log/srv:z"),
            ("podman", "make_podman_cmd", "--log-level"),
            ("singularity", "make_singularity_cmd", "/log/srv"),
        )
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            for runtime, builder, marker in builders:
                for level in ("none", "failed", "all"):
                    with self.subTest(runtime=runtime, level=level):
                        pipeline = self.make_pipeline(root, level, runtime)
                        getattr(pipeline, builder)()
                        command = " ".join(pipeline.cmd)
                        self.assertEqual(level == "all", marker in command)


class DebugCleanupTests(unittest.TestCase):
    def make_child(self, output, kind, name):
        child = output / "debug" / kind / name
        child.mkdir(parents=True)
        (child / "evidence.log").write_text(name, encoding="utf-8")
        return child

    def write_log(self, output, contents):
        log = output / "cwltool.log"
        log.write_text(contents, encoding="utf-8")
        return log

    def test_success_removes_debug_tree(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            output = Path(temp_dir) / "output"
            self.make_child(output, "tmp-outdir", "successful")
            log = self.write_log(output, "successful run\n")
            PGAP.finalize_debug_artifacts(str(output), str(log), 0, "failed")
            self.assertFalse((output / "debug").exists())

    def test_failure_keeps_only_mapped_failed_paths(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            output = Path(temp_dir) / "output"
            failed = self.make_child(output, "tmp-outdir", "failed-job")
            upstream = self.make_child(output, "tmp-outdir", "upstream")
            staging = self.make_child(output, "tmpdir", "staging")
            unrelated = self.make_child(output, "tmp-outdir", "unrelated")
            log = self.write_log(
                output,
                """[2026-08-18 10:00:00] DEBUG [step failed] input /pgap/output/debug/tmp-outdir/upstream/result.asn
[2026-08-18 10:00:01] INFO [job failed] /pgap/output/debug/tmp-outdir/failed-job$ false
[2026-08-18 10:00:02] DEBUG [job failed] staging /pgap/output/debug/tmpdir/staging
[2026-08-18 10:00:03] WARNING [job failed] completed permanentFail
""",
            )
            PGAP.finalize_debug_artifacts(str(output), str(log), 1, "failed")
            self.assertTrue(failed.exists())
            self.assertTrue(upstream.exists())
            self.assertTrue(staging.exists())
            self.assertFalse(unrelated.exists())

    def test_partial_mapping_retains_everything(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            output = Path(temp_dir) / "output"
            mapped = self.make_child(output, "tmp-outdir", "mapped")
            unrelated = self.make_child(output, "tmp-outdir", "unrelated")
            log = self.write_log(
                output,
                """[2026-08-18 10:00:01] INFO [job mapped] /pgap/output/debug/tmp-outdir/mapped$ false
[2026-08-18 10:00:02] WARNING [job mapped] completed permanentFail
[2026-08-18 10:00:03] WARNING [job unmapped] completed permanentFail
""",
            )
            with redirect_stderr(io.StringIO()) as stderr:
                PGAP.finalize_debug_artifacts(str(output), str(log), 1, "failed")
            self.assertTrue(mapped.exists())
            self.assertTrue(unrelated.exists())
            self.assertIn("retaining all debug evidence", stderr.getvalue().lower())

    @unittest.skipUnless(hasattr(os, "symlink"), "symlinks are unavailable")
    def test_pruning_does_not_follow_symlinks(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            output = root / "output"
            failed = self.make_child(output, "tmp-outdir", "failed")
            outside = root / "outside"
            outside.mkdir()
            sentinel = outside / "do-not-delete.txt"
            sentinel.write_text("safe", encoding="utf-8")
            link = output / "debug" / "tmp-outdir" / "unrelated-link"
            link.symlink_to(outside, target_is_directory=True)
            log = self.write_log(
                output,
                """[2026-08-18 10:00:01] INFO [job failed] /pgap/output/debug/tmp-outdir/failed$ false
[2026-08-18 10:00:02] WARNING [job failed] completed permanentFail
""",
            )
            PGAP.finalize_debug_artifacts(str(output), str(log), 1, "failed")
            self.assertTrue(failed.exists())
            self.assertFalse(link.exists())
            self.assertEqual("safe", sentinel.read_text(encoding="utf-8"))


class PipelineLaunchTests(unittest.TestCase):
    def make_pipeline(self, output, command):
        output.mkdir()
        yaml = output / "input.yaml"
        yaml.write_text("test: true\n", encoding="utf-8")
        pipeline = PGAP.Pipeline.__new__(PGAP.Pipeline)
        pipeline.params = SimpleNamespace(
            outputdir=str(output),
            args=SimpleNamespace(debug="failed"),
        )
        pipeline.yaml = str(yaml)
        pipeline.pipename = "TEST"
        pipeline.cmd = command
        return pipeline

    def test_launch_retains_failure_evidence_and_cleans_success(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            failed_output = root / "failed-output"
            failed_pipeline = self.make_pipeline(
                failed_output,
                [
                    "sh", "-c",
                    "printf '%s\\n' "
                    "'[2026-08-18 10:00:01] INFO [job failed] /pgap/output/debug/tmp-outdir/failed$ false' "
                    "'[2026-08-18 10:00:02] WARNING [job failed] completed permanentFail'; exit 7",
                ],
            )
            failed = failed_output / "debug" / "tmp-outdir" / "failed"
            failed.mkdir(parents=True)
            diagnostic = failed_output / "initial_asnval_diag.xml"
            diagnostic.write_text("<failure/>\n", encoding="utf-8")
            with redirect_stdout(io.StringIO()):
                self.assertEqual(7, failed_pipeline.launch())
            self.assertTrue(failed.exists())
            self.assertTrue(diagnostic.exists())

            successful_output = root / "successful-output"
            successful_pipeline = self.make_pipeline(
                successful_output, ["sh", "-c", "exit 0"]
            )
            (successful_output / "debug" / "tmp-outdir" / "successful").mkdir(
                parents=True
            )
            diagnostic = successful_output / "final_asnval_diag.xml"
            diagnostic.write_text("<success/>\n", encoding="utf-8")
            with redirect_stdout(io.StringIO()):
                self.assertEqual(0, successful_pipeline.launch())
            self.assertFalse((successful_output / "debug").exists())
            self.assertFalse(diagnostic.exists())


if __name__ == "__main__":
    unittest.main()
