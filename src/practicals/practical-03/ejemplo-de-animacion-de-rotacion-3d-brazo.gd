# Extracted from the LaTeX write-up.
# Source: docs/latex/resolucionpr3.tex — Desarrollo Detallado de las Actividades / Implementación de la Animación en GDScript
# Caption: Ejemplo de Animación de Rotación 3D (Brazo)
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

@export var rotation_speed_deg := 10.0 # grados por segundo

func _process(delta):
    # Rotación continua en Y
    rotation.y += deg_to_rad(rotation_speed_deg * delta)
