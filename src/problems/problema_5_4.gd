# Problema 5.4:
# Implementa otro proyecto Godot que use la función del problema anterior
# para otra función, Arbol(n) que genera un árbol de escena con la figura
# de aquí abajo, que incluye múltiples instancias de Tronco, situadas recursi3
# vamente unas adyacentes a otras, hasta un nivel de recursividad dado por n.

extends Node2D

# Configuración del árbol
var niveles_recursividad : int = 7  

func _ready():
	# Generamos el árbol recursivo
	var arbol = Arbol(niveles_recursividad)
	add_child(arbol)

# ==================
# FUNCIÓN RECURSIVA: Arbol(n)
# Crea un nodo tronco y, si n > 0, le añade dos árboles más pequeños (n-1)
# en las puntas, transformados geométricamente para encajar.
# ==================
func Arbol(n: int) -> Node2D:
	# 1. Creamos la geometría de este nivel (el tronco base)
	var nodo_actual = Tronco()
	
	# 2. Caso Base: Si n es 0, terminamos aquí (solo devolvemos el tronco)
	if n <= 0:
		return nodo_actual
	
	# 3. Caso Recursivo: Crear ramas hijas
	
	# --- RAMA IZQUIERDA ---
	# Debe encajar en el segmento superior izquierdo (v7 -> v6) del padre.
	var hijo_izq = Arbol(n - 1) # Recursión
	hijo_izq.position = Vector2(-0.5, 3.0) # Vértice 7 del padre
	hijo_izq.scale = Vector2(0.5, 0.5)     # Reduce al 50%, ya que el ancho de 6-7 es 0.5 cuando la base del hijo mide 1
	hijo_izq.rotation = 0                  # Sin rotación (alineado con X)
	nodo_actual.add_child(hijo_izq)
	
	# --- RAMA DERECHA ---
	# Debe encajar en el segmento superior derecho (v4 -> v3) del padre.
	var hijo_der = Arbol(n - 1) # Recursión
	hijo_der.position = Vector2(1.5, 2.5)  # Vértice 4 del padre
	hijo_der.scale = Vector2(0.707, 0.707) # 1 / sqrt(2) approx, ya que la distancia entre los vértices 3-4 es su módulo, es decir, la diferencia de ambos puntos al cuadrado y sumada, luego aplicamos la raíz para saber el factor de escala 
	hijo_der.rotation_degrees = -45        # Rotar -45 para encajar, ya que vamos bajando y la base es horizontal
	nodo_actual.add_child(hijo_der)
	
	return nodo_actual

# ==================
# GEOMETRÍA DEL TRONCO (Del ejercicio 5.3, con tapas abiertas)
# ==================
func Tronco() -> Node2D:
	var n = Node2D.new()
	
	# Vértices (Tabla Pág. 60)
	var v0 = Vector2(0.0, 0.0); var v1 = Vector2(1.0, 0.0)
	var v2 = Vector2(1.0, 1.0); var v3 = Vector2(2.0, 2.0)
	var v4 = Vector2(1.5, 2.5); var v5 = Vector2(0.5, 1.5)
	var v6 = Vector2(0.0, 3.0); var v7 = Vector2(-0.5, 3.0)
	var v8 = Vector2(0.0, 1.5)
	
	# --- RELLENO (Triángulos) ---
	var vertices_relleno = PackedVector2Array([
		v0, v1, v2, v0, v2, v8, # Tronco
		v8, v2, v5,             # Centro
		v2, v3, v4, v2, v4, v5, # Rama Der
		v5, v6, v7, v5, v7, v8  # Rama Izq
	])
	var m_relleno = _crear_malla_triangulos(vertices_relleno)
	var inst_relleno = FuncionesAuxiliaresT5.CrearMeshInstance2D(m_relleno, Transform2D())
	inst_relleno.modulate = Color(0.7, 0.7, 1.0) 
	n.add_child(inst_relleno)
	
	# --- BORDE (Líneas Discontinuas) ---
	# NO incluimos las tapas (0-1, 3-4, 6-7) para que la recursión fluya visualmente
	var vertices_borde = PackedVector2Array([
		v1, v2, v2, v3, # Lado derecho
		v4, v5, v5, v6, # Interior V
		v7, v8, v8, v0  # Lado izquierdo
	])
	var m_borde = _crear_malla_segmentos(vertices_borde)
	var inst_borde = FuncionesAuxiliaresT5.CrearMeshInstance2D(m_borde, Transform2D())
	inst_borde.modulate = Color(0.0, 0.0, 0.8)
	n.add_child(inst_borde)
	
	return n

# ==================
# HELPERS LOCALES (las dejamos aquí para que a la hora de estudiar poder tenerlas más a mano)
# ==================
func _crear_malla_triangulos(v: PackedVector2Array) -> ArrayMesh:
	var tablas: Array = []; tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = v
	var am = ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
	return am

func _crear_malla_segmentos(v: PackedVector2Array) -> ArrayMesh:
	var tablas: Array = []; tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = v
	var am = ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, tablas)
	return am