# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — Creación de mallas por revolución de un perfil
# Caption: Generación de una esfera por revolución de perfil
# Regenerate with: python3 tools/extract-from-latex.py

# Archivo: malla_revolucion.gd
extends MeshInstance3D

# Parámetros exportados para configurar el modelo desde el editor
@export var num_copias: int = 64                # Número de copias del perfil (divisiones horizontales)
@export var radio: float = 1.0                  # Radio de la esfera
@export var sombreado_por_pixel: bool = true    # Permite alternar el modo de sombreado

## Función que genera el perfil 2D de media circunferencia para la esfera
func generar_perfil_esfera(segmentos_verticales: int) -> PackedVector2Array:
    var perfil = PackedVector2Array()
    var R = radio
    # Recorre los segmentos verticales para crear puntos desde abajo (PI) hasta arriba (0)
    for i in range(segmentos_verticales + 1):
        var angulo = PI * float(i) / float(segmentos_verticales)
        # Calcula la posición X e Y del punto en el perfil usando funciones trigonométricas
        var x_coord = R * sin(angulo)   # Componente X del perfil
        var y_coord = R * cos(angulo)   # Componente Y del perfil
        perfil.append(Vector2(x_coord, y_coord)) # Añade el punto al perfil
    return perfil

func _ready() -> void:
    # Define el número de segmentos verticales para la esfera
    var segmentos_verticales = 32
    # Genera el perfil de media circunferencia
    var perfil_actual = generar_perfil_esfera(segmentos_verticales)

    # Inicializa los arrays de salida para vértices y triángulos
    var vertices   := PackedVector3Array([])
    var triangulos := PackedInt32Array([])

    # Genera la malla por revolución usando el perfil y el número de copias
    RevolucionUtils.generar_malla_revolucion(perfil_actual, num_copias, vertices, triangulos)

    # Calcula las normales promedio para cada vértice
    var normales := Utilidades.calcNormales(vertices, triangulos)

    # Prepara el array de datos de la malla (estructura SOA)
    var tablas : Array = []
    tablas.resize(Mesh.ARRAY_MAX)
    tablas[Mesh.ARRAY_VERTEX] = vertices      # Posiciones de los vértices
    tablas[Mesh.ARRAY_INDEX]  = triangulos    # Índices de los triángulos
    tablas[Mesh.ARRAY_NORMAL] = normales      # Normales de los vértices

    # Crea la malla y añade la superficie con los datos anteriores
    mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

    # Crea y configura el material para la esfera
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.5, 1.0)   # Color azul claro
    mat.metallic = 0.3                        # Un poco metálico
    mat.roughness = 0.2                       # Poco rugoso

    # Configura el modo de sombreado según el parámetro exportado
    if sombreado_por_pixel:
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL   # Sombreado por píxel
    else:
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX # Sombreado por vértice

    material_override = mat
