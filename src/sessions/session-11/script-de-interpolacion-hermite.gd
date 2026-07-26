# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 11 / 4. Implementación en GDScript
# Caption: Script de Interpolación Hermite
# Tagged language=Python in the document, for the syntax
# highlighter. The code is GDScript.
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

# Datos de entrada: Puntos de paso y sus instantes de tiempo
var puntos = [
    Vector3(0, 0, 0),
    Vector3(4, 0, 4),
    Vector3(8, 0, -2),
    Vector3(12, 0, 5)
]
var tiempos = [0.0, 2.0, 5.0, 8.0] # t0 debe ser 0.0

# Almacen de velocidades calculadas
var velocidades = []

# Referencia al objeto visual (el coche)
onready var objeto_movil = $Coche
var tiempo_actual = 0.0

func _ready():
    # 1. Calcular tangentes automaticamente
    calcular_velocidades_hermite()

    # 2. Visualizar marcadores (discos)
    crear_marcadores_visuales()

func calcular_velocidades_hermite():
    var n = puntos.size()
    velocidades.resize(n)

    # Velocidad 0 en extremos (arranque y parada suave)
    velocidades[0] = Vector3.ZERO
    velocidades[n-1] = Vector3.ZERO

    # Calculo para puntos intermedios: v_i = (p_next - p_prev) / (t_next - t_prev)
    for i in range(1, n - 1):
        var dist_vector = puntos[i+1] - puntos[i-1]
        var intervalo_t = tiempos[i+1] - tiempos[i-1]
        velocidades[i] = dist_vector / intervalo_t

func crear_marcadores_visuales():
    for p in puntos:
        var marcador = CSGCylinder3D.new()
        marcador.radius = 0.3
        marcador.height = 0.1
        marcador.material = StandardMaterial3D.new()
        marcador.material.albedo_color = Color(1, 0, 0) # Rojo
        add_child(marcador)
        marcador.global_position = p

# Funcion principal de interpolacion
func obtener_posicion_velocidad(t):
    var n = puntos.size()

    # Caso limite: si t supera el tiempo final
    if t >= tiempos[n-1]:
        return {''pos'': puntos[n-1], ''dir'': Vector3.FORWARD}

    # Buscar el intervalo [i, i+1] correspondiente al tiempo t
    var i = 0
    while i < n - 1 and t > tiempos[i+1]:
        i += 1

    # Datos del tramo actual
    var p0 = puntos[i]
    var p1 = puntos[i+1]
    var v0 = velocidades[i]
    var v1 = velocidades[i+1]
    var t0 = tiempos[i]
    var t1 = tiempos[i+1]

    # Parametro u normalizado (0 a 1)
    var s = t1 - t0 # Duracion del intervalo
    var u = (t - t0) / s

    # Pre-calculo de potencias de u
    var u2 = u * u
    var u3 = u2 * u

    # Funciones base de Hermite (h00, h10, h01, h11)
    var h00 = 2*u3 - 3*u2 + 1
    var h10 = u3 - 2*u2 + u
    var h01 = -2*u3 + 3*u2
    var h11 = u3 - u2

    # Interpolacion de la Posicion (notese v * s para escalar la tangente)
    var pos = h00*p0 + h10*s*v0 + h01*p1 + h11*s*v1

    # Calculo de la velocidad instantanea (Derivada de P respecto a t)
    # Derivadas de las bases respecto a u:
    var dh00 = 6*u2 - 6*u
    var dh10 = 3*u2 - 4*u + 1
    var dh01 = -6*u2 + 6*u
    var dh11 = 3*u2 - 2*u

    # v(t) = P'(u) * (du/dt) = P'(u) * (1/s)
    var vel = (dh00*p0 + dh10*s*v0 + dh01*p1 + dh11*s*v1) / s

    return {''pos'': pos, ''dir'': vel}

func _process(delta):
    tiempo_actual += delta

    # Reiniciar bucle si termina
    if tiempo_actual > tiempos.back():
        tiempo_actual = 0.0

    # Calcular estado fisico
    var estado = obtener_posicion_velocidad(tiempo_actual)

    # Aplicar transformaciones
    if objeto_movil:
        objeto_movil.global_position = estado[''pos'']

        # Orientar el objeto segun el vector de velocidad (tangente)
        # Se evita el error si la velocidad es muy cercana a cero
        if estado[''dir''].length_squared() > 0.001:
            var objetivo_mirar = estado[''pos''] + estado[''dir'']
            objeto_movil.look_at(objetivo_mirar, Vector3.UP)
