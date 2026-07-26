# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 2
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready():
    var new_mesh = ArrayMeshRejilla(10, 10)
    self.mesh = new_mesh
    var material = StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    material.cull_mode = StandardMaterial3D.CULL_DISABLED
    self.material_override = material

func ArrayMeshRejilla(m: int, n: int) -> ArrayMesh:
    var vertices = PackedVector3Array()
    var colors = PackedColorArray()
    var indices = PackedInt32Array()
    # Generar vértices y colores
    for i in range(m):
        for j in range(n):
            var x = float(i) / float(m - 1)
            var y = 0.0
            var z = float(j) / float(n - 1)
            vertices.push_back(Vector3(x, y, z))
            colors.push_back(Color(x, y, z))
    # Generar índices de triángulos
    for i in range(m - 1):
        for j in range(n - 1):
            var v0 = i * n + j
            var v1 = (i + 1) * n + j
            var v2 = i * n + (j + 1)
            var v3 = (i + 1) * n + (j + 1)
            # Triángulo 1
            indices.push_back(v0)
            indices.push_back(v2)
            indices.push_back(v3)
            # Triángulo 2
            indices.push_back(v0)
            indices.push_back(v3)
            indices.push_back(v1)
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_COLOR] = colors
    arrays[ArrayMesh.ARRAY_INDEX] = indices
    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return mesh
