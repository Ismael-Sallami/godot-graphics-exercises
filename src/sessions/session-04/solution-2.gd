# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 4
# Regenerate with: python3 tools/extract-from-latex.py

func calcular_aristas_caso_b(triangulos: Array[Vector3i]) -> Array[Vector2i]:
    var ari: Array[Vector2i] = []
    for t in triangulos:
        # Definimos los 3 pares tal cual aparecen en el orden del triángulo
        # Arista 0-1
        if t[0] < t[1]:
            ari.append(Vector2i(t[0], t[1]))
        # Arista 1-2
        if t[1] < t[2]:
            ari.append(Vector2i(t[1], t[2]))
        # Arista 2-0
        if t[2] < t[0]:
            ari.append(Vector2i(t[2], t[0]))
    return ari
