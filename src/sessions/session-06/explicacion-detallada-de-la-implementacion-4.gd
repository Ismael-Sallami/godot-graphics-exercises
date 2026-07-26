# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 6 / Explicación detallada de la implementación
# Regenerate with: python3 tools/extract-from-latex.py

# NUEVA FUNCION: Ajuste dinamico de la proyeccion (Problema 6.6)
func _actualiza_proyeccion() -> void:
    # 1. Obtener tamano del viewport
    var vp_size := get_viewport().size

    # Evitamos division por cero si la ventana se minimiza completamente
    if vp_size.y == 0: return 

    # 2 y 3. Calcular relacion de aspecto (ancho / alto)
    var aspect_ratio := float(vp_size.x) / float(vp_size.y)

    # 4. Ajuste segun la forma de la ventana
    if aspect_ratio < 1.0:
        # Si es mas alto que ancho (Portrait), fijamos el ancho
        keep_aspect = Camera3D.KEEP_WIDTH
    else:
        # Si es mas ancho que alto (Landscape), fijamos el alto (por defecto)
        keep_aspect = Camera3D.KEEP_HEIGHT

    # Aseguramos que el FOV base sea siempre 75 grados
    fov = 75.0
