#!/usr/bin/env bash
# Tests for the --allow boundary in srd_extract.py. Standard library only.
set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
status=0
if PYTHONDONTWRITEBYTECODE=1 python3 -I "$here/srd_extract.py" --pdf /nonexistent monster X --vault /tmp --allow-write /tmp 2>/dev/null; then echo "FAIL --allow-write without --allow accepted"; status=1; else [ $? -eq 2 ] && echo "ok   --allow-write without --allow is refused" || { echo "FAIL wrong exit for --allow-write alone"; status=1; }; fi
PYTHONDONTWRITEBYTECODE=1 HERE="$here" python3 -I - <<'PY'
import os, sys, tempfile
from pathlib import Path
sys.path.insert(0, os.environ["HERE"])
from srd_extract import Boundary, load_lines, verified_copy, work_dir, SRD_PDF_SHA256

v = Path(tempfile.mkdtemp())
(v / "reference").mkdir(); (v / "private").mkdir()
(v / "reference/Goblin.md").write_text("x"); (v / "private/Secret.md").write_text("x")
os.symlink(v / "private", v / "reference-alias")
os.symlink(v / "reference/Goblin.md", v / "private/goblin-link.md")
fails = 0
def check(name, ok):
    global fails
    print(("ok   " if ok else "FAIL ") + name); fails += not ok
b = Boundary(v, [v / "reference"])
check("note in an allowed folder is covered", b.covers(v / "reference/Goblin.md"))
check("allowed folder is a valid output", b.covers(v / "reference"))
check("private note is not covered", not b.covers(v / "private/Secret.md"))
check("private link to an allowed note is not named", not b.covers(v / "private/goblin-link.md"))
check("output through a link to a private folder is refused", not b.covers(v / "reference-alias"))
try:
    Boundary(v, [v / "reference-alias"]); check("allow entry through a symlink is refused", False)
except SystemExit:
    check("allow entry through a symlink is refused", True)
try:
    Boundary(v, [Path(tempfile.mkdtemp())]); check("allow entry outside the vault is refused", False)
except SystemExit:
    check("allow entry outside the vault is refused", True)
os.symlink(v / "private/loop.md", v / "private/loop.md")
check("a private symlink loop is hidden, not an error", not b.covers(v / "private/loop.md"))
os.symlink(v / "reference/loop.md", v / "reference/loop.md")
check("an allowed symlink loop is hidden, not an error", not b.covers(v / "reference/loop.md"))
os.environ["XDG_CACHE_HOME"] = str(v / "user-cache")
(v / "other.pdf").write_bytes(b"not the SRD")
try:
    verified_copy(v / "other.pdf"); check("a different PDF is refused", False)
except SystemExit:
    check("a different PDF is refused", True)
old = v / "user-cache/srd/verified" / SRD_PDF_SHA256
old.mkdir(parents=True)
page = '<page number="1" width="900">\n<fontspec id="0" size="12" family="F" color="#000000"/>\n<text top="10" left="10" width="9" height="9" font="0">%s</text>\n'
(old / "p1-2.xml").write_text(page % "PLANTED")
(old / "source.pdf").write_bytes(b"planted")
(v / "bin").mkdir()
(v / "bin/pdftohtml").write_text("#!/bin/sh\nfor last; do :; done\ncat > \"$last.xml\" <<'EOF'\n" + page % "CONVERTED" + "EOF\n")
(v / "bin/pdftohtml").chmod(0o755)
os.environ["PATH"] = f"{v / 'bin'}{os.pathsep}{os.environ['PATH']}"
got = [l["text"] for l in load_lines(v / "other.pdf", 1, 2)]
check("planted parsed pages are ignored; each run converts afresh", got == ["CONVERTED"])
check("the run's files stay out of the vault and the user cache", not work_dir().is_relative_to(v))
check("the run directory is private", work_dir().stat().st_mode & 0o077 == 0)
w = Boundary(v, [v / "reference"])
(v / "party").mkdir(); read = Boundary(v, [v / "reference", v / "party"])
check("a readable folder can be named", read.covers(v / "party"))
check("but is not writable unless listed", not w.covers(v / "party"))
sys.exit(1 if fails else 0)
PY
[ $? -eq 0 ] || status=1
exit $status
