// Extracted from the LaTeX write-up.
// Source: docs/latex/ejercicios-parte2.tex — Sesión 9 / 3. ¿Dentro o Fuera? (Coordenadas Baricéntricas)
// Regenerate with: python3 tools/extract-from-latex.py

Funcion CalcularRayoDesdePixel(xp, yp, w, filas, l, r, b, t, n, o_ec, x_ec, y_ec, z_ec):

// 1. Calcular coordenadas normalizadas del centro del pixel (0.0 a 1.0)
// Sumamos 0.5 para tomar el centro exacto del pixel
float ratio_x = (xp + 0.5) / w
float ratio_y = (yp + 0.5) / filas

// 2. Mapear al tamaño fisico del plano near (View Plane)
// Coordenada u (horizontal): interpolar entre left (l) y right (r)
float u = l + ((r - l) * ratio_x)

// Coordenada v (vertical): interpolar entre top (t) y bottom (b)
// IMPORTANTE: Asumimos que yp=0 es arriba (top) y yp=filas es abajo (bottom)
// Por tanto, a mayor yp, nos acercamos mas a 'b' y nos alejamos de 't'
float v = t - ((t - b) * ratio_y) 

// 3. Construir el vector de direccion en coordenadas del mundo
// El vector en espacio camara es (u, v, -n)
// Lo transformamos multiplicando por los versores de la base de la camara
// d = u*Right + v*Up + (-n)*Back

Vector3 direccion_no_norm = (x_ec * u) + (y_ec * v) - (z_ec * n)

// 4. Normalizar la direccion
Vector3 d = Normalizar(direccion_no_norm)

// 5. El origen del rayo es la posicion de la camara (proyeccion perspectiva)
Vector3 o = o_ec

Retornar {o, d}
