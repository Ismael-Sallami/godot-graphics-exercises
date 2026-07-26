# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 8
# Regenerate with: python3 tools/extract-from-latex.py

# Tabla de posiciones (24 vértices: 6 caras x 4 vértices)
var vertices = [
    # Frontal (z=1)
    Vector3(0,0,1), Vector3(1,0,1), Vector3(1,1,1), Vector3(0,1,1),
    # Trasera (z=0)
    Vector3(1,0,0), Vector3(0,0,0), Vector3(0,1,0), Vector3(1,1,0),
    # Derecha (x=1)
    Vector3(1,0,1), Vector3(1,0,0), Vector3(1,1,0), Vector3(1,1,1),
    # Izquierda (x=0)
    Vector3(0,0,0), Vector3(0,0,1), Vector3(0,1,1), Vector3(0,1,0),
    # Superior (y=1)
    Vector3(0,1,1), Vector3(1,1,1), Vector3(1,1,0), Vector3(0,1,0),
    # Inferior (y=0)
    Vector3(0,0,0), Vector3(1,0,0), Vector3(1,0,1), Vector3(0,0,1),
]

# Tabla de coordenadas de textura (UV)
var uvs = [
    # Frontal
    Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1),
    # Trasera
    Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1),
    # Derecha
    Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1),
    # Izquierda
    Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1),
    # Superior
    Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1),
    # Inferior
    Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1),
]

# Tabla de triángulos 
var triangles = [
    # Frontal
    0,1,2, 0,2,3,
    # Trasera
    4,5,6, 4,6,7,
    # Derecha
    8,9,10, 8,10,11,
    # Izquierda
    12,13,14, 12,14,15,
    # Superior
    16,17,18, 16,18,19,
    # Inferior
    20,21,22, 20,22,23,
]
