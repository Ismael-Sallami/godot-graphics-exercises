# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 4
# Regenerate with: python3 tools/extract-from-latex.py

func calcular_aristas_caso_a(triangulos: Array[Vector3i]) -> Array[Vector2i]:
    var aristas_unicas = {} # Usamos un diccionario como Set
    for t in triangulos:
        # Extraemos los 3 pares de vértices
        var pares = [
            Vector2i(t[0], t[1]),
            Vector2i(t[1], t[2]),
            Vector2i(t[2], t[0])
        ]
        for par in pares:
            # Normalizamos la arista: (menor, mayor)
            var a = par.x
            var b = par.y
            var key: Vector2i
            if a < b:
                key = Vector2i(a, b)
            else:
                key = Vector2i(b, a)
            # Insertamos en el diccionario (la clave evita duplicados)
            aristas_unicas[key] = true
    # Convertimos las claves del diccionario a un Array
    var ari: Array[Vector2i] = []
    for key in aristas_unicas.keys():
        ari.append(key)
    return ari
