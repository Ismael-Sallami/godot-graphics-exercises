extends Node2D

func _ready():
	var malla_gancho = Global.gancho()
	
	# Definimos el centro de rotación observado en la imagen
	var centro_rotacion = Vector2(-1, 1)
	
	# Creamos las 4 instancias
	for i in range(4):
		var instancia = MeshInstance2D.new()
		instancia.mesh = malla_gancho
		instancia.name = "Gancho_" + str(i)
		
		# Color azul para las aristas (modulate afecta a todo el mesh)
		instancia.modulate = Color(0, 0, 1)
		
		# Calculamos el ángulo: 0, 90, 180, 270 grados
		var angulo = i * (PI / 2.0) # usamos pi/2 ya que tenemos que el círculo completo es 2pi y como tenemos 4 instancias, 2pi/4 = pi/2
		
		# --- CÁLCULO DE LA MATRIZ DE TRANSFORMACIÓN ---
		# Aplicamos la fórmula: M = T(C) * R(theta) * T(-C)
		
		# 1. Matriz para mover el pivote al origen
		var t_al_origen = Transform2D().translated(-centro_rotacion)
		
		# 2. Matriz de rotación
		var rotacion = Transform2D().rotated(angulo)
		
		# 3. Matriz para devolver el pivote a su sitio
		var t_de_vuelta = Transform2D().translated(centro_rotacion)
		
		# En Godot, las matrices se multiplican en orden de aplicación (Padre * Hijo),
		# pero aquí estamos componiendo una sola transformación compleja.
		# El orden lógico es: primero T_al_origen, luego Rotacion, luego T_de_vuelta.
		# M * v = (T_vuelta * (Rot * (T_origen * v)))
		instancia.transform = t_de_vuelta * rotacion * t_al_origen
		
		add_child(instancia)

# Nota: la función gancho() localmente:
# func gancho() -> ArrayMesh:
#     var vertices = PackedVector2Array([
#         Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(0, 2)
#     ])
#     var am = ArrayMesh.new()
#     var arr = []
#     arr.resize(Mesh.ARRAY_MAX)
#     arr[Mesh.ARRAY_VERTEX] = vertices
#     am.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, arr)
#     return am