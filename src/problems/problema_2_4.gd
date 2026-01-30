extends MeshInstance2D

# Problema 2.4:
# Crea un nuevo nodo MeshInstance2D de for7
# ma que ahora veamos simplemente las aristas
# del polígono regular descrito en los anteriores
# problemas. En la figura se ve para n a 16 y el
# mismo radio.
# Considera dos casos:
# - Usando una malla no indexada.
# - Usando una malla indexadas.

var no_indexado: bool = false
const n: int = 16 # Actualizado a 16 como pide el enunciado
const r: float = 0.8
var centre: Vector2 = Vector2(0, 0)

func _ready():
	if no_indexado:
		var vertices = PackedVector2Array()
		var angle_step = TAU / n # TAU es 2*PI
		
		# Generamos pares de vértices para cada línea
		for i in range(n):
			var angle_current = i * angle_step
			var angle_next = (i + 1) * angle_step
			
			# Calculamos los dos extremos del segmento actual
			var p1 = Vector2(cos(angle_current), sin(angle_current)) * r
			var p2 = Vector2(cos(angle_next), sin(angle_next)) * r
			
			# Añadimos ambos al array. 
			# Como NO es indexada, repetimos vértices geométricos.
			vertices.push_back(centre)
			vertices.push_back(p1)

			vertices.push_back(p1)
			vertices.push_back(p2)

		
		# Preparamos la estructura SOA
		var tablas = []
		tablas.resize(Mesh.ARRAY_MAX)
		tablas[Mesh.ARRAY_VERTEX] = vertices
		
		mesh = ArrayMesh.new()
		# IMPORTANTE: Cambiamos el tipo de primitiva a LÍNEAS
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, tablas)
		
		# Color para las líneas (ej. Verde o Rojo)
		modulate = Color(0.0, 1.0, 0.0)
	else:
		var vertices = PackedVector2Array()
		var indices = PackedInt32Array()
		var angle_step = TAU / n
		
		# 1. TABLA DE VÉRTICES
		# Primero añadimos el CENTRO (Índice 0)
		vertices.push_back(centre)
		
		# Luego los puntos del perímetro (Índices 1 a n)
		for i in range(n):
			var angle = i * angle_step
			var p = Vector2(cos(angle), sin(angle)) * r
			vertices.push_back(p)
			
		# 2. TABLA DE ÍNDICES
		for i in range(n):
			# El centro es el índice 0
			var idx_center = 0
			# Vértice actual del borde (offset +1 porque el 0 es el centro)
			var idx_current = i + 1
			# Siguiente vértice (con módulo para cerrar el círculo)
			var idx_next = (i + 1) % n + 1
			
			# --- DEFINIMOS LAS LÍNEAS ---
			
			# Línea 1: Radio (Conecta Centro con Actual)
			indices.push_back(idx_center)
			indices.push_back(idx_current)
			
			# Línea 2: Borde (Conecta Actual con Siguiente)
			indices.push_back(idx_current)
			indices.push_back(idx_next)
			
		# 3. CREACIÓN DE LA MALLA
		var tablas = []
		tablas.resize(Mesh.ARRAY_MAX)
		tablas[Mesh.ARRAY_VERTEX] = vertices
		tablas[Mesh.ARRAY_INDEX] = indices # ¡Asignamos los índices!
		
		mesh = ArrayMesh.new()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, tablas)
		
		modulate = Color(1.0, 0.0, 0.0) # Rojo