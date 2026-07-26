# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 11 / 3. Implementación en GDScript
# Caption: Script del Péndulo Oscilante
# Tagged language=Python in the document, for the syntax
# highlighter. The code is GDScript.
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

# Parametros fisicos configurables
export var theta_max_degrees: float = 45.0 # Amplitud maxima en grados
export var periodo: float = 2.0            # Periodo T en segundos
export var longitud_cuerda: float = 3.0    # Longitud L

# Variables internas
var tiempo_acumulado: float = 0.0
var theta_max_rad: float = 0.0

# Referencias a los nodos visuales (se crearan por codigo si no existen)
var varilla: CSGBox3D
var masa: CSGSphere3D

func _ready():
    # Convertir grados a radianes para las funciones trigonometricas
    theta_max_rad = deg_to_rad(theta_max_degrees)

    # Construccion procedimental del pendulo visual
    construir_geometria()

func construir_geometria():
    # 1. Crear la varilla (Cuerda)
    varilla = CSGBox3D.new()
    varilla.size = Vector3(0.1, longitud_cuerda, 0.1) # Grosor y largo

    # IMPORTANTE: Desplazar la varilla hacia abajo la mitad de su longitud.
    # Asi, el extremo superior coincide con el origen del Pivote (0,0,0).
    varilla.position = Vector3(0, -longitud_cuerda / 2.0, 0)

    # Material visual para la varilla
    var mat_varilla = StandardMaterial3D.new()
    mat_varilla.albedo_color = Color.gray
    varilla.material = mat_varilla

    add_child(varilla)

    # 2. Crear la masa (Esfera en el extremo)
    masa = CSGSphere3D.new()
    masa.radius = 0.4

    # La masa se coloca al final de la cuerda
    masa.position = Vector3(0, -longitud_cuerda, 0)

    # Material visual para la masa
    var mat_masa = StandardMaterial3D.new()
    mat_masa.albedo_color = Color.red
    masa.material = mat_masa

    add_child(masa)

func _process(delta):
    # 1. Acumular el tiempo
    tiempo_acumulado += delta

    # Opcional: Evitar desbordamiento de float reseteando cada periodo
    if tiempo_acumulado > periodo:
        tiempo_acumulado -= periodo

    # 2. Calcular el angulo actual usando la formula armonica
    # theta(t) = theta_max * sin(2 * PI * t / T)
    var theta = theta_max_rad * sin((2.0 * PI * tiempo_acumulado) / periodo)

    # 3. Aplicar la rotacion al Pivote
    # Se rota en el eje Z para oscilar izquierda-derecha
    rotation.z = theta
