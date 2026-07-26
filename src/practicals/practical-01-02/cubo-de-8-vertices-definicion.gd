# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — Problema de los cuadrados
# Caption: Cubo de 8 vértices: definición
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready() -> void:

    # === 1. Definición de Vértices y Triángulos (Cubo de 8 Vértices, solo Y positivas) ===

    var vertices := PackedVector3Array([
        # Esquina 0: (-X, +Y0, -Z)
        Vector3(-0.5, 0.0, -0.5), # 0
        # Esquina 1: (+X, +Y0, -Z)
        Vector3( 0.5, 0.0, -0.5), # 1
        # Esquina 2: (+X, +Y0, +Z)
        Vector3( 0.5, 0.0,  0.5), # 2
        # Esquina 3: (-X, +Y0, +Z)
        Vector3(-0.5, 0.0,  0.5), # 3
        # Esquina 4: (-X, +Y1, -Z)
        Vector3(-0.5, 1.0, -0.5), # 4
        # Esquina 5: (+X, +Y1, -Z)
        Vector3( 0.5, 1.0, -0.5), # 5
        # Esquina 6: (+X, +Y1, +Z)
        Vector3( 0.5, 1.0,  0.5), # 6
        # Esquina 7: (-X, +Y1, +Z)
        Vector3(-0.5, 1.0,  0.5)  # 7
    ])

    # Cada línea define los índices de los vértices que forman los triángulos de cada cara del cubo
    var triangulos := PackedInt32Array([
        # Cara inferior (Y baja)
        0, 3, 2,  0, 2, 1,
        # Cara superior (Y alta)
        4, 5, 6,  4, 6, 7,
        # Cara frontal (Z-)
        0, 1, 5,  0, 5, 4,
        # Cara trasera (Z+)
        3, 7, 6,  3, 6, 2,
        # Cara lateral derecha (X+)
        1, 2, 6,  1, 6, 5,
        # Cara lateral izquierda (X-)
        0, 4, 7,  0, 7, 3
    ])

    # 2. Cálculo de Normales Suaves
    # Se calculan las normales promedio para cada vértice usando la función de utilidades
    var normales := Utilidades.calcNormales(vertices, triangulos)

    # 3. Creación y asignación de la Malla
    # Se prepara el array de datos de la malla (vértices, índices y normales)
    var tablas : Array = []
    tablas.resize(Mesh.ARRAY_MAX)
    tablas[Mesh.ARRAY_VERTEX] = vertices
    tablas[Mesh.ARRAY_INDEX] = triangulos
    tablas[Mesh.ARRAY_NORMAL] = normales

    # Se crea la malla y se añade la superficie con los datos anteriores
    mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

    # 4. Material (Sombreado por píxel)
    # Se crea y configura el material para el cubo
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.4, 0.4, 1.0)  # Color azul claro
    mat.metallic = 0.3                       # Un poco metálico
    mat.roughness = 0.2                      # Poco rugoso
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX  # Sombreado por vértice

    # Se asigna el material a la malla
    material_override = mat
