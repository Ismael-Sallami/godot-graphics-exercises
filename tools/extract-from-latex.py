#!/usr/bin/env python3
"""Pull the code out of the LaTeX write-up into standalone files.

The exercises were written up in LaTeX, with each solution inside an lstlisting
block next to its statement and its reasoning. That document is the primary
source; everything under src/sessions and src/practicals is generated from it
by this script.

Each block carries its own metadata, which this script uses:

  language=  decides the extension. Five blocks are tagged Python but are
             plainly GDScript (onready, export, $Node, _process), so they are
             written as .gd. The tag was for the syntax highlighter, which has
             no GDScript mode.
  caption=   becomes the file name when present. It beats a numbered fallback.

Every generated file gets a header saying which .tex file and section it came
from, so you can always go back to the explanation.

Usage:  python3 tools/extract-from-latex.py [latex-dir] [out-dir]

@author Ismael Sallami Moreno
"""

import pathlib
import re
import sys
import textwrap
import unicodedata

LATEX_DIR = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "docs/latex")
OUT_DIR = pathlib.Path(sys.argv[2] if len(sys.argv) > 2 else "src")

# Which .tex maps to which output folder. When the second value is set, every
# block from that file lands in it; otherwise the folder comes from the
# enclosing \section, which is what gives session-02 … session-11.
SOURCES = {
    "ejercicios-parte1.tex": ("sessions", None),
    "ejercicios-parte2.tex": ("sessions", None),
    "ejercicios_adicionales.tex": ("practicals", None),
    "pr1-2-Enunciados.tex": ("practicals", "practical-01-02"),
    "pr1-2-Resolución.tex": ("practicals", "practical-01-02"),
    "resolucionpr3.tex": ("practicals", "practical-03"),
}

# The write-up presents the ray intersection algorithms in C++, not GDScript.
EXTENSIONS = {"gdscript": ".gd", "python": ".gd", "c++": ".cpp", "": ".gd"}

BEGIN = re.compile(r"\s*\\begin\{lstlisting\}(\[.*)?$")
END = re.compile(r"\s*\\end\{lstlisting\}")
SECTION = re.compile(r"\s*\\section\*?\{(.+?)\}")
SUBSECTION = re.compile(r"\s*\\(?:sub){1,2}section\*?\{(.+?)\}")
LANGUAGE = re.compile(r"language\s*=\s*([A-Za-z+]+)")
CAPTION = re.compile(r"caption\s*=\s*\{?([^},\]]+)")

# lstlisting is verbatim, so these are escaping mistakes in the document that
# would otherwise end up in the code: "activar\_brazo", \# and friends.
LATEX_ESCAPES = re.compile(r"\\([_#&%$])")


def slug(text: str) -> str:
    """Turn a LaTeX heading or caption into a usable file or folder name."""
    text = re.sub(r"\\[a-zA-Z]+\s*", " ", text)          # drop LaTeX commands
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode()
    text = re.sub(r"[^a-zA-Z0-9]+", "-", text).strip("-").lower()
    # "sesion 7" and "practica 2" become session-07 and practical-02
    if m := re.match(r"^(sesion|practica)-(\d+)$", text):
        kind = "session" if m.group(1) == "sesion" else "practical"
        return f"{kind}-{int(m.group(2)):02d}"
    return text[:60] or "misc"


def extract(path: pathlib.Path, group: str, fixed_folder: str | None) -> int:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    section = subsection = ""
    written = 0
    counters: dict[tuple[str, str], int] = {}

    i = 0
    while i < len(lines):
        line = lines[i]

        if m := SECTION.match(line):
            section, subsection = m.group(1), ""
        elif m := SUBSECTION.match(line):
            subsection = m.group(1)

        if m := BEGIN.match(line):
            options = m.group(1) or ""
            body, i = [], i + 1
            while i < len(lines) and not END.match(lines[i]):
                body.append(lines[i])
                i += 1

            # lstlisting blocks are indented to sit nicely on the page. That
            # indentation is layout, not code, so strip the common prefix or
            # GDScript reads the whole file as one nested block.
            code = LATEX_ESCAPES.sub(r"\1", textwrap.dedent("\n".join(body))).strip("\n")
            if not code:
                i += 1
                continue

            lang = (m.group(1) and (lm := LANGUAGE.search(options)) and lm.group(1) or "").lower()
            caption = (cm := CAPTION.search(options)) and cm.group(1).strip() or ""

            folder = OUT_DIR / group / (fixed_folder or slug(section or path.stem))
            folder.mkdir(parents=True, exist_ok=True)

            # A caption names the block far better than a counter can.
            base = slug(caption or subsection or (section if fixed_folder else "") or "solution")
            key = (str(folder), base)
            counters[key] = counters.get(key, 0) + 1
            name = base if counters[key] == 1 else f"{base}-{counters[key]}"

            where = section + (f" / {subsection}" if subsection else "")
            header = [
                "# Extracted from the LaTeX write-up.",
                f"# Source: docs/latex/{path.name} — {where}",
            ]
            if caption:
                header.append(f"# Caption: {caption}")
            if lang == "python":
                header.append("# Tagged language=Python in the document, for the syntax")
                header.append("# highlighter. The code is GDScript.")
            header.append("# Regenerate with: python3 tools/extract-from-latex.py")

            comment = "//" if lang == "c++" else "#"
            text = "\n".join(h.replace("#", comment, 1) for h in header) + "\n\n" + code + "\n"

            (folder / f"{name}{EXTENSIONS.get(lang, '.gd')}").write_text(text, encoding="utf-8")
            written += 1
        i += 1
    return written


def main() -> None:
    total = 0
    for filename, (group, fixed_folder) in SOURCES.items():
        path = LATEX_DIR / filename
        if not path.exists():
            print(f"skip: {path} not found")
            continue
        n = extract(path, group, fixed_folder)
        print(f"{path.name}: {n} blocks")
        total += n
    print(f"total: {total} files written under {OUT_DIR}/")


if __name__ == "__main__":
    main()
