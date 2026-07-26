# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 7
# Regenerate with: python3 tools/extract-from-latex.py

func calcular_brdf_ggx(wi: Vector3, wo: Vector3, tx: Vector3, ty: Vector3, nx: Vector3, ax: float, ay: float) -> float:
    # 1. Calcular el vector Halfway (h)
    var h: Vector3 = (wi + wo).normalized()

    # Pre-cálculo de productos punto necesarios
    var n_dot_wi = max(0.0001, nx.dot(wi)) # Evitar división por cero
    var n_dot_wo = max(0.0001, nx.dot(wo))
    var n_dot_h  = max(0.0, nx.dot(h))
    var h_dot_wi = max(0.0, h.dot(wi))

    # Proyecciones para anisotropía
    var h_dot_tx = h.dot(tx)
    var h_dot_ty = h.dot(ty)

    # 2. Calcular Distribución D (GGX Anisotrópica)
    var term_x = pow(h_dot_tx / ax, 2)
    var term_y = pow(h_dot_ty / ay, 2)
    var term_z = pow(n_dot_h, 2)

    var denom_d = PI * ax * ay * pow(term_x + term_y + term_z, 2)
    var D = 1.0 / max(0.0001, denom_d)

    # 3. Calcular Geometría G2 (Height Correlated)
    # Función Lambda auxiliar inline para wi
    var wi_x = wi.dot(tx) * ax
    var wi_y = wi.dot(ty) * ay
    var wi_z = n_dot_wi
    var lambda_wi = 0.5 * (-1.0 + sqrt(1.0 + (pow(wi_x, 2) + pow(wi_y, 2)) / pow(wi_z, 2)))

    # Función Lambda auxiliar inline para wo
    var wo_x = wo.dot(tx) * ax
    var wo_y = wo.dot(ty) * ay
    var wo_z = n_dot_wo
    var lambda_wo = 0.5 * (-1.0 + sqrt(1.0 + (pow(wo_x, 2) + pow(wo_y, 2)) / pow(wo_z, 2)))

    var G2 = 1.0 / (1.0 + lambda_wi + lambda_wo)

    # 4. Calcular Fresnel F (Aproximación de Schlick)
    var f0 = 0.04 # Valor asumido para dieléctricos si no se provee
    var F = f0 + (1.0 - f0) * pow(1.0 - h_dot_wi, 5)

    # 5. Resultado final combinado
    var numerador = F * D * G2
    var denominador = 4.0 * n_dot_wi * n_dot_wo

    return numerador / max(0.0001, denominador)
