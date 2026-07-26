# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Enunciados.tex — Actividades / Crear una pirámide (generación por código)
# Caption: Fragmento del script \texttt{piramide.gd
# Regenerate with: python3 tools/extract-from-latex.py

func crear_piramide(h: float) -> ArrayMesh:
    var st = SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)

    # Coordenadas de la base (cuadrado centrado en el origen, lado 1)
    var p1 = Vector3(-0.5, 0, -0.5)
    var p2 = Vector3( 0.5, 0, -0.5)
    var p3 = Vector3( 0.5, 0,  0.5)
    var p4 = Vector3(-0.5, 0,  0.5)
    var apex = Vector3(0, h, 0)

    # Caras laterales (triangulos)
    _add_triangulo(st, p1, p2, apex)
    _add_triangulo(st, p2, p3, apex)
    _add_triangulo(st, p3, p4, apex)
    _add_triangulo(st, p4, p1, apex)

    # Base (dos triangulos)
    _add_triangulo(st, p1, p3, p2, Vector3.DOWN)
    _add_triangulo(st, p1, p4, p3, Vector3.DOWN)

    return st.commit()
