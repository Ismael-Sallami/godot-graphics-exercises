# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 8
# Regenerate with: python3 tools/extract-from-latex.py

# Definición de los vértices: posición y coordenadas de textura
var vertices = [
    Vector3(0, 1, 0),   # v0
    Vector3(1, 1, 0),   # v1
    Vector3(1, 1, 0),   # v2
    Vector3(0, 1, 0),   # v3
    Vector3(0, 1, 1),   # v4
    Vector3(1, 1, 1),   # v5
    Vector3(1, 1, 0),   # v6
    Vector3(1, 0, 0),   # v7
    Vector3(0, 0, 0),   # v8
    Vector3(0, 0, 1),   # v9
    Vector3(1, 0, 1),   # v10
    Vector3(1, 0, 0),   # v11
    Vector3(0, 0, 0),   # v12
    Vector3(1, 0, 0),   # v13
]

var uvs = [
    Vector2(0.50, 1.00),   # v0
    Vector2(0.75, 1.00),   # v1
    Vector2(0.00, 0.66),   # v2
    Vector2(0.25, 0.66),   # v3
    Vector2(0.50, 0.66),   # v4
    Vector2(0.75, 0.66),   # v5
    Vector2(1.00, 0.66),   # v6
    Vector2(0.00, 0.33),   # v7
    Vector2(0.25, 0.33),   # v8
    Vector2(0.50, 0.33),   # v9
    Vector2(0.75, 0.33),   # v10
    Vector2(1.00, 0.33),   # v11
    Vector2(0.50, 0.00),   # v12
    Vector2(0.75, 0.00),   # v13
]

# Definición de los triángulos (índices de vértices) en orden horario (sentido antihorario visto desde fuera)
var triangles = [
    # Cara 5 (Arriba)
    0, 1, 4,
    1, 5, 4,
    # Cara 6 (Atrás)
    2, 3, 7,
    3, 8, 7,
    # Cara 3 (Izquierda)
    3, 4, 8,
    4, 9, 8,
    # Cara 1 (Frente)
    4, 5, 9,
    5, 10, 9,
    # Cara 4 (Derecha)
    5, 6, 10,
    6, 11, 10,
    # Cara 2 (Abajo)
    9, 10, 12,
    10, 13, 12,
]
