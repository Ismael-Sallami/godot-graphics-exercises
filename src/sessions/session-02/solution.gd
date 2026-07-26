# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 2
# Regenerate with: python3 tools/extract-from-latex.py

func genSegNormales( verts, norms : PackedVector3Array, lon : float, color : Color ) -> MeshInstance3D:
    var line_verts = PackedVector3Array()
    var line_colors = PackedColorArray()

    for i in range(verts.size()):
        var origen = verts[i]
        var destino = origen + norms[i] * lon

        line_verts.push_back(origen)
        line_verts.push_back(destino)

        line_colors.push_back(color)
        line_colors.push_back(color)

    var arrays = []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = line_verts
    arrays[Mesh.ARRAY_COLOR] = line_colors

    var arr_mesh = ArrayMesh.new()
    arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)

    var material = StandardMaterial3D.new()
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.vertex_color_use_as_albedo = true

    var mi = MeshInstance3D.new()
    mi.mesh = arr_mesh
    mi.material_override = material

	return mi
