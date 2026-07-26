# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 6 / Explicación detallada de la implementación
# Regenerate with: python3 tools/extract-from-latex.py

# Suponemos disponibles: x_ec, y_ec, z_ec, o_ec (Vector3)

# 1. Construir la base (rotación): columnas de la base son los ejes de cámara
var R := Basis(x_ec, y_ec, z_ec)
var vista_basis := R.transposed()

# 2. Calcular la traslación (origen) según la fórmula de la matriz de vista
var d_x = -x_ec.dot(o_ec)
var d_y = -y_ec.dot(o_ec)
var d_z = -z_ec.dot(o_ec)
var vista_origin = Vector3(d_x, d_y, d_z)

# 3. Construir la matriz de vista final
var matriz_vista = Transform3D(vista_basis, vista_origin)

# La función de Transform3D lo que es empaqueta todo en un solo objeto, en este caso, lo que hace es crear una matriz de 4x4 a partir de una matriz de 3x3 (Basis) y un vector de traslación (origin).
