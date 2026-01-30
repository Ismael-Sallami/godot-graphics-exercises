# Problema 6.1:
# Escribe el código GDScript para adjuntar a un nodo de tipo Camera3D, de forma
# que en cada frame la cámara apunte a un objeto móvil objetivo (por ejemplo
# un coche), con estos requerimientos:
# ● La posición y el vector de velocidad del objetivo (en coordenadas
# de mundo) se pueden obtener con dos funciones globales, llamadas
# objetivo.posicion() y objetivo.velocidad(), ambas devuelven un
# objeto de tipo Vector3.
# ● La cámara debe situarse detrás del objetivo, de forma que el punto
# devuelto por objetivo.posicion() se proyecte en el centro del viewport,
# y además la camara esté situada 3 unidades en horizontal por detrás del
# objetivo, y 2 unidades por encima (en el eje Y).


extends Camera3D

# Asumimos que 'objetivo' es un singleton (AutoLoad) o una clase global accesible.
# Si no fuera global, habría que obtener la referencia al nodo (ej. get_node("../Coche"))

# func _process(delta: float):
# 	# 1. Obtener datos del objetivo (en coordenadas de mundo)
# 	# Según el enunciado, existen estas funciones globales.
# 	var p_obj: Vector3 = objetivo.posicion()
# 	var v_obj: Vector3 = objetivo.velocidad()
	
# 	# 2. Calcular la dirección horizontal del movimiento
# 	# Creamos un vector con la velocidad pero ignorando la componente Y
# 	var direccion_hz: Vector3 = Vector3(v_obj.x, 0.0, v_obj.z)
	
# 	# IMPORTANTE: Si el coche está parado (velocidad casi 0), no podemos normalizar 
# 	# (división por cero). En un caso real, mantendríamos la última dirección válida.
# 	# Para el ejercicio, asumimos movimiento o usamos una dirección por defecto (ej. eje Z).
# 	if direccion_hz.length_squared() > 0.001:
# 		direccion_hz = direccion_hz.normalized()
# 	else:
# 		# Fallback: si está quieto, asumimos que "detrás" es el eje Z positivo (por ejemplo)
# 		# O idealmente, usaríamos la orientación del nodo objetivo (basis.z)
# 		direccion_hz = Vector3(0, 0, 1) 

# 	# 3. Calcular la posición deseada de la cámara
# 	# - Situada en la posición del objetivo
# 	# - Desplazada 2 unidades hacia ARRIBA (Eje Y global)
# 	# - Desplazada 3 unidades hacia ATRÁS (opuesto a la dirección horizontal)
# 	var nueva_posicion: Vector3 = p_obj + Vector3(0, 2, 0) - (direccion_hz * 3.0)
	
# 	# 4. Aplicar la posición a la cámara
# 	# Usamos global_position para asegurar que estamos en coords de mundo
# 	global_position = nueva_posicion
	
# 	# 5. Orientar la cámara (Transformación de Vista)
# 	# Hacemos que la cámara mire al punto objetivo.
# 	# El vector "Arriba" (Up) suele ser el eje Y global (Vector3.UP)
# 	look_at(p_obj, Vector3.UP)
