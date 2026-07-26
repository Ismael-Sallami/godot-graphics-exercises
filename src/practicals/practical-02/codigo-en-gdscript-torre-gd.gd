# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 2 / Código en GDScript (Torre.gd)
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready():
    const n: int = 5
    if n < 1:
        push_error("n debe ser 1 o mayor")
        return

    var vertices = PackedVector3Array()
    var indices = PackedInt32Array()

    # Generar vértices
    for i in range(n + 1):
        var y = float(i)
        vertices.push_back(Vector3(0.0, y, 0.0))
        vertices.push_back(Vector3(1.0, y, 0.0))
        vertices.push_back(Vector3(1.0, y, 1.0))
        vertices.push_back(Vector3(0.0, y, 1.0))

    # Generar triángulos
    for i in range(n):
        for j in range(4):
            var idx0 = i * 4 + j
            var idx1 = i * 4 + (j + 1) % 4
            var idx2 = (i + 1) * 4 + j
            var idx3 = (i + 1) * 4 + (j + 1) % 4

            indices.push_back(idx0)
            indices.push_back(idx1)
            indices.push_back(idx3)

            indices.push_back(idx0)
            indices.push_back(idx3)
            indices.push_back(idx2)

    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_INDEX] = indices

    var new_mesh = ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    self.mesh = new_mesh

    var material = StandardMaterial3D.new()
    material.albedo = Color.WHITE
    material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    self.material_override = material
