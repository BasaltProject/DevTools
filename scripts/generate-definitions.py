#!/usr/bin/env python3
"""Refreshes definitions/<target>/basalt.qzi from the interface the product writes at startup.

usage: generate-definitions.py <target> <product binary | host interface file> [out.qzi]

A binary is started with a scratch plugins folder, and the interface it writes there is copied once it is complete.
"""
import os
import pathlib
import shutil
import subprocess
import sys
import tempfile
import time

TARGETS = {"server": ("host.qzi", "org.basaltmc.server"), "proxy": ("proxy.qzi", "org.basaltmc.proxy")}


def from_product(binary: str, name: str) -> str:
    with tempfile.TemporaryDirectory(prefix="basalt-devtools-") as work:
        plugins = pathlib.Path(work, "plugins")
        plugins.mkdir()
        env = dict(os.environ, BASALT_QUARTZ_DIR=str(plugins))
        args = [os.path.abspath(binary)] + (["--accept-eula"] if "Server" in os.path.basename(binary) else
                                            ["--config", str(pathlib.Path(work, "config"))])
        process = subprocess.Popen(args, cwd=work, env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        try:
            deadline = time.time() + 180
            while time.time() < deadline and not (plugins / name).exists():
                time.sleep(0.5)
            time.sleep(1)
            return (plugins / name).read_text(encoding="utf-8")
        finally:
            process.terminate()
            process.wait(timeout=30)


def main() -> int:
    if len(sys.argv) not in (3, 4) or sys.argv[1] not in TARGETS:
        print(__doc__, file=sys.stderr)
        return 2
    target, source = sys.argv[1], sys.argv[2]
    name, package = TARGETS[target]
    text = pathlib.Path(source).read_text(encoding="utf-8") if source.endswith(".qzi") else from_product(source, name)
    if not text.startswith(f"package {package}\n"):
        print(f"the interface does not start with `package {package}`", file=sys.stderr)
        return 1
    out = pathlib.Path(sys.argv[3] if len(sys.argv) == 4 else f"definitions/{target}/basalt.qzi")
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding="utf-8")
    return 0


sys.exit(main())
