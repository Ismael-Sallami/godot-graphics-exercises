# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 4 / Implementación en GDScript
# Regenerate with: python3 tools/extract-from-latex.py

func calcular_area_malla(vertices: Array[Vector3], triangulos: Array[Vector3i]) -> float:
    var area_total: float = 0.0
    for t in triangulos:
        var p0: Vector3 = vertices[t[0]]
        var p1: Vector3 = vertices[t[1]]
        var p2: Vector3 = vertices[t[2]]
        var u: Vector3 = p1 - p0
        var v: Vector3 = p2 - p0
        var vector_area: Vector3 = u.cross(v)
        var area_triangulo: float = vector_area.length() * 0.5
        area_total += area_triangulo
    return area_total
