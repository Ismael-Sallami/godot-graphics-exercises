extends Node

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

func gancho() -> ArrayMesh:
	var vertices = PackedVector2Array([
		Vector2(0,0),
		Vector2(1,0),
		Vector2(1,1),
		Vector2(0,1),
		Vector2(0,2)
	])

	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, arrays)
	return mesh