# godot-graphics-exercises

![godot](https://img.shields.io/badge/godot-4.x-478CBF)
![gdscript](https://img.shields.io/badge/gdscript-2425%20lines-355570)
[![build](https://img.shields.io/github/actions/workflow/status/Ismael-Sallami/godot-graphics-exercises/ci.yml?branch=main&logo=github&label=build)](https://github.com/Ismael-Sallami/godot-graphics-exercises/actions/workflows/ci.yml)
![license](https://img.shields.io/badge/license-MIT-4c1)

Computer graphics exercises in Godot: procedural meshes, hierarchical 2D models, lighting,
ray intersection and parametric animation. Sixty-seven scripts, extracted from the LaTeX
write-up where each one sits next to its statement and its reasoning.

## Context

Coursework for **IG — Computer Graphics**, year 4 of the double degree in Computer Science
and Business Administration, University of Granada (2024–2025). Solo work.

The course runs as eleven lab sessions plus three practicals. I wrote the whole thing up in
LaTeX rather than keeping loose script files: every exercise has its statement, the maths
behind it, and the code. That document is the source of truth, and this repository is
generated from it.

## The problem

Build, from scratch and without a rendering engine doing the work for you, the pieces a 3D
renderer is made of:

- **Meshes.** Indexed and non-indexed, in 2D and 3D. Triangle strips, spatial enumeration,
  surfaces of revolution, per-vertex and per-face colour, texture coordinates.
- **Hierarchical models.** A scene tree where each node carries its own transform, so a
  figure is composed of reusable parts placed by matrix products.
- **Lighting.** The pseudo-specular term of the Phong and Blinn-Phong models, written out
  as functions.
- **Ray intersection.** Ray against triangle, disc, sphere and bounded quadrics, with the
  algebra worked through before the code.
- **Animation.** Position and rotation as functions of time: Hermite interpolation, a
  pendulum, an analogue clock, ballistic motion.

## The solution

**The write-up is the source, the code is generated.** Keeping the exercises in LaTeX means
each solution stays next to the reasoning that produced it — which for graphics is most of
the value, because the code is short and the derivation is not. The cost is that the code
is trapped in a document. `tools/extract-from-latex.py` solves that: it walks the
`lstlisting` blocks and writes them out as real files, using each block's own metadata.

That metadata turned out to be worth reading:

- **`caption=`** names the file. `script-del-reloj-analogico.gd` beats `solution-7.gd`.
- **`language=`** picks the extension. Five blocks in the ray-intersection sessions are
  C++, not GDScript, and now carry `.cpp`.
- Five blocks tagged `language=Python` are plainly GDScript — `onready`, `export`, `$Node`,
  `_process`. The tag was for the syntax highlighter, which has no GDScript mode. They are
  written as `.gd`, and each one says so in its header.

Every generated file carries a header pointing back at the `.tex` file and section it came
from, so the explanation is always one click away.

**CI checks the two halves have not drifted.** `make diff-check` regenerates everything and
fails if the result differs from what is committed. Without that, editing the LaTeX and
forgetting to re-extract would leave the repository quietly wrong.

**Known-bad files are listed, not hidden.** Six scripts do not parse as Godot 4 GDScript.
`tools/check.sh` skips exactly those, each with its reason in
`tools/known-parse-failures.txt`, and fails on anything else — so a newly broken file
cannot slip in behind them.

## Layout

```
src/problems/       20 scripts kept as files: the numbered theory problems
src/sessions/       47 blocks extracted from the write-up, by lab session
src/practicals/     the three practicals
docs/latex/         the LaTeX write-up these are generated from
tools/              the extractor and the parse check
```

Session by session:

| | |
| --- | --- |
| 02 | 2D meshes, non-indexed, and autoload helper scripts |
| 03 | Dot product from coordinates; `ArrayMesh` built by hand |
| 04 | Spatial enumeration of a sphere; triangle strip storage |
| 06 | A `Camera3D` that tracks a moving target every frame |
| 07 | Pseudo-specular reflectivity: Phong and Blinn-Phong |
| 08 | Indexed cube with per-face texture coordinates, as a die |
| 09 | Key press and release handling; ray-triangle intersection with barycentric coordinates |
| 10 | Ray against disc, sphere and bounded quadrics *(C++ in the write-up)* |
| 11 | Parametric animation: Hermite, pendulum, analogue clock, ballistic motion |

Session 5, on hierarchical 2D models, has no code block in the write-up. Its work is in
`src/problems/` instead: `problema_5_1` to `problema_5_5` and
`funciones_auxiliares_t5.gd`, which builds a house out of reusable parts.

## Requirements

- **Godot 4.x** to run the scripts.
- **Python 3.12** and **gdtoolkit 4** for the extractor and the parse check:

  ```bash
  pip install 'gdtoolkit==4.*'
  ```

## Build and run

There is nothing to compile. What the CI does:

```bash
make check        # parse every .gd file
make extract      # regenerate src/sessions and src/practicals from docs/latex
make diff-check   # fail if the two have drifted apart
make lint         # gdlint, reported not enforced
```

To use a script in Godot: create a node of the type its `extends` line names, attach the
script, and run the scene. `src/problems/Global.gd` is meant to be an autoload.

## Results

Sixty-seven files, **2,425 lines** of code:

| | |
| --- | --- |
| GDScript | 62 files |
| C++ | 5 files (the ray intersection algorithms) |
| Parse cleanly as Godot 4 | 56 of 62 |
| Known failures, each with a reason | 6 |

The write-up itself, with the figures and the derivations, is the PDF published at
[elblogdeismael.github.io](https://elblogdeismael.github.io/), filed under the fourth-year
computer graphics course. The blog's menus are in Spanish, so look for `Cuarto Curso` and
then `Informática Gráfica`.

## What I learned

- **Writing it up in LaTeX was the right call and the wrong storage.** Keeping the algebra
  next to the code is what made the ray-intersection sessions make sense months later. But
  a document is not a repository: nothing in it can be parsed, linted or run. Extracting it
  was fifty lines of Python I should have written at the start of the course.
- **Metadata you write for one purpose is useful for another.** I added `caption=` and
  `language=` so the PDF would look right. Years later they were the only thing that let a
  script name and type the files correctly.
- **A generated tree needs a drift check or it rots.** The moment code exists in two places
  one of them starts lying. `make diff-check` is three lines and it is the difference
  between generated files you can trust and generated files you have to re-verify by hand.
- **Godot 3 and Godot 4 are different languages.** The animation scripts still use
  `onready var` and `export var`. They were written earlier in the course and never
  migrated, and nothing complained because a document does not type-check.

### Known limitations

- **Six scripts do not parse as Godot 4 GDScript**, listed with reasons in
  `tools/known-parse-failures.txt`:
  - Five session 11 animation scripts use Godot 3 syntax (`onready var`, `export var`
    instead of `@onready`, `@export`).
  - `src/sessions/session-09/solution.gd` lost its indentation when it was pasted into the
    LaTeX document — the body of `_process` sits at column 0. GDScript is
    indentation-sensitive, so the listing is wrong in the PDF too. Guessing the original
    nesting would be inventing code, so it stays as the document has it.
- **There is no Godot project here.** The scenes these scripts were attached to were not
  kept, only the scripts. `src/problems/problema_5_2.gd` preloads
  `res://escenaHijos/problema_5_1.tscn`, which does not exist in this repository. Each
  script has to be attached to a node of the right type by hand.
- **One character was removed from a delivered file.** `funciones_auxiliares_t5.gd` had a
  stray `y` on line 2, an accidental keystroke that stopped the file parsing. Nothing else
  in `src/problems/` was touched.
- **`gdlint` reports style problems and CI does not fail on them.** Naming and whitespace
  rules against delivered coursework would mean rewriting the submission.
- **The session 2 lab snippets are not here.** They were fill-in-the-blank skeletons from
  the lecture slides, with `...` where the code should go, and five of the nine did not
  parse. They are lecture material, not work of mine.

## Author and licence

Ismael Sallami Moreno. Released under the MIT licence (see [`LICENSE`](LICENSE)).
