# Problema 5.3:
# Implementa un proyecto Godot con una función Troncoque crea y devuelve
# un Node2D con dos nodos hijos que forman la figura de aquí abajo (uno para
# el relleno y otro para las aristas).

# PARTIMOS DE QUE EN 2D EL SENTIDO DA IGUAL, PERO SABEMOS QUE ES HORARIO

extends Node2D

func _ready():
	# Generamos el tronco
	var tronco = Tronco()
	
	# Lo añadimos a la escena
	add_child(tronco)

# =====================
# Función: Tronco
# Descripción: Crea un Node2D compuesto por dos mallas (relleno y borde)
# siguiendo la tabla de coordenadas de la página 60.
# =====================
func Tronco() -> Node2D:
	var n = Node2D.new()
	
	# 1. Definición de Vértices según la tabla del PDF 
	var v0 = Vector2(0.0, 0.0)
	var v1 = Vector2(1.0, 0.0)
	var v2 = Vector2(1.0, 1.0)
	var v3 = Vector2(2.0, 2.0)
	var v4 = Vector2(1.5, 2.5)
	var v5 = Vector2(0.5, 1.5)   # El "entrepierna" o bifurcación
	var v6 = Vector2(0.0, 3.0)
	var v7 = Vector2(-0.5, 3.0)
	var v8 = Vector2(0.0, 1.5)
	
	# -----------------------
	# A. MALLA DE RELLENO (Triángulos)
	# -----------------------
	# Como el polígono es cóncavo, debemos triangularlo manualmente.
	# Dividimos la figura en 7 triángulos para cubrir toda la superficie.
	var vertices_relleno = PackedVector2Array([
		# Base del tronco (Cuadrilátero 0-1-2-8 dividido en dos)
		v0, v1, v2,
		v0, v2, v8,
		
		# Triángulo central de unión (conecta tronco con ramas)
		v8, v2, v5,
		
		# Rama Derecha (Cuadrilátero 2-3-4-5 dividido)
		v2, v3, v4,
		v2, v4, v5,
		
		# Rama Izquierda (Cuadrilátero 5-6-7-8 dividido)
		v5, v6, v7,
		v5, v7, v8
	])
	
	# Usamos la función local auxiliar para crear malla de tipo TRIANGLES
	var malla_relleno = FuncionesAuxiliaresT5._crear_malla_rellena(vertices_relleno)
	
	# Instanciamos usando la función del autoload y asignamos color lavanda/azul claro
	var inst_relleno = FuncionesAuxiliaresT5.CrearMeshInstance2D(malla_relleno, Transform2D())
	inst_relleno.modulate = Color(0.7, 0.7, 1.0) 
	n.add_child(inst_relleno)
	
	# -----------------------
	# B. MALLA DE BORDE (Línea)
	# -----------------------
	# Recorremos el perímetro exterior en orden
	# var vertices_borde = PackedVector2Array([
	# 	v0, v1, v2, v3, v4, v5, v6, v7, v8s # Cerramos volviendo a v0
	# ])

	var vertices_borde = PackedVector2Array([
		v1, v2,  # Lado derecho tronco
		v2, v3,  # Lado derecho rama derecha
		# Saltamos 3-4 (punta derecha)
		v4, v5,  # Lado izquierdo rama derecha (interior V)
		v5, v6,  # Lado derecho rama izquierda (interior V)
		# Saltamos 6-7 (punta izquierda)
		v7, v8,  # Lado izquierdo rama izquierda
		v8, v0   # Lado izquierdo tronco
		# Saltamos 0-1 (base+)
	])
	
	# Usamos la función del autoload (genera LINE SIN STRIP ya que este los conecta todos)
	var malla_borde = FuncionesAuxiliaresT5._crear_malla_lineas_pares(vertices_borde)
	
	# Instanciamos y asignamos color azul oscuro
	var inst_borde = FuncionesAuxiliaresT5.CrearMeshInstance2D(malla_borde, Transform2D())
	inst_borde.modulate = Color(0.0, 0.0, 0.0)
	n.add_child(inst_borde)
	
	return n
