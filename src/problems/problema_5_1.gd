# Problema 5.1:
# Implementa un proyecto cuya escena principal tenga un de tipo Node2D con
# varios nodos hijos, que formen la figura con un cuadrado de lado 2, centrado
# en el origen, y con un triángulo inscrito. El cuadrado debe estar relleno de azul
# claro, el triángulo de blanco, y las aristas deben verse de color azul oscuro.


extends Node2D

# Referencia al Singleton (Autoload) que contiene las herramientas
# const Utils = preload("res://FuncionesAuxiliaresT5.gd") # otra opción posible
# NOTA: Si ya lo tenemos configurado como Autoload global, puedes usar directamente 
# el nombre 'FuncionesAuxiliaresT5' en lugar de la variable 'Utils'.

func _ready():
	# ===============================
	# DEFINICIÓN DE GEOMETRÍA
	# Cuadrado de lado 2 centrado en el origen: va de -1 a 1 en X e Y.
	# Triángulo inscrito: definimos vértices que quepan dentro del cuadrado.
	# ===============================
	
	# Vértices para el RELLENO del cuadrado (2 triángulos para formar un quad)
	var v_cuadrado_relleno = PackedVector2Array([
		Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), # Triángulo 1
		Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)    # Triángulo 2
	])
	
	# Vértices para el BORDE del cuadrado (Polilínea cerrada)
	var v_cuadrado_borde = PackedVector2Array([
		Vector2(-1, -1), Vector2(1, -1), 
		Vector2(1, 1), Vector2(-1, 1), 
		Vector2(-1, -1) # Repetimos el primero para cerrar
	])

	# Vértices para el RELLENO del triángulo (1 triángulo simple)
	# Lo hacemos un poco más pequeño para que se vea "dentro" claramente
	var v_triangulo_relleno = PackedVector2Array([
		Vector2(-0.5, -0.5), Vector2(0.5, -0.5), Vector2(0, 0.8)
	])
	
	# Vértices para el BORDE del triángulo (Polilínea cerrada)
	var v_triangulo_borde = PackedVector2Array([
		Vector2(-0.5, -0.5), Vector2(0.5, -0.5), 
		Vector2(0, 0.8), Vector2(-0.5, -0.5)
	])

	# ===============================
	# CREACIÓN DE MALLAS
	# ===============================
	
	# 1. Crear el cuadrado relleno (Azul Claro)
	# Usamos una función local porque el Autoload solo crea LINE_STRIP
	var mesh_cuadrado_relleno = FuncionesAuxiliaresT5._crear_malla_rellena(v_cuadrado_relleno)
	var nodo_cuad_relleno = FuncionesAuxiliaresT5.CrearMeshInstance2D(mesh_cuadrado_relleno, Transform2D())
	nodo_cuad_relleno.modulate = Color(0.6, 0.8, 1.0) # Azul claro 
	add_child(nodo_cuad_relleno)
	
	# 2. Crear el borde del cuadrado (Azul Oscuro)
	# Usamos la función del Autoload (genera líneas)
	var mesh_cuadrado_borde = FuncionesAuxiliaresT5.CrearArrayMesh(v_cuadrado_borde)
	var nodo_cuad_borde = FuncionesAuxiliaresT5.CrearMeshInstance2D(mesh_cuadrado_borde, Transform2D())
	nodo_cuad_borde.modulate = Color(0.0, 0.0, 0.5) # Azul oscuro 
	# Opcional: aumentar grosor de línea si se usa un material específico, 
	# pero por defecto Godot dibuja líneas de 1px.
	add_child(nodo_cuad_borde)
	
	# 3. Crear el triángulo relleno (Blanco)
	var mesh_tri_relleno = FuncionesAuxiliaresT5._crear_malla_rellena(v_triangulo_relleno)
	var nodo_tri_relleno = FuncionesAuxiliaresT5.CrearMeshInstance2D(mesh_tri_relleno, Transform2D())
	nodo_tri_relleno.modulate = Color.WHITE # Blanco 
	add_child(nodo_tri_relleno)
	
	# 4. Crear el borde del triángulo (Azul Oscuro)
	var mesh_tri_borde = FuncionesAuxiliaresT5.CrearArrayMesh(v_triangulo_borde)
	var nodo_tri_borde = FuncionesAuxiliaresT5.CrearMeshInstance2D(mesh_tri_borde, Transform2D())
	nodo_tri_borde.modulate = Color(0.0, 0.0, 0.5) # Azul oscuro
	add_child(nodo_tri_borde)
	
	# Ajuste de visualización: Mover todo al centro de la pantalla para verlo mejor
	# position = get_viewport_rect().size / 2
	# scale = Vector2(100, 100) # Escalamos porque 2 pixels es muy pequeño # al activarlo se ve justo en el medio de toda la vista por lo que hay que hacer muy pequeña la misma
