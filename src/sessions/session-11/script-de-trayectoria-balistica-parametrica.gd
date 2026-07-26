# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 11 / 3. Implementación en GDScript
# Caption: Script de Trayectoria Balística Paramétrica
# Tagged language=Python in the document, for the syntax
# highlighter. The code is GDScript.
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

# Parametros de lanzamiento (Vector3)
# v_y debe ser positiva para que suba.
# v_z o v_x dan el desplazamiento horizontal.
export var velocidad_inicial: Vector3 = Vector3(0, 15, 10) 
export var gravedad: float = 9.8

# Variables de estado
var tiempo_vuelo: float = 0.0
var posicion_inicial: Vector3
var vector_gravedad: Vector3

# Referencia al objeto visual
onready var bala = $Bala

func _ready():
    # Guardamos la posicion original para reiniciar el ciclo
    if bala:
        posicion_inicial = bala.global_position
    else:
        posicion_inicial = Vector3.ZERO

    # Pre-calculamos el vector de aceleracion
    vector_gravedad = Vector3(0, -gravedad, 0)

    # Configuracion visual opcional (crear bala si no existe)
    if not bala:
        crear_bala_procedimental()

func crear_bala_procedimental():
    var mesh = CSGSphere3D.new()
    mesh.radius = 0.5
    mesh.name = ''Bala''
    add_child(mesh)
    bala = mesh
    mesh.global_position = posicion_inicial

    # Material rojo para visibilidad
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(1, 0, 0)
    mesh.material = mat

func _process(delta):
    # 1. Acumular el tiempo real transcurrido
    tiempo_vuelo += delta

    # 2. Calcular la posicion usando la formula parametrica exacta:
    # p(t) = p0 + v0*t + 0.5 * a * t^2
    var desplazamiento_vel = velocidad_inicial * tiempo_vuelo
    var desplazamiento_acel = 0.5 * vector_gravedad * pow(tiempo_vuelo, 2)

    var nueva_posicion = posicion_inicial + desplazamiento_vel + desplazamiento_acel

    # 3. Aplicar al objeto
    if bala:
        bala.global_position = nueva_posicion

    # 4. Logica de reinicio (Loop)
    # Si la bala cae por debajo de la altura inicial y ha pasado algo de tiempo
    if nueva_posicion.y < posicion_inicial.y and tiempo_vuelo > 0.1:
        reiniciar_animacion()

func reiniciar_animacion():
    tiempo_vuelo = 0.0
    if bala:
        bala.global_position = posicion_inicial

    # Opcional: Imprimir duracion teorica vs real
    # T_teorico = 2 * Vy / g
    # var t_teorico = (2.0 * velocidad_inicial.y) / gravedad
    # print(''Ciclo completado. T esperado: '', t_teorico)
