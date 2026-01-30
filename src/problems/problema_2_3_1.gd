extends MeshInstance2D

const n: int = 8
const r: float = 0.8 # Recuerda: usa el script de cámara o sube a 100.0 si no ves nada

func _ready():
	var vertices = PackedVector2Array()
	var indices = PackedInt32Array()
	
	var center = Vector2(0, 0)
	var angle_step = TAU / n
	
	# --- 1. GENERACIÓN DE VÉRTICES (TABLA DE VÉRTICES) ---
	# Añadimos el centro (Índice 0)
	vertices.push_back(center)
	
	# Añadimos los puntos del perímetro (Índices 1 a n)
	for i in range(n):
		var angle = i * angle_step
		var p = Vector2(cos(angle), sin(angle)) * r
		vertices.push_back(p)
		
	# --- 2. GENERACIÓN DE ÍNDICES (TABLA DE TRIÁNGULOS) ---
	# Conectamos los vértices ya existentes
	for i in range(n):
		# El centro siempre es el índice 0
		var idx_center = 0
		
		# Vértice actual del perímetro (empiezan en el índice 1)
		var idx_current = i + 1
		
		# Siguiente vértice. Usamos módulo (%) para cerrar el círculo
		# (Si estamos en el último, el siguiente debe ser el 1)
		var idx_next = (i + 1) % n + 1
		
		# Definimos el triángulo
		indices.push_back(idx_center)
		indices.push_back(idx_current)
		indices.push_back(idx_next)

	# --- 3. CREACIÓN DE LA MALLA ---
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = indices # ¡Ahora usamos índices!
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
	
	# Color plano para toda la malla
	modulate = Color(1.0, 0.7, 0.0)