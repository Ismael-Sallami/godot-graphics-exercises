# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 2
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready():
    const n: int = 5
    if n <= 1:
        push_error("n debe ser mayor que 1")
        return

    var vertices = PackedVector3Array()
    var colors = PackedColorArray()
    var indices = PackedInt32Array()

    var centro = Vector3(0.5, 0.5, 0)
    vertices.push_back(centro)
    colors.push_back(Color.WHITE)

    var radio_punta = 0.5
    var radio_valle = 0.25
    var num_vertices_externos = 2 * n

    for i in range(num_vertices_externos):
        var radio_actual = radio_punta if i % 2 == 0 else radio_valle
        var angulo = (float(i) / float(num_vertices_externos)) * TAU
        var x = centro.x + radio_actual * cos(angulo)
        var y = centro.y + radio_actual * sin(angulo)
        var z = 0.0
        vertices.push_back(Vector3(x, y, z))
        colors.push_back(Color(x, y, z))

    vertices.push_back(Vector3(0.5, 0.5, 0.5))
    colors.push_back(Color.WHITE)
    var idx_apex = vertices.size() - 1

    for i in range(num_vertices_externos):
        var idx_centro = 0
        var idx_v1 = i + 1
        var idx_v2 = (i + 1) % num_vertices_externos + 1
        indices.push_back(idx_centro)
        indices.push_back(idx_v1)
        indices.push_back(idx_v2)

    for i in range(num_vertices_externos):
        var idx_v1 = i + 1
        var idx_v2 = (i + 1) % num_vertices_externos + 1
        indices.push_back(idx_apex)
        indices.push_back(idx_v1)
        indices.push_back(idx_v2)

    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_COLOR] = colors
    arrays[ArrayMesh.ARRAY_INDEX] = indices

    var new_mesh = ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    self.mesh = new_mesh

    var material = StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    material.cull_mode = StandardMaterial3D.CULL_DISABLED
    self.material_override = material
