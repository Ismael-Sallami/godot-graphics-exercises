# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 1
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

func _ready():
    var vertices = PoolVector3Array([
        Vector3(0, 0, 0), # v0
        Vector3(2, 0, 0), # v1
        Vector3(2, 0, 1), # v2
        Vector3(1, 0, 1), # v3
        Vector3(1, 0, 2), # v4
        Vector3(0, 0, 2), # v5
        Vector3(1, 2, 1)  # v6 (ápice)
    ])

    var indices = PoolIntArray([
        0, 1, 3,
        1, 2, 3,
        0, 3, 5,
        3, 4, 5,
        6, 0, 1,
        6, 1, 2,
        6, 2, 3,
        6, 3, 4,
        6, 4, 5,
        6, 5, 0
    ])

    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_INDEX] = indices

    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    self.mesh = mesh
