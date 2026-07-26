# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Enunciados.tex — Actividades / Añadir cámara
# Caption: Script para posicionamiento inicial de la cámara.
# Regenerate with: python3 tools/extract-from-latex.py

extends Camera3D

func _ready():
    position = Vector3(1.5, 1.5, 2.0)
    look_at(Vector3(0.0, 0.0, 0.0), Vector3.UP)
