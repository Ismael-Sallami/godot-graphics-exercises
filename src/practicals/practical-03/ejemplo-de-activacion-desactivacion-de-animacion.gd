# Extracted from the LaTeX write-up.
# Source: docs/latex/resolucionpr3.tex — Desarrollo Detallado de las Actividades / Gestión de Eventos y Acciones de Entrada
# Caption: Ejemplo de Activación/Desactivación de Animación
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

@export var activar := "activar_brazo" # Acción definida en Input Map
@export var rotation_speed_deg := 10.0
var activa := true 

func _process(delta):
    # 1. Manejo de la entrada para alternar el estado
    if Input.is_action_just_pressed(activar):
            activa = !activa

    # 2. Aplicar la transformación solo si está activa
    if activa:
            rotation.y += deg_to_rad(rotation_speed_deg * delta)
