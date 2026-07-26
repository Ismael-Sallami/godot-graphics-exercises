# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 3
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

const VELOCIDAD_GIRO = 2.5 * TAU
var activar := "activar_giro_grafoEstrellaX"
var activa := true

func _ready():
    const n: int = 5
    if n <= 1:
        push_error("n debe ser > 1")
        return

    var star_mesh = ArrayMeshEstrellaZ(n)
    var star_node = MeshInstance3D.new()
    star_node.mesh = star_mesh
    var star_material = StandardMaterial3D.new()
    star_material.vertex_color_use_as_albedo = true
    star_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    star_material.cull_mode = StandardMaterial3D.CULL_DISABLED
    star_node.material_override = star_material
    add_child(star_node)

    var cone_mesh = crear_mesh_cono()
    var cone_material = StandardMaterial3D.new()
    cone_material.albedo = Color.WHITE
    cone_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED

    var centro = Vector3.ZERO
    var radio_punta = 0.5
    var num_vertices_totales_estrella = 2 * n

    for i in range(n):
        var angulo_punta = (float(i * 2) / float(num_vertices_totales_estrella)) * TAU
        var x = centro.x + radio_punta * cos(angulo_punta)
        var y = 0.0
        var z = centro.z + radio_punta * sin(angulo_punta)
        var pos_punta = Vector3(x, y, z)
        var cone_node = MeshInstance3D.new()
        cone_node.mesh = cone_mesh
        cone_node.material_override = cone_material
        cone_node.position = pos_punta
        var dir_original = Vector3.UP
        var dir_deseada = (pos_punta - centro).normalized()
        var rotation_axis = dir_original.cross(dir_deseada).normalized()
        var rotation_angle = dir_original.angle_to(dir_deseada)
        cone_node.rotate(rotation_axis, rotation_angle)
        add_child(cone_node)

func _process(delta):
    if Input.is_action_just_pressed(activar):
        activa = !activa
    if activa:
        rotate_x(VELOCIDAD_GIRO * delta)

func crear_mesh_cono() -> ArrayMesh:
    var perfil_cono = PackedVector2Array([
        Vector2(0.0, 0.15),
        Vector2(0.14, 0.0),
        Vector2(0.0, 0.0)
    ])
    var vertices = PackedVector3Array()
    var triangulos = PackedInt32Array()
    RevolucionUtils.generar_malla_revolucion(perfil_cono, 16, vertices, triangulos)
    var normales = Utilidades.calcNormales(vertices, triangulos)
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_INDEX] = triangulos
    arrays[Mesh.ARRAY_NORMAL] = normales
    var new_mesh = ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return new_mesh

func ArrayMeshEstrellaZ(p_n: int) -> ArrayMesh:
    var vertices = PackedVector3Array()
    var colors = PackedColorArray()
    var indices = PackedInt32Array()
    var centro = Vector3.ZERO
    vertices.push_back(centro)
    colors.push_back(Color.WHITE)
    var radio_punta = 0.5
    var radio_valle = 0.25
    var num_vertices_externos = 2 * p_n
    for i in range(num_vertices_externos):
        var radio_actual = radio_punta if i % 2 == 0 else radio_valle
        var angulo = (float(i) / float(num_vertices_externos)) * TAU
        var x = centro.x + radio_actual * cos(angulo)
        var y = 0.0
        var z = centro.z + radio_actual * sin(angulo)
        vertices.push_back(Vector3(x, y, z))
        colors.push_back(Color(x, y, z))
    for i in range(num_vertices_externos):
        var idx_centro = 0
        var idx_v1 = i + 1
        var idx_v2 = (i + 1) % num_vertices_externos + 1
        indices.push_back(idx_centro)
        indices.push_back(idx_v1)
        indices.push_back(idx_v2)
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_COLOR] = colors
    arrays[Mesh.ARRAY_INDEX] = indices
    var new_mesh = ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return new_mesh
