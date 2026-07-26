// Extracted from the LaTeX write-up.
// Source: docs/latex/ejercicios-parte2.tex — Sesión 9
// Regenerate with: python3 tools/extract-from-latex.py

Funcion IntersectarRayoTriangulo(o, d, v0, v1, v2):
// --- Pre-computo de vectores del triangulo ---
Vector3 e1 = v1 - v0
Vector3 e2 = v2 - v0
Vector3 n  = ProductoCruz(e1, e2) // Normal del plano


// --- Condicion 1: Interseccion Rayo-Plano ---

// Calculamos el denominador (d . n)
float det = ProductoPunto(d, n)

// Si es cercano a 0, el rayo es paralelo al triangulo
Si valor_absoluto(det) < EPSILON:
    Retornar {Falso, Nulo}

// Calculamos t usando la formula derivada: t = ((v0 - o) . n) / det
Vector3 origen_a_v0 = v0 - o
float t = ProductoPunto(origen_a_v0, n) / det

// Verificamos que la interseccion esta delante de la camara (t > 0)
Si t < EPSILON:
    Retornar {Falso, Nulo}

// Calculamos el punto de interseccion en el plano
Vector3 pt = o + (d * t)

// --- Condicion 2: Punto dentro del triangulo ---
// Debemos resolver: pt - v0 = a*e1 + b*e2

Vector3 w = pt - v0 

// Calculo de productos punto para el sistema de Cramer
float uu = ProductoPunto(e1, e1)
float uv = ProductoPunto(e1, e2)
float vv = ProductoPunto(e2, e2)
float wu = ProductoPunto(w, e1)
float wv = ProductoPunto(w, e2)

// Denominador del sistema (determinante)
float denominador = (uu * vv) - (uv * uv)

// Si denominador es 0, el triangulo es degenerado (linea o punto)
Si valor_absoluto(denominador) < EPSILON:
    Retornar {Falso, Nulo}

// Calculo de coordenadas baricentricas a y b
float a = ((wu * vv) - (wv * uv)) / denominador
float b = ((uu * wv) - (wu * uv)) / denominador

// Verificacion final de limites baricentricos
// 0 <= a, 0 <= b, a + b <= 1
Si (a >= 0.0) Y (b >= 0.0) Y (a + b <= 1.0):
    Retornar {Verdadero, pt}
Sino:
    Retornar {Falso, Nulo}
