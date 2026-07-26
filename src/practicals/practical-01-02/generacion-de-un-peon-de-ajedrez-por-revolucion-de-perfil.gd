# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — Creación de mallas por revolución de un perfil
# Caption: Generación de un peón de ajedrez por revolución de perfil
# Regenerate with: python3 tools/extract-from-latex.py

# Archivo: peon_ajedrez_revolucion.gd
extends MeshInstance3D

@export var num_copias: int = 64                       # Número de copias del perfil (divisiones horizontales)
@export var segmentos_verticales_por_tramo: int = 16    # Segmentos por tramo entre puntos clave del perfil
@export var sombreado_por_pixel: bool = true            # Permite alternar el modo de sombreado

# Constante que define los puntos clave del perfil 2D del peón
const PUNTOS_PEON_CLAVE: PackedVector2Array = [
    Vector2(0.0, -1.0), Vector2(0.5, -1.0), Vector2(0.55, -0.8),
    Vector2(0.2, -0.4), Vector2(0.3, 0.1), Vector2(0.1, 0.5),
    Vector2(0.35, 0.8), Vector2(0.2, 0.95), Vector2(0.0, 1.0)
]

# Genera el perfil suavizado interpolando linealmente entre los puntos clave
func generar_perfil_peon(segmentos: int) -> PackedVector2Array:
    var perfil = PackedVector2Array()
    # Para cada tramo entre dos puntos clave, interpola 'segmentos' puntos
    for i in range(PUNTOS_PEON_CLAVE.size() - 1):
        var p_inicio = PUNTOS_PEON_CLAVE[i]
        var p_fin = PUNTOS_PEON_CLAVE[i + 1]
        for j in range(segmentos):
            perfil.append(p_inicio.lerp(p_fin, float(j) / float(segmentos)))
    perfil.append(PUNTOS_PEON_CLAVE[-1]) # Añade el último punto clave
    return perfil

func _ready() -> void:
    # Genera el perfil 2D del peón usando la función de interpolación
    var perfil_actual = generar_perfil_peon(segmentos_verticales_por_tramo)

    # Inicializa los arrays de salida para vértices y triángulos
    var vertices := PackedVector3Array([])
    var triangulos := PackedInt32Array([])

    # Genera la malla por revolución usando el perfil y el número de copias
    RevolucionUtils.generar_malla_revolucion(perfil_actual, num_copias, vertices, triangulos)

    # Calcula las normales promedio para cada vértice
    var normales := Utilidades.calcNormales(vertices, triangulos)

    # Prepara el array de datos de la malla (estructura SOA)
    var tablas: Array = []
    tablas.resize(Mesh.ARRAY_MAX)
    tablas[Mesh.ARRAY_VERTEX] = vertices      # Posiciones de los vértices
    tablas[Mesh.ARRAY_INDEX] = triangulos     # Índices de los triángulos
    tablas[Mesh.ARRAY_NORMAL] = normales      # Normales de los vértices

    # Crea la malla y añade la superficie con los datos anteriores
    mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

    # Crea y configura el material para el peón
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(1.0, 1.0, 0.8)   # Color marfil claro
    mat.metallic = 0.5                        # Más metálico
    mat.roughness = 0.4                       # Más rugoso

    # Configura el modo de sombreado según el parámetro exportado
    if sombreado_por_pixel:
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL   # Sombreado por píxel
    else:
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX # Sombreado por vértice

    material_override = mat
