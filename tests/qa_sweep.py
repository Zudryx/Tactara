#!/usr/bin/env python3
"""QA sweep for every class: runs tests/qa_sweep.lua once per class, each in a
fresh stand-in game. Usage: python3 tests/qa_sweep.py [seed] [situations per level]"""
import subprocess, sys

CLASSES = ["WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "SHAMAN", "MAGE", "WARLOCK", "DRUID"]
seed = sys.argv[1] if len(sys.argv) > 1 else "1"
per = sys.argv[2] if len(sys.argv) > 2 else "40"
failed = []
for c in CLASSES:
    r = subprocess.run([sys.executable, "tests/runlua.py", "tests/qa_sweep.lua", "Tactara", c, seed, per],
                       capture_output=True, text=True)
    out = (r.stdout + r.stderr).strip()
    print(out)
    if r.returncode != 0 or "QA SWEEP PASSED" not in out:
        failed.append(c)
print()
print("ALL CLASSES PASSED" if not failed else "PROBLEMS IN: " + ", ".join(failed))
sys.exit(1 if failed else 0)
