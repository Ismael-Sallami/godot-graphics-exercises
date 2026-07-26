# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 11 / 3. Implementación en GDScript
# Caption: Script de Oscilación Triangular Controlada
# Tagged language=Python in the document, for the syntax
# highlighter. The code is GDScript.
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

# Variables de configuracion (exportadas para editar en el inspector)
export var s: float = 5.0      # Amplitud maxima (metros)
export var T: float = 2.0      # Periodo completo (segundos)
export var radio: float = 0.5  # Radio visual de la esfera

# Variables de estado
var x_actual: float = 0.0
var direccion: int = 1         # 1: Derecha, -1: Izquierda
var velocidad: float = 0.0     # Magnitud de la velocidad

# Referencia al nodo visual
onready var esfera = $Esfera

func _ready():
    # Calculo de la velocidad necesaria para cumplir el periodo T
    # Distancia total por ciclo = 4 * s
    if T > 0:
        velocidad = (4.0 * s) / T
    else:
        velocidad = 0.0

    # Ajuste visual inicial
    if esfera:
        # Si es un CSGSphere3D, ajustamos el radio propiedad
        if ''radius'' in esfera:
            esfera.radius = radio
        # Posicion inicial
        esfera.position = Vector3(0, radio, 0)

func _process(delta):
    # 1. Calcular el paso teorico en este frame
    var distancia_paso = velocidad * delta

    # 2. Aplicar movimiento
    x_actual += distancia_paso * direccion

    # 3. Verificacion de limites y correccion de rebote

    # Limite derecho (+s)
    if x_actual > s:
        var exceso = x_actual - s
        x_actual = s - exceso   # Reflejar el exceso hacia atras
        direccion = -1          # Invertir direccion

    # Limite izquierdo (-s)
    elif x_actual < -s:
        var exceso = -s - x_actual # Cuanto nos pasamos por la izquierda
        x_actual = -s + exceso     # Reflejar el exceso hacia delante
        direccion = 1              # Invertir direccion

    # 4. Actualizar la posicion del nodo visual
    if esfera:
        esfera.position.x = x_actual
        esfera.position.y = radio
        esfera.position.z = 0.0
