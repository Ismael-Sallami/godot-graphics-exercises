# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 3
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

var angulo_giro := 0.0
const VELOCIDAD_GIRO = TAU
var activar_accion := "activar_giro_cubos"
var activa := true

var pivot_x_pos: Node3D
var pivot_x_neg: Node3D
var pivot_y_pos: Node3D
var pivot_y_neg: Node3D
var pivot_z_pos: Node3D
var pivot_z_neg: Node3D

func _ready():
    var rejilla_mesh = ArrayMeshRejilla(11, 11)
    var cubo_mesh = ArrayMeshCubo24()
    var rejilla_material = StandardMaterial3D.new()
    rejilla_material.vertex_color_use_as_albedo = true
    rejilla_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    rejilla_material.cull_mode = StandardMaterial3D.CULL_DISABLED
    var cubo_material = StandardMaterial3D.new()
    cubo_material.albedo = Color.WHITE
    cubo_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED

    var cubo_central = Node3D.new()
    add_child(cubo_central)
    var centro_rejilla = Vector3(-0.5, 0, -0.5)
    var transforms = [
        Transform3D(Basis(), Vector3(0, 0.5, 0)) * Transform3D(Basis(), centro_rejilla),
        Transform3D(Basis.from_euler(Vector3(PI, 0, 0)), Vector3(0, -0.5, 0)) * Transform3D(Basis(), centro_rejilla),
        Transform3D(Basis.from_euler(Vector3(0, 0, PI/2.0)), Vector3(0.5, 0, 0)) * Transform3D(Basis(), centro_rejilla),
        Transform3D(Basis.from_euler(Vector3(0, 0, -PI/2.0)), Vector3(-0.5, 0, 0)) * Transform3D(Basis(), centro_rejilla),
        Transform3D(Basis.from_euler(Vector3(-PI/2.0, 0, 0)), Vector3(0, 0, 0.5)) * Transform3D(Basis(), centro_rejilla),
        Transform3D(Basis.from_euler(Vector3(PI/2.0, 0, 0)), Vector3(0, 0, -0.5)) * Transform3D(Basis(), centro_rejilla)
    ]
    for i in range(6):
        var cara = MeshInstance3D.new()
        cara.mesh = rejilla_mesh
        cara.material_override = rejilla_material
        cara.transform = transforms[i]
        cubo_central.add_child(cara)

    var dist_cubo_peq = 0.7
    var escala_alargada = Vector3(0.2, 0.4, 0.2)

    pivot_y_pos = Node3D.new()
    add_child(pivot_y_pos)
    crear_cubo_pequeno(pivot_y_pos, cubo_mesh, cubo_material, Vector3(0, dist_cubo_peq, 0), escala_alargada)

    pivot_y_neg = Node3D.new()
    add_child(pivot_y_neg)
    crear_cubo_pequeno(pivot_y_neg, cubo_mesh, cubo_material, Vector3(0, -dist_cubo_peq, 0), escala_alargada)

    pivot_x_pos = Node3D.new()
    add_child(pivot_x_pos)
    crear_cubo_pequeno(pivot_x_pos, cubo_mesh, cubo_material, Vector3(dist_cubo_peq, 0, 0), escala_alargada.rotated(Vector3.FORWARD, PI/2.0))

    pivot_x_neg = Node3D.new()
    add_child(pivot_x_neg)
    crear_cubo_pequeno(pivot_x_neg, cubo_mesh, cubo_material, Vector3(-dist_cubo_peq, 0, 0), escala_alargada.rotated(Vector3.FORWARD, -PI/2.0))

    pivot_z_pos = Node3D.new()
    add_child(pivot_z_pos)
    crear_cubo_pequeno(pivot_z_pos, cubo_mesh, cubo_material, Vector3(0, 0, dist_cubo_peq), escala_alargada.rotated(Vector3.RIGHT, PI/2.0))

    pivot_z_neg = Node3D.new()
    add_child(pivot_z_neg)
    crear_cubo_pequeno(pivot_z_neg, cubo_mesh, cubo_material, Vector3(0, 0, -dist_cubo_peq), escala_alargada.rotated(Vector3.RIGHT, -PI/2.0))

func _process(delta):
    if Input.is_action_just_pressed(activar_accion):
        activa = !activa
    if not activa:
        return
    angulo_giro += VELOCIDAD_GIRO * delta
    if pivot_y_pos:
        pivot_y_pos.rotation.y = angulo_giro
        pivot_y_neg.rotation.y = angulo_giro
        pivot_x_pos.rotation.x = angulo_giro
        pivot_x_neg.rotation.x = angulo_giro
        pivot_z_pos.rotation.z = angulo_giro
        pivot_z_neg.rotation.z = angulo_giro

func crear_cubo_pequeno(pivote: Node3D, mesh: ArrayMesh, mat: StandardMaterial3D, pos: Vector3, escala: Vector3):
    var cubo = MeshInstance3D.new()
    cubo.mesh = mesh
    cubo.material_override = mat
    cubo.position = pos
    cubo.scale = escala
    pivote.add_child(cubo)

func ArrayMeshRejilla(m: int, n: int) -> ArrayMesh:
    var vertices = PackedVector3Array()
    var colors = PackedColorArray()
    var indices = PackedInt32Array()
    var normales = PackedVector3Array()
    for i in range(m):
        for j in range(n):
            var x = float(i) / float(m - 1)
            var y = 0.0
            var z = float(j) / float(n - 1)
            vertices.push_back(Vector3(x, y, z))
            colors.push_back(Color(x, y, z))
            normales.push_back(Vector3.UP)
    for i in range(m - 1):
        for j in range(n - 1):
            var v0 = i * n + j
            var v1 = (i + 1) * n + j
            var v2 = i * n + (j + 1)
            var v3 = (i + 1) * n + (j + 1)
            indices.push_back(v0)
            indices.push_back(v2)
            indices.push_back(v3)
            indices.push_back(v0)
            indices.push_back(v3)
            indices.push_back(v1)
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_COLOR] = colors
    arrays[Mesh.ARRAY_INDEX] = indices
    arrays[Mesh.ARRAY_NORMAL] = normales
    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return mesh

func ArrayMeshCubo24() -> ArrayMesh:
    var vertices := PackedVector3Array([
        Vector3(-0.5,  0.5,  0.5), Vector3( 0.5,  0.5,  0.5), Vector3( 0.5, -0.5,  0.5), Vector3(-0.5, -0.5,  0.5),
        Vector3( 0.5,  0.5, -0.5), Vector3(-0.5,  0.5, -0.5), Vector3(-0.5, -0.5, -0.5), Vector3( 0.5, -0.5, -0.5),
        Vector3( 0.5,  0.5,  0.5), Vector3( 0.5,  0.5, -0.5), Vector3( 0.5, -0.5, -0.5), Vector3( 0.5, -0.5,  0.5),
        Vector3(-0.5,  0.5, -0.5), Vector3(-0.5,  0.5,  0.5), Vector3(-0.5, -0.5,  0.5), Vector3(-0.5, -0.5, -0.5),
        Vector3(-0.5,  0.5, -0.5), Vector3( 0.5,  0.5, -0.5), Vector3( 0.5,  0.5,  0.5), Vector3(-0.5,  0.5,  0.5),
        Vector3(-0.5, -0.5,  0.5), Vector3( 0.5, -0.5,  0.5), Vector3( 0.5, -0.5, -0.5), Vector3(-0.5, -0.5, -0.5)
    ])
    var triangulos := PackedInt32Array([
        0, 1, 2,  0, 2, 3,    4, 5, 6,  4, 6, 7,
        8, 9, 10, 8, 10, 11,   12, 13, 14, 12, 14, 15,
        16, 17, 18, 16, 18, 19, 20, 21, 22, 20, 22, 23
    ])
    var normales := Utilidades.calcNormales(vertices, triangulos)
    var arrays := []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_INDEX] = triangulos
    arrays[Mesh.ARRAY_NORMAL] = normales
    var new_mesh := ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return new_mesh
