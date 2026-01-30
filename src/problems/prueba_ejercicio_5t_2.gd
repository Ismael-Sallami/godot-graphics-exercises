extends MeshInstance3D

# Referencia para guardar la malla de "pelos"
var malla_normales: MeshInstance3D = null

func _ready():
	# Obtener la malla del MeshInstance3D
	var local_mesh = self.mesh
	if local_mesh == null:
		return
	
	# Obtener los arrays de la malla
	var arrays = local_mesh.surface_get_arrays(0)
	var verts : PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var norms : PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
	
	# Generar la malla de normales usando la función global
	malla_normales = Global.genSegNormales(verts, norms, 1.5, Color(1, 1, 1))
	add_child(malla_normales)

func _input(event):
	# Detectar pulsación de la tecla N [cite: 2471]
	if event is InputEventKey and event.pressed and event.keycode == KEY_N:
		if malla_normales:
			# Alternar visibilidad
			malla_normales.visible = not malla_normales.visible
