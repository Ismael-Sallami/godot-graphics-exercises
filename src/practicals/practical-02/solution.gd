# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 2
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready():
    var vertices = PackedVector3Array([
        Vector3(0.0, 0.0, 0.0), # v0
        Vector3(1.0, 0.0, 0.0), # v1
        Vector3(1.0, 0.0, 0.5), # v2
        Vector3(0.0, 0.0, 0.5), # v3
        Vector3(0.0, 0.5, 0.0), # v4
        Vector3(1.0, 0.5, 0.0), # v5
        Vector3(1.0, 0.5, 0.5), # v6
        Vector3(0.0, 0.5, 0.5), # v7
        Vector3(0.0, 1.0, 0.25), # v8
        Vector3(1.0, 1.0, 0.25)  # v9
    ])

    var colors = PackedColorArray()
    for v in vertices:
        colors.push_back(Color(v.x, v.y, v.z))

    var indices = PackedInt32Array([
        0, 1, 5,   0, 5, 4,
        2, 3, 7,   2, 7, 6,
        1, 2, 6,   1, 6, 5,
        3, 0, 4,   3, 4, 7,
        4, 7, 8,
        5, 9, 6,
        4, 5, 9,   4, 9, 8,
        7, 6, 9,   7, 9, 8
    ])

    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_INDEX] = indices
    arrays[ArrayMesh.ARRAY_COLOR] = colors

    var new_mesh = ArrayMesh.new()
    new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    self.mesh = new_mesh

    var material = StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    material.cull_mode = StandardMaterial3D.CULL_DISABLED
    self.material_override = material
