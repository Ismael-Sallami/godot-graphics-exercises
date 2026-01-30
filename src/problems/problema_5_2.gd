extends Node2D

# Cargamos la escena del Problema 5.1 para instanciarla
const ESCENA_BASE = preload("res://escenaHijos/problema_5_1.tscn")

# Definimos una escala base para que se vea bien en pantalla
const S = 1

func _ready():
	# Centramos todo el conjunto en la pantalla
	# position = Vector2(200, 300)
	
	# =========================
	# INSTANCIA 1: CUADRADO ORIGINAL
	# =========================
	var ins1 = ESCENA_BASE.instantiate()
	ins1.scale = Vector2(S, S)
	ins1.position = Vector2(0, 0)
	add_child(ins1)
	
	# CALCULO DEL PUNTO DE CONEXIÓN 1 -> 2
	# La esquina superior derecha del cuadrado (ins1) en coordenadas locales es (1, -1).
	# En coordenadas globales (relativas al padre) es: (S, -S).
	
	# =========================
	# INSTANCIA 2: ROMBO (ROTADO 45 GRADOS)
	# =========================
	var ins2 = ESCENA_BASE.instantiate()
	ins2.scale = Vector2(S, S)
	ins2.rotation_degrees = 135 
	
	# CÁLCULO DE POSICIÓN PARA CONECTAR:
	# El rombo tiene su vértice IZQUIERDO a una distancia de 'sqrt(2) * S' de su centro.
	# Queremos que ese vértice coincida con la esquina (S, -S) del cuadrado.
	# PosX = (Posición Borde Cuadrado) + (Distancia al centro del Rombo)
	# PosX = S + (S * sqrt(2))
	# PosY = S (para alinearse con la parte superior del cuadrado)
	
	var offset_rombo = S * sqrt(2)
	ins2.position = Vector2(S + offset_rombo, S)
	
	add_child(ins2)
	
	# CALCULO DEL PUNTO DE CONEXIÓN 2 -> 3
	# El vértice DERECHO del rombo está a 'offset_rombo' a la derecha de su centro.
	# Posición Global Vértice Derecho = ins2.position + (offset_rombo, 0)
	
	# =========================
	# INSTANCIA 3: RECTÁNGULO INVERTIDO (ESCALADO)
	# =========================
	var ins3 = ESCENA_BASE.instantiate()
	# Escalado (2, -1):
	# X = 2 (Doble de ancho)
	# Y = -1 (Reflexión vertical, el triángulo apunta abajo)
	ins3.scale = Vector2(2 * S, -S)
	
	# CÁLCULO DE POSICIÓN PARA CONECTAR:
	# La "esquina superior izquierda" visual de este rectángulo corresponde 
	# geométricamente a (-1, 1) local antes de escalar, o (-2S, -S) después de escalar.
	# Queremos que (-2S, -S) coincida con el vértice derecho del rombo.
	
	# Coordenada X del vértice derecho del rombo:
	var x_conexion = ins2.position.x + offset_rombo
	
	# La posición del centro de ins3 debe ser tal que su izquierda (-2S) toque la conexión.
	ins3.position.x = x_conexion + (2 * S)
	
	# Coordenada Y: Queremos que la parte superior (-S visual) toque la conexión (ins2.y = -S)
	# Como ins2 está en Y = -S y su vértice derecho está en Y=0 relativo a él...
	# Espera, el vértice derecho del rombo está en la misma Y que su centro (ins2.position.y).
	# ins2.position.y es -S.
	# La parte superior del rectángulo está en -S relativo a su centro (0).
	# Por tanto, si ponemos el centro de ins3 en Y=0, su parte superior estará en -S.
	ins3.position.y = 0 
	
	add_child(ins3)
