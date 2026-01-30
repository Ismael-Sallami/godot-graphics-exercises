# Problema 2.1:
# Implementa un nodo de tipo MeshInstance con
# una malla (no indexada) para un polígono regular
# de n lados relleno de color naranja plano (RGB
# (1.0, 0.7, 0.0)), con radio r y centro en el origen (ver
# figura).
# El polígono estará formado por n triángulos, cada uno
# con un vértice en el centro y los otros dos en el
# contorno. Los valores de n y r de declaran como dos
# constantes de GDScript (const), como se indica aquí:
# const n : int = 8
# const r : float = 0.8
# Los valores de estas constantes se podrán cambiar sin
# tocar nada del resto del script.

extends MeshInstance2D # <-- IMPORTANTE

const n: int = 8
const r: float = 0.8

func _ready():
	var vertices = PackedVector2Array()

	var center = Vector2(0, 0)

	var angle_step = TAU / n

	for i in range(n):
		var angle1 = i * angle_step
		var angle2 = (i + 1) * angle_step

		var p1 = Vector2(r * cos(angle1), r * sin(angle1))
		var p2 = Vector2(r * cos(angle2), r * sin(angle2))

		vertices.push_back(center)
		vertices.push_back(p1)
		vertices.push_back(p2)
	
	var tablas = []

	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices

	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

	modulate = Color(1.0, 0.7, 0.0)
