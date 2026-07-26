# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 3
# Regenerate with: python3 tools/extract-from-latex.py

func gancho() -> ArrayMesh:
    var vertices = PackedVector2Array([
        Vector2(0,0),
        Vector2(1,0),
        Vector2(1,1),
        Vector2(0,1),
        Vector2(0,2)
    ])

    var arrays = []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices

    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, arrays)
    return mesh
