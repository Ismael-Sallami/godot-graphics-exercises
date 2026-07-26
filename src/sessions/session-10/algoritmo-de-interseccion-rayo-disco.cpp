// Extracted from the LaTeX write-up.
// Source: docs/latex/ejercicios-parte2.tex — Sesión 10
// Caption: Algoritmo de Intersección Rayo-Disco
// Regenerate with: python3 tools/extract-from-latex.py

// Estructuras de datos:
// Vec3: tupla (x, y, z) con operaciones de suma, resta y producto punto
// Rayo: origen (Vec3), direccion (Vec3)
// Disco: centro (Vec3), normal (Vec3), radio (float)

bool IntersectaDisco(Rayo ray, Disco disco, float &t_salida) {
    // 1. Calcular el denominador (producto punto entre normal y direccion)
    float denom = dot(disco.normal, ray.direccion);


    // Si denom es cercano a 0, el rayo es paralelo al plano
    if (abs(denom) < 1e-6) {
        return false; 
    }

    // 2. Calcular el vector desde el origen del rayo al centro del disco
    Vec3 vector_origen_centro = disco.centro - ray.origen;

    // 3. Calcular t
    float t = dot(vector_origen_centro, disco.normal) / denom;

    // Verificar si la interseccion esta detras de la camara
    if (t < 0) {
        return false;
    }

    // 4. Calcular el punto exacto de interseccion en el plano
    Vec3 p = ray.origen + (ray.direccion * t);

    // 5. Verificar si el punto esta dentro del radio del disco
    Vec3 v = p - disco.centro;
    float dist_cuadrada = dot(v, v); // |v|^2

    if (dist_cuadrada <= (disco.radio * disco.radio)) {
        t_salida = t; // Guardamos la distancia a la colision
        return true;  // Hay interseccion valida
    }

    return false; // Intersecta el plano, pero fuera del disco



}
