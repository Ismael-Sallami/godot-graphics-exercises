// Extracted from the LaTeX write-up.
// Source: docs/latex/ejercicios-parte2.tex — Sesión 10
// Caption: Algoritmo de Intersección Rayo-Esfera
// Regenerate with: python3 tools/extract-from-latex.py

// Estructuras auxiliares
struct Rayo { Vec3 origen; Vec3 direccion; }; // direccion normalizada
struct Esfera { Vec3 centro; float radio; };

// Algoritmo Base: Interseccion con Esfera Unitaria en (0,0,0)
// Retorna true si hay colision, y guarda la distancia en t_out
bool IntersectaEsferaUnidad(Vec3 o, Vec3 d, float &t_out) {
    // Coeficientes de la ecuacion t^2 + Bt + C = 0
    // A es 1 porque d esta normalizado
    float B = 2.0f * dot(o, d);
    float C = dot(o, o) - 1.0f;

    float discriminante = (B * B) - (4.0f * C);

    if (discriminante < 0.0f) return false; // No hay interseccion

    float raiz = sqrt(discriminante);

    // Soluciones de la ecuacion
    float t0 = (-B - raiz) / 2.0f; // Entrada (mas cercana)
    float t1 = (-B + raiz) / 2.0f; // Salida (mas lejana)

    // Verificar orden y positividad para encontrar la primera valida
    if (t0 > 0.001f) { 
        t_out = t0; 
        return true; 
    }
    if (t1 > 0.001f) { 
        t_out = t1; 
        return true; // El origen esta dentro de la esfera
    }

    return false; // Ambas intersecciones estan detras del rayo
}

// Algoritmo General: Reduccion al caso unitario
bool IntersectaEsferaGenerica(Rayo ray, Esfera esf, float &t_real) {
    // 1. Transformar el origen del rayo al espacio de la esfera unitaria
    // Se traslada el mundo para que el centro sea (0,0,0) y se escala por 1/R
    Vec3 o_prima = (ray.origen - esf.centro) / esf.radio;

    // La direccion d no se escala para mantener la coherencia geometrica
    // del rayo, pero esto implica que el 't' resultante estara escalado.

    float t_unit;
    if (IntersectaEsferaUnidad(o_prima, ray.direccion, t_unit)) {
        // 2. Escalar la distancia resultante para volver al mundo real
        t_real = t_unit * esf.radio;
        return true;
    }

    return false;
}
