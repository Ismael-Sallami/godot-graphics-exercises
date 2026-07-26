# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 8
# Regenerate with: python3 tools/extract-from-latex.py

# Tabla de posiciones (24 vértices: 6 caras x 4 vértices)
var vertices = [
    # Cara Frontal (Z=1)
    Vector3(0,0,1), Vector3(1,0,1), Vector3(1,1,1), Vector3(0,1,1),
    # Cara Derecha (X=1)
    Vector3(1,0,1), Vector3(1,0,0), Vector3(1,1,0), Vector3(1,1,1),
    # Cara Trasera (Z=0)
    Vector3(1,0,0), Vector3(0,0,0), Vector3(0,1,0), Vector3(1,1,0),
    # Cara Izquierda (X=0)
    Vector3(0,0,0), Vector3(0,0,1), Vector3(0,1,1), Vector3(0,1,0),
    # Cara Superior (Y=1)
    Vector3(0,1,1), Vector3(1,1,1), Vector3(1,1,0), Vector3(0,1,0),
    # Cara Inferior (Y=0)
    Vector3(0,0,0), Vector3(1,0,0), Vector3(1,0,1), Vector3(0,0,1),
]

# Tabla de normales (una por vértice, constante por cara)
var normals = [
    # Frontal
    Vector3(0,0,1), Vector3(0,0,1), Vector3(0,0,1), Vector3(0,0,1),
    # Derecha
    Vector3(1,0,0), Vector3(1,0,0), Vector3(1,0,0), Vector3(1,0,0),
    # Trasera
    Vector3(0,0,-1), Vector3(0,0,-1), Vector3(0,0,-1), Vector3(0,0,-1),
    # Izquierda
    Vector3(-1,0,0), Vector3(-1,0,0), Vector3(-1,0,0), Vector3(-1,0,0),
    # Superior
    Vector3(0,1,0), Vector3(0,1,0), Vector3(0,1,0), Vector3(0,1,0),
    # Inferior
    Vector3(0,-1,0), Vector3(0,-1,0), Vector3(0,-1,0), Vector3(0,-1,0),
]

# Tabla de coordenadas de textura (UV)
var uvs = [
    # Frontal (u: 0.25-0.5, v: 0.33-0.66)
    Vector2(0.25,0.33), Vector2(0.50,0.33), Vector2(0.50,0.66), Vector2(0.25,0.66),
    # Derecha (u: 0.5-0.75, v: 0.33-0.66)
    Vector2(0.50,0.33), Vector2(0.75,0.33), Vector2(0.75,0.66), Vector2(0.50,0.66),
    # Trasera (u: 0.75-1.0, v: 0.33-0.66)
    Vector2(0.75,0.33), Vector2(1.00,0.33), Vector2(1.00,0.66), Vector2(0.75,0.66),
    # Izquierda (u: 0.0-0.25, v: 0.33-0.66)
    Vector2(0.00,0.33), Vector2(0.25,0.33), Vector2(0.25,0.66), Vector2(0.00,0.66),
    # Superior (u: 0.25-0.5, v: 0.66-1.0)
    Vector2(0.25,0.66), Vector2(0.50,0.66), Vector2(0.50,1.00), Vector2(0.25,1.00),
    # Inferior (u: 0.25-0.5, v: 0.00-0.33)
    Vector2(0.25,0.00), Vector2(0.50,0.00), Vector2(0.50,0.33), Vector2(0.25,0.33),
]

# Tabla de triángulos 
var triangles = [
    # Frontal
    0,1,2, 0,2,3,
    # Derecha
    4,5,6, 4,6,7,
    # Trasera
    8,9,10, 8,10,11,
    # Izquierda
    12,13,14, 12,14,15,
    # Superior
    16,17,18, 16,18,19,
    # Inferior
    20,21,22, 20,22,23,
]
