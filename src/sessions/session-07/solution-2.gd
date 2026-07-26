# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 7
# Regenerate with: python3 tools/extract-from-latex.py

func calcular_blinn_phong_especular(n: Vector3, v: Vector3, l: Vector3, e: float, k_bp: float) -> float:
    # 1. Calcular el producto punto N.L para descartar luz trasera
    var n_dot_l : float = n.dot(l)

    if n_dot_l <= 0.0:
        return 0.0

    # 2. Calcular el vector halfway (bisectriz) h
    # Es la suma de L y V, normalizada
    var h : Vector3 = (l + v).normalized()

    # 3. Calcular el producto punto entre la normal y el halfway vector
    var n_dot_h : float = max(0.0, n.dot(h))

    # 4. Elevar a la potencia (exponente de brillo)
    var specular : float = pow(n_dot_h, e)

    # 5. Devolver resultado ponderado
    return k_bp * specular
