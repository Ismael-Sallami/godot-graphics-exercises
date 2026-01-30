## Nombre: Ismael, Apellidos: Sallami Moreno, Titulación: GIADE
## email: ism350zsallami@correo.ugr.es, DNI o pasaporte: 20888108Z

# extends Camera3D

## ----------------------------------------------------------------------
## contantes y variables de instancia 

# const at   := 2.5   ## ángulo de rot. con teclas (en grados x pulsación)
# const ar   := 0.5   ## ángulo de rot. con ratón (en grados x pixel)
# var   bdrp := false ## botón derecho del ratón presionado sí/no
# var   dz   := 3.0   ## distancia en Z de la cámara al origen
# var   dxy  := Vector2( 0.0, 0.0 ) ## ángulos hor. y vert. (en grados)

# ## -------------------------------------------------------------------
# ## actualiza la variable 'transform' de este nodo cámara

# func _actualiza_transf_vista(  ) -> void : 
# 	var ahr  := ((45.0+float(dxy.x))*2.0*PI)/360.0 ## ang.horiz.radi.
# 	var avr  := ((30.0+float(dxy.y))*2.0*PI)/360.0 ## ang.vert.radi.
# 	var tras := Transform3D().translated( Vector3( 0.0, 0.0, dz))	
# 	var rotx := Transform3D().rotated( Vector3.RIGHT, -avr )
# 	var roty := Transform3D().rotated( Vector3.UP, ahr ) 
# 	transform = roty*rotx*tras   ## actualiza transform del nodo cámara

# ## -------------------------------------------------------------------
# func _ready() -> void :  ## se ejecuta una vez al inicio
# 	_actualiza_transf_vista() ## inicializa la vista al inicio
	
# ## -------------------------------------------------------------------
# ## procesa evento de entrada

# func _input( event : InputEvent ): 
	
# 	var av : bool = true ## actualizar vista sí/no
	
# 	if event is InputEventKey and event.pressed: ## teclas
# 		match event.keycode:
# 			KEY_UP:    
# 				dxy += Vector2( 0, -at )
# 			KEY_DOWN:  
# 				dxy += Vector2( 0, +at )
# 			KEY_RIGHT: 
# 				dxy += Vector2( -at, 0 )
# 			KEY_LEFT:
# 				dxy += Vector2( at, 0 )
# 			KEY_MINUS, KEY_PAGEDOWN, KEY_KP_SUBTRACT: 
# 				dz *= 1.05 
# 			KEY_PLUS, KEY_PAGEUP, KEY_KP_ADD: 
# 				dz = max( dz/1.05, 0.1 )
# 			_: 
# 				av = false
				
# 	elif event is InputEventMouseButton: ## botón ratón o rueda
# 		match event.button_index:
# 			MOUSE_BUTTON_RIGHT: 
# 				bdrp = event.pressed 
# 				av = false 
# 			MOUSE_BUTTON_WHEEL_DOWN: 
# 				dz *= 1.05
# 			MOUSE_BUTTON_WHEEL_UP:   
# 				dz = max( dz/1.05, 0.1 )
# 			_: 
# 				av = false
				
# 	elif event is InputEventMouseMotion and bdrp: ## movim. ratón
# 		dxy += ar * Vector2( -event.relative.x, event.relative.y ) 
		
# 	else: ## otros tipos de eventos (no hace nada)
# 		av = false ## (no actualizar transf)

# 	if av:
# 		_actualiza_transf_vista( )


# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------


# extends Camera3D


# @onready var ray = $RayCast3D # == nodo `RayCast3D` hijo de la cámara

# func _input(event):
# 	var mouse_pos = get_viewport().get_mouse_position()
# 	var from = project_ray_origin(mouse_pos)
# 	var to = from + project_ray_normal(mouse_pos) * 1000.0
# 	if event is InputEventMouseButton and event.pressed \
# 	and event.button_index == MOUSE_BUTTON_LEFT:
# 		ray.global_position = from
# 		ray.look_at(to)
# 		ray.target_position = Vector3(0, 0, -1000) # Apunta en su -Z local
# 		ray.force_raycast_update()
# 		if ray.is_colliding():
# 			var objeto = ray.get_collider()
# 			if objeto.name == "Suelo" :
# 				crear_cubo_en(ray.get_collision_point())
# 				print("Creado cubo en:", ray.get_collision_point())



# func crear_cubo_en( pos ):
# 	var nuevo_cubo = MeshInstance3D.new()
# 	nuevo_cubo.mesh = BoxMesh.new()

# 	# Elevarlo para que no atraviese el suelo
# 	nuevo_cubo.position = pos + Vector3.UP * 0.5 
# 	var mat = StandardMaterial3D.new()
# 	mat.albedo_color = Color(randf(), randf(), randf())

# 	nuevo_cubo.material_override = mat
# 	get_tree().get_current_scene().add_child(nuevo_cubo)

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------



# extends Camera3D

# const RAY_LENGTH = 1000.0
# var objeto_seleccionado: Node3D = null # Aquí guardaremos la pieza que el usuario ha clicado

# func _input(event):
# 	# --- SELECCIÓN (Clic Izquierdo) ---
# 	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		seleccionar_objeto(event.position)

# 	# --- MOVIMIENTO (Teclas) ---
# 	# Solo movemos si hay algo seleccionado
# 	if objeto_seleccionado != null:
# 		var velocidad_rotacion = 0.1
		
# 		# Ejemplo: Rotar en Y con flechas Izquierda/Derecha
# 		if event.is_action_pressed("ui_left"):
# 			objeto_seleccionado.rotate_y(velocidad_rotacion)
# 		elif event.is_action_pressed("ui_right"):
# 			objeto_seleccionado.rotate_y(-velocidad_rotacion)
			
# 		# Ejemplo: Rotar en X (o Z) con flechas Arriba/Abajo
# 		if event.is_action_pressed("ui_up"):
# 			objeto_seleccionado.rotate_x(velocidad_rotacion)
# 		elif event.is_action_pressed("ui_down"):
# 			objeto_seleccionado.rotate_x(-velocidad_rotacion)

# func seleccionar_objeto(mouse_pos):
# 	var from = project_ray_origin(mouse_pos)
# 	var to = from + project_ray_normal(mouse_pos) * RAY_LENGTH
# 	var space_state = get_world_3d().direct_space_state
# 	var query = PhysicsRayQueryParameters3D.create(from, to)
	
# 	var result = space_state.intersect_ray(query)
	
# 	if result:
# 		# result.collider es el StaticBody3D que hemos golpeado.
# 		# Queremos mover la PIEZA (el padre del StaticBody), no el cuerpo físico solo.
# 		var collider = result.collider
# 		var pieza_padre = collider.get_parent() 
		
# 		# Verificamos si es una parte del modelo (puedes usar grupos para asegurar)
# 		print("Seleccionado: ", pieza_padre.name)
# 		objeto_seleccionado = pieza_padre
		
# 		# (Opcional) Aquí podrías cambiarle el material para que brille y se vea seleccionado
# 	else:
# 		print("Selección cancelada")
# 		objeto_seleccionado = null

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------


## Nombre: Ismael, Apellidos: Sallami Moreno
extends Camera3D

# --- CONFIGURACIÓN DE CÁMARA ORBITAL ---
const ar   := 0.5   ## Sensibilidad rotación ratón (grados x pixel)
var   dz   := 10.0  ## Distancia inicial de la cámara al centro (Zoom)
var   dxy  := Vector2(0.0, 20.0) ## Ángulos iniciales (Horizontal, Vertical)
var   bdrp := false ## Estado del botón DERECHO del ratón

# --- CONFIGURACIÓN DE SELECCIÓN ---
const RAY_LENGTH = 1000.0
var objeto_seleccionado: Node3D = null # La pieza actual

# --- MATERIAL PARA EL "BRILLO" ---
var material_brillo: StandardMaterial3D

func _ready() -> void:
	# 1. Configurar el material de resaltado (Brillo Amarillo Transparente)
	material_brillo = StandardMaterial3D.new()
	material_brillo.albedo_color = Color(1, 1, 0, 0.3) # Amarillo semitransparente
	material_brillo.emission_enabled = true
	material_brillo.emission = Color(0.8, 0.8, 0.0) # Luz propia
	material_brillo.emission_energy_multiplier = 2.0
	material_brillo.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	# Opcional: Si quieres que se vea "a través" de las paredes, descomenta esto:
	# material_brillo.no_depth_test = true 

	# 2. Inicializar posición de cámara
	_actualiza_transf_vista()

# ----------------------------------------------------------------------
# LÓGICA DE CÁMARA ORBITAL (Matemáticas del primer bloque)
# ----------------------------------------------------------------------
func _actualiza_transf_vista() -> void:
	# Convertimos grados a radianes y calculamos la posición en la esfera
	var ahr  = deg_to_rad(dxy.x) # Ángulo Horizontal
	var avr  = deg_to_rad(dxy.y) # Ángulo Vertical
	
	# Matriz de Transformación:
	# 1. Alejar la cámara (Zoom dz)
	var tras = Transform3D().translated(Vector3(0.0, 0.0, dz))   
	# 2. Rotar en X (Arriba/Abajo)
	var rotx = Transform3D().rotated(Vector3.RIGHT, -avr)
	# 3. Rotar en Y (Izquierda/Derecha)
	var roty = Transform3D().rotated(Vector3.UP, ahr) 
	
	# Aplicar transformaciones al nodo
	transform = roty * rotx * tras

# ----------------------------------------------------------------------
# PROCESAMIENTO DE ENTRADA (Input)
# ----------------------------------------------------------------------
func _input(event: InputEvent):
	var actualizar_camara = false

	# --- 1. CONTROL DE CÁMARA (Ratón) ---
	if event is InputEventMouseButton:
		# ZOOM (Rueda) -> Afecta a la cámara
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			dz *= 1.05
			actualizar_camara = true
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			dz = max(dz / 1.05, 0.1)
			actualizar_camara = true
		
		# ROTACIÓN (Click Derecho) -> Activa modo órbita
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			bdrp = event.pressed
			
		# SELECCIÓN (Click Izquierdo) -> Lógica de Raycast
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			seleccionar_objeto(event.position)

	# MOVIMIENTO DEL RATÓN (Solo si botón derecho presionado)
	elif event is InputEventMouseMotion and bdrp:
		dxy += ar * Vector2(-event.relative.x, event.relative.y)
		# Limitamos el ángulo vertical para que la cámara no de la vuelta completa loca
		dxy.y = clamp(dxy.y, -89.0, 89.0) 
		actualizar_camara = true

	# --- 2. CONTROL DE GRÚA (Teclas Flechas) ---
	# Solo si hay objeto seleccionado, las teclas mueven el objeto.
	# Si NO hay objeto, las teclas no hacen nada (para evitar interferencias).
	elif event is InputEventKey and event.pressed and objeto_seleccionado != null:
		var velocidad_rotacion = 0.05
		
		match event.keycode:
			KEY_LEFT:
				objeto_seleccionado.rotate_y(velocidad_rotacion)
			KEY_RIGHT:
				objeto_seleccionado.rotate_y(-velocidad_rotacion)
			KEY_UP:
				objeto_seleccionado.rotate_x(velocidad_rotacion)
			KEY_DOWN:
				objeto_seleccionado.rotate_x(-velocidad_rotacion)

	# Si algo cambió en la cámara, actualizamos su posición
	if actualizar_camara:
		_actualiza_transf_vista()

# ----------------------------------------------------------------------
# LÓGICA DE SELECCIÓN (Raycast + Brillo)
# ----------------------------------------------------------------------
func seleccionar_objeto(mouse_pos):
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	var result = space_state.intersect_ray(query)
	
	# 1. Limpiar selección anterior (quitar brillo)
	if objeto_seleccionado != null:
		quitar_brillo(objeto_seleccionado)
	
	# 2. Procesar nuevo clic
	if result:
		var collider = result.collider
		var pieza_padre = collider.get_parent() # Obtenemos la MeshInstance3D o Node3D
		
		# Filtro: Ignorar suelo
		if pieza_padre.name == "Suelo" or pieza_padre.name == "Plane":
			print("Suelo tocado. Selección limpiada.")
			objeto_seleccionado = null
			return

		# Nueva selección
		print("Seleccionado: ", pieza_padre.name)
		objeto_seleccionado = pieza_padre
		poner_brillo(objeto_seleccionado)
		
	else:
		print("Clic en vacío.")
		objeto_seleccionado = null

# --- FUNCIONES AUXILIARES PARA EL BRILLO ---

func poner_brillo(nodo: Node3D):
	# Intentamos aplicar el material al GeometryInstance3D (MeshInstance3D hereda de esto)
	if nodo is GeometryInstance3D:
		nodo.material_overlay = material_brillo
	
	# Si la pieza es un nodo padre y las mallas son hijos, buscamos dentro
	for hijo in nodo.get_children():
		if hijo is GeometryInstance3D:
			hijo.material_overlay = material_brillo

func quitar_brillo(nodo: Node3D):
	if is_instance_valid(nodo): # Comprobar que no se haya borrado
		if nodo is GeometryInstance3D:
			nodo.material_overlay = null
			
		for hijo in nodo.get_children():
			if hijo is GeometryInstance3D:
				hijo.material_overlay = null