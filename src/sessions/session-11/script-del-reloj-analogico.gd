# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 11 / 3. Implementación en GDScript
# Caption: Script del Reloj Analógico
# Tagged language=Python in the document, for the syntax
# highlighter. The code is GDScript.
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

# Referencias a los nodos de las agujas (Pivotes)
var pivote_segundos: Node3D
var pivote_minutos: Node3D
var pivote_horas: Node3D

func _ready():
    # 1. Construccion procedimental de la escena
    crear_geometria_reloj()

func crear_geometria_reloj():
    # Creamos una esfera central como base
    var esfera = CSGSphere3D.new()
    esfera.radius = 0.5
    add_child(esfera)

    # Creamos las tres agujas. 
    # Usamos una funcion auxiliar para configurar: (Nombre, Largo, Ancho, Color)
    pivote_horas = crear_aguja(''Horas'', 2.0, 0.2, Color.black)
    pivote_minutos = crear_aguja(''Minutos'', 3.0, 0.15, Color.darkgray)
    pivote_segundos = crear_aguja(''Segundos'', 3.5, 0.05, Color.red)

func crear_aguja(nombre, largo, ancho, color) -> Node3D:
    # 1. El Pivote: Este nodo estara en (0,0,0) y es el que rotamos
    var pivote = Node3D.new()
    pivote.name = ''Pivote'' + nombre
    add_child(pivote)

    # 2. La Malla Visual: Hija del pivote
    var mesh = CSGBox3D.new()
    mesh.size = Vector3(ancho, largo, 0.1)

    # IMPORTANTE: Desplazamos la malla hacia arriba (Y+) la mitad de su largo.
    # Asi, el centro de rotacion (el pivote) queda en la base de la aguja.
    mesh.position = Vector3(0, largo / 2.0, 0)

    # Material
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    mesh.material = material

    pivote.add_child(mesh)
    return pivote

func _process(delta):
    # 1. Obtener el tiempo actual del sistema
    var tiempo = Time.get_time_dict_from_system()
    var horas = tiempo[''hour'']
    var minutos = tiempo[''minute'']
    var segundos = tiempo[''second'']

    # 2. Calcular t (segundos totales desde las 12:00)
    # Ajustamos horas a formato 12h para la formula
    horas = horas % 12

    # Calculo de alta precision para movimiento suave (incluyendo milisegundos si se quisiera)
    # t para segundos (ciclo 60s)
    var t_sec = segundos 
    # t para minutos (ciclo 3600s). Sumamos segundos para movimiento continuo
    var t_min = (minutos * 60.0) + segundos
    # t para horas (ciclo 43200s). Sumamos minutos y segundos
    var t_hour = (horas * 3600.0) + (minutos * 60.0) + segundos

    # 3. Calcular angulos (Theta) usando las formulas de la teoria
    # Theta = (2 * PI / Periodo) * t
    # Usamos negativo para rotacion en sentido horario (Clockwise)

    var theta_s = -(2.0 * PI / 60.0) * t_sec
    var theta_m = -(2.0 * PI / 3600.0) * t_min
    var theta_h = -(2.0 * PI / 43200.0) * t_hour

    # 4. Aplicar rotacion en el eje Z
    if pivote_segundos:
        pivote_segundos.rotation.z = theta_s
    if pivote_minutos:
        pivote_minutos.rotation.z = theta_m
    if pivote_horas:
        pivote_horas.rotation.z = theta_h
