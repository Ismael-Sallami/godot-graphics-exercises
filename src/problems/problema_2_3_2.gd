extends MeshInstance2D

const n: int = 8
const r: float = 0.8 

func _ready():
	var vertices = PackedVector2Array()
	var colors = PackedColorArray()
	var indices = PackedInt32Array()
	
	var angle_step = TAU / n
	
	# Colores definidos
	var c_center = Color(1.0, 1.0, 1.0) # Blanco
	var c_light = Color(0.8, 0.8, 0.8)  # Gris Claro (Inicio arco)
	var c_dark = Color(0.2, 0.2, 0.2)   # Gris Oscuro (Fin arco)
	
	# --- 1. VÉRTICES Y COLORES ---
	
	# Vértice 0: El Centro (Compartido por todos)
	vertices.push_back(Vector2(0,0))
	colors.push_back(c_center)
	
	# Vértices del perímetro (No se pueden compartir entre triángulos vecinos)
	for i in range(n):
		var angle1 = i * angle_step
		var angle2 = (i + 1) * angle_step
		
		var p1 = Vector2(cos(angle1), sin(angle1)) * r
		var p2 = Vector2(cos(angle2), sin(angle2)) * r
		
		# Para cada triángulo, añadimos sus dos vértices del borde específicos
		vertices.push_back(p1) # Vértice 'Light' de este triángulo
		colors.push_back(c_light)
		
		vertices.push_back(p2) # Vértice 'Dark' de este triángulo
		colors.push_back(c_dark)
		
	# --- 2. ÍNDICES ---
	for i in range(n):
		# El centro siempre es 0
		# Los vértices del perímetro están agrupados de 2 en 2 a partir del índice 1
		# Triángulo 0 usa índices: 1 y 2
		# Triángulo 1 usa índices: 3 y 4...
		var base_idx = 1 + (i * 2)
		
		indices.push_back(0)        # Centro
		indices.push_back(base_idx) # Light
		indices.push_back(base_idx + 1) # Dark

	# --- 3. MALLA ---
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_COLOR] = colors
	tablas[Mesh.ARRAY_INDEX] = indices
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)