// Extracted from the LaTeX write-up.
// Source: docs/latex/ejercicios-parte2.tex — Sesión 10
// Caption: Algoritmo Genérico para Cuádricas Acotadas
// Regenerate with: python3 tools/extract-from-latex.py

// TipoObjeto: CILINDRO o CONO
bool IntersectaCuadrica(Rayo ray, TipoObjeto tipo, float &t_out) {
    float A, B, C;
    float ox = ray.origen.x, oz = ray.origen.z, oy = ray.origen.y;
    float dx = ray.direccion.x, dz = ray.direccion.z, dy = ray.direccion.y;
    if (tipo == CILINDRO) {
        // x^2 + z^2 - 1 = 0
        A = dx*dx + dz*dz;
        B = 2*(ox*dx + oz*dz);
        C = ox*ox + oz*oz - 1;
    } else { // CONO
        // x^2 + z^2 - y^2 = 0
        A = dx*dx + dz*dz - dy*dy;
        B = 2*(ox*dx + oz*dz - oy*dy);
        C = ox*ox + oz*oz - oy*oy;
    }

    float discrim = B*B - 4*A*C;
    if (discrim < 0) return false; // No hay interseccion con la superficie infinita

    float raiz = sqrt(discrim);
    float t0 = (-B - raiz) / (2*A);
    float t1 = (-B + raiz) / (2*A);

    // Buscar la interseccion mas cercana que este dentro de la altura
    float t_candidata = t0;
    if (t0 < 0.001) t_candidata = t1;
    if (t_candidata < 0.001) return false;

    // Calcular la altura del punto de impacto
    float y_impacto = oy + t_candidata * dy;

    // VALIDACION DE ALTURA (Clipping)
    // El cilindro y el cono tienen altura 1 (de y=0 a y=1)
    if (y_impacto >= 0.0 && y_impacto <= 1.0) {
        t_out = t_candidata;
        return true;
    }

    // Si t0 falla, probamos con t1 (podria ser que entramos por arriba/abajo)
    // Nota: Esto es necesario si estamos dentro del objeto o para el ''lado lejano''
    y_impacto = oy + t1 * dy;
    if (t1 > 0.001 && y_impacto >= 0.0 && y_impacto <= 1.0) {
         t_out = t1;
         return true;
    }

    return false;
}
