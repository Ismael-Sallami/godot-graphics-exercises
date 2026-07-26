# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — Problema de los cuadrados
# Caption: Cubo de 24 vértices: definición
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready() -> void:
    # === 1. Definición de Vértices ===
    # Se definen 24 vértices, 4 para cada una de las 6 caras del cubo.
    # Esto permite que cada cara tenga su propia normal, logrando un sombreado plano y correcto.
    var vertices := PackedVector3Array([
        # Cara frontal (Z+)
        Vector3(-0.5,  0.5,  0.5), # 0 - Arriba-Izquierda
        Vector3( 0.5,  0.5,  0.5), # 1 - Arriba-Derecha
        Vector3( 0.5, -0.5,  0.5), # 2 - Abajo-Derecha
        Vector3(-0.5, -0.5,  0.5), # 3 - Abajo-Izquierda

        # Cara trasera (Z-)
        Vector3( 0.5,  0.5, -0.5), # 4 - Arriba-Derecha
        Vector3(-0.5,  0.5, -0.5), # 5 - Arriba-Izquierda
        Vector3(-0.5, -0.5, -0.5), # 6 - Abajo-Izquierda
        Vector3( 0.5, -0.5, -0.5), # 7 - Abajo-Derecha

        # Cara derecha (X+)
        Vector3( 0.5,  0.5,  0.5), # 8 - Arriba-Frontal
        Vector3( 0.5,  0.5, -0.5), # 9 - Arriba-Trasera
        Vector3( 0.5, -0.5, -0.5), # 10 - Abajo-Trasera
        Vector3( 0.5, -0.5,  0.5), # 11 - Abajo-Frontal

        # Cara izquierda (X-)
        Vector3(-0.5,  0.5, -0.5), # 12 - Arriba-Trasera
        Vector3(-0.5,  0.5,  0.5), # 13 - Arriba-Frontal
        Vector3(-0.5, -0.5,  0.5), # 14 - Abajo-Frontal
        Vector3(-0.5, -0.5, -0.5), # 15 - Abajo-Trasera

        # Cara superior (Y+)
        Vector3(-0.5,  0.5, -0.5), # 16 - Atrás-Izquierda
        Vector3( 0.5,  0.5, -0.5), # 17 - Atrás-Derecha
        Vector3( 0.5,  0.5,  0.5), # 18 - Adelante-Derecha
        Vector3(-0.5,  0.5,  0.5), # 19 - Adelante-Izquierda

        # Cara inferior (Y-)
        Vector3(-0.5, -0.5,  0.5), # 20 - Adelante-Izquierda
        Vector3( 0.5, -0.5,  0.5), # 21 - Adelante-Derecha
        Vector3( 0.5, -0.5, -0.5), # 22 - Atrás-Derecha
        Vector3(-0.5, -0.5, -0.5)  # 23 - Atrás-Izquierda
    ])

    # === 2. Definición de Triángulos ===
    # Se definen los triángulos para cada cara usando los vértices correspondientes.
    # El orden de los vértices es horario (Clockwise, CW) para que las normales se calculen correctamente.
    var triangulos := PackedInt32Array([
        # Cara frontal (Z+)
        0, 1, 2,  0, 2, 3,
        # Cara trasera (Z-)
        4, 5, 6,  4, 6, 7,
        # Cara derecha (X+)
        8, 9, 10,  8, 10, 11,
        # Cara izquierda (X-)
        12, 13, 14,  12, 14, 15,
        # Cara superior (Y+)
        16, 17, 18,  16, 18, 19,
        # Cara inferior (Y-)
        20, 21, 22,  20, 22, 23
    ])

    # === 3. Cálculo de Normales ===
    # Se calculan las normales para cada vértice usando la función de utilidades.
    # Al tener vértices duplicados por cara, cada normal será perpendicular a su cara.
    var normales := Utilidades.calcNormales(vertices, triangulos)

    # === 4. Creación de la Malla ===
    # Se prepara el array de datos de la malla (vértices, índices y normales).
    var arrays := []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_INDEX] = triangulos
    arrays[Mesh.ARRAY_NORMAL] = normales

    var new_mesh := ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    mesh = new_mesh

    # === 5. Asignación de Material ===
    # Se crea y configura el material para el cubo.
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.4, 0.4, 1.0) # Color azul claro
    mat.metallic = 0.3                      # Un poco metálico
    mat.roughness = 0.2                     # Poco rugoso
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL # Sombreado por píxel

    material_override = mat
