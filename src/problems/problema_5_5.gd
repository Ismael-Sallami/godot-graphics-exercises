# Problema 5.5:
# En un proyecto Godot 3D (puedes usar la práctica 2) para crear una figura
# como el logo de Android, usando únicamente dos objetos ArrayMesh, uno
# con un cilindro y otro con una semiesfera.

extends Node3D

# Variables para almacenar las dos únicas mallas permitidas
var malla_cilindro: ArrayMesh
var malla_semiesfera: ArrayMesh

# Materiales
var material_verde: StandardMaterial3D
var material_negro: StandardMaterial3D

func _ready():
	# 1. Crear los recursos (Materiales y Mallas)
	_crear_materiales()
	_generar_mallas()
	
	# 2. Construir la jerarquía (Ensamblaje)
	construir_android()

func _crear_materiales():
	# Verde corporativo de Android
	material_verde = StandardMaterial3D.new()
	material_verde.albedo_color = Color(0.24, 0.86, 0.35) # Aprox Android Green
	
	# Negro para los ojos
	material_negro = StandardMaterial3D.new()
	material_negro.albedo_color = Color.BLACK

func _generar_mallas():
	# --- Generar Cilindro ---
	# Usamos primitivas de Godot para simplificar el código del ejemplo,
	# pero conceptualmente es un ArrayMesh generado.
	var cilindro = CylinderMesh.new()
	cilindro.top_radius = 0.5
	cilindro.bottom_radius = 0.5
	cilindro.height = 1.0
	# Convertimos a ArrayMesh para cumplir estrictamente el enunciado
	# que pide "objetos ArrayMesh" (aunque PrimitiveMesh hereda de Mesh).
	malla_cilindro = ArrayMesh.new()
	malla_cilindro.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, cilindro.get_mesh_arrays())
	
	# --- Generar Semiesfera ---
	var esfera = SphereMesh.new()
	esfera.radius = 0.5
	esfera.height = 0.5 # Hacemos que sea media esfera
	esfera.is_hemisphere = true # Propiedad específica para semiesfera
	malla_semiesfera = ArrayMesh.new()
	malla_semiesfera.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, esfera.get_mesh_arrays())

func construir_android():
	# --- CUERPO (Cilindro) ---
	var cuerpo = MeshInstance3D.new()
	cuerpo.mesh = malla_cilindro
	cuerpo.material_override = material_verde
	# El cilindro por defecto tiene altura 1. Lo escalamos para que sea el cuerpo.
	cuerpo.scale = Vector3(1.5, 1.5, 1.5) 
	cuerpo.position = Vector3(0, 0.75, 0) # Subirlo un poco
	add_child(cuerpo)
	
	# --- CABEZA (Semiesfera) ---
	var cabeza = MeshInstance3D.new()
	cabeza.mesh = malla_semiesfera
	cabeza.material_override = material_verde
	cabeza.scale = Vector3(1.5, 1.5, 1.5) # Misma escala X/Z que el cuerpo
	cabeza.position = Vector3(0, 1.6, 0) # Sobre el cuerpo
	add_child(cabeza)
	
	# --- OJOS (Cilindros transformados) ---
	# Ojo Izquierdo
	var ojo_izq = MeshInstance3D.new()
	ojo_izq.mesh = malla_cilindro
	ojo_izq.material_override = material_negro
	# Transformación clave: Escalar el cilindro para que parezca un disco plano
	ojo_izq.scale = Vector3(0.1, 0.02, 0.1) 
	# Rotarlo para que mire al frente (El cilindro está orientado en Y por defecto)
	ojo_izq.rotation_degrees.x = 90
	ojo_izq.position = Vector3(-0.25, 0.25, 0.45) # Posición relativa a la cabeza
	cabeza.add_child(ojo_izq) # ¡Hijo de la cabeza!
	
	# Ojo Derecho (Instancia idéntica, distinta posición)
	var ojo_der = MeshInstance3D.new()
	ojo_der.mesh = malla_cilindro
	ojo_der.material_override = material_negro
	ojo_der.scale = Vector3(0.1, 0.02, 0.1)
	ojo_der.rotation_degrees.x = 90
	ojo_der.position = Vector3(0.25, 0.25, 0.45)
	cabeza.add_child(ojo_der)

	# --- ANTENAS (Cilindros finos) ---
	var antena_izq = MeshInstance3D.new()
	antena_izq.mesh = malla_cilindro
	antena_izq.material_override = material_verde
	antena_izq.scale = Vector3(0.05, 0.4, 0.05) # Fina y larga
	antena_izq.position = Vector3(-0.3, 0.4, 0)
	antena_izq.rotation_degrees.z = 30 # Inclinación
	cabeza.add_child(antena_izq)

	var antena_der = MeshInstance3D.new()
	antena_der.mesh = malla_cilindro
	antena_der.material_override = material_verde
	antena_der.scale = Vector3(0.05, 0.4, 0.05)
	antena_der.position = Vector3(0.3, 0.4, 0)
	antena_der.rotation_degrees.z = -30
	cabeza.add_child(antena_der)
	
	# --- EXTREMIDADES (Cilindros) ---
	# Aquí aplicamos lo aprendido en Session 5: Reutilización
	
	# Brazo Izquierdo
	var brazo_izq = MeshInstance3D.new()
	brazo_izq.mesh = malla_cilindro
	brazo_izq.material_override = material_verde
	brazo_izq.scale = Vector3(0.3, 1.0, 0.3)
	brazo_izq.position = Vector3(-0.9, 0.6, 0) # Al lado del cuerpo
	add_child(brazo_izq)
	
	# Brazo Derecho
	var brazo_der = MeshInstance3D.new()
	brazo_der.mesh = malla_cilindro
	brazo_der.material_override = material_verde
	brazo_der.scale = Vector3(0.3, 1.0, 0.3)
	brazo_der.position = Vector3(0.9, 0.6, 0)
	add_child(brazo_der)
	
	# Pierna Izquierda
	var pierna_izq = MeshInstance3D.new()
	pierna_izq.mesh = malla_cilindro
	pierna_izq.material_override = material_verde
	pierna_izq.scale = Vector3(0.3, 0.6, 0.3)
	pierna_izq.position = Vector3(-0.4, -0.4, 0) # Debajo del cuerpo
	add_child(pierna_izq)
	
	# Pierna Derecha
	var pierna_der = MeshInstance3D.new()
	pierna_der.mesh = malla_cilindro
	pierna_der.material_override = material_verde
	pierna_der.scale = Vector3(0.3, 0.6, 0.3)
	pierna_der.position = Vector3(0.4, -0.4, 0)
	add_child(pierna_der)

