# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 6 / Explicación detallada de la implementación
# Regenerate with: python3 tools/extract-from-latex.py

# a, u, n: Vector3 (coordenadas de mundo)

# 1. Origen del marco de cámara
var o_ec : Vector3 = a + n

# 2. Eje Z (dirección de la vista, normalizado)
var z_ec : Vector3 = n.normalized()

# 3. Eje X (derecha, ortogonal a u y n, normalizado)
var x_ec : Vector3 = u.cross(n).normalized()

# 4. Eje Y (arriba, ortogonal a z_ec y x_ec)
var y_ec : Vector3 = z_ec.cross(x_ec)
