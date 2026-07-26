# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 1
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

@export var n: int = 5

func _ready():
    if n < 2:
        n = 2
        print("La estrella debe tener al menos 2 puntas. Usando n=2.")
    var new_mesh = ArrayMeshEstrellaZ(n)
    self.mesh = new_mesh
    var material = StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    material.cull_mode = StandardMaterial3D.CULL_DISABLED
    self.material_override = material

func ArrayMeshEstrellaZ(p_n: int) -> ArrayMesh:
    var vertices = PackedVector3Array()
    var colors = PackedColorArray()
    var indices = PackedInt32Array()
    var centro = Vector3(0.5, 0.5, 0)
    vertices.push_back(centro)
    colors.push_back(Color.WHITE)
    var radio_punta = 0.5
    var radio_valle = 0.25
    var num_vertices_externos = 2 * p_n
    for i in range(num_vertices_externos):
        var radio_actual = radio_punta if i % 2 == 0 else radio_valle
        var angulo = (float(i) / float(num_vertices_externos)) * TAU
        var x = centro.x + radio_actual * cos(angulo)
        var y = centro.y + radio_actual * sin(angulo)
        var z = 0.0
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
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_COLOR] = colors
    arrays[ArrayMesh.ARRAY_INDEX] = indices
    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return mesh
