# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 7
# Regenerate with: python3 tools/extract-from-latex.py

func calcular_phong_especular(n: Vector3, v: Vector3, l: Vector3, e: float, k_ph: float) -> float:
    # 1. Calcular el producto punto entre la normal y la luz (Lambert)
    var n_dot_l : float = n.dot(l)

    # 2. Si la luz está detrás de la superficie, no hay especularidad
    if n_dot_l <= 0.0:
        return 0.0

    # 3. Calcular el vector reflejado r
    # Fórmula: r = 2 * (n . l) * n - l
    # En GDScript se puede usar reflect(), pero ojo: reflect devuelve 
    # el vector reflejado dada la dirección incidente y la normal. 
    # La fórmula manual es más explícita para teoría.
    var r : Vector3 = (2.0 * n_dot_l * n - l).normalized()

    # 4. Calcular el factor especular (r . v)^e
    var r_dot_v : float = max(0.0, r.dot(v))
    var specular : float = pow(r_dot_v, e)

    # 5. Devolver intensidad final ponderada por k_ph
    return k_ph * specular
