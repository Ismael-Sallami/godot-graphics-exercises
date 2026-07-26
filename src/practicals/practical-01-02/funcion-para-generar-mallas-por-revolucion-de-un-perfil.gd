# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — Creación de mallas por revolución de un perfil
# Caption: Función para generar mallas por revolución de un perfil
# Regenerate with: python3 tools/extract-from-latex.py

# Archivo: revolucion_utils.gd
extends Node

const PI = 3.14159265359 # Se usa la constante PI

## Genera una malla indexada por revolución alrededor del eje Y.
## El perfil se asume en el plano X-Y (Vector2(x, y) -> Vector3(x, y, 0)).
func generar_malla_revolucion(
    perfil: PackedVector2Array, 
    num_copias: int, 
    vertices: PackedVector3Array, 
    triangulos: PackedInt32Array
) -> void:

    var num_puntos_perfil = perfil.size()
    if num_puntos_perfil < 2 or num_copias < 3:
        # Se requiere al menos 2 puntos en el perfil y 3 copias para la revolución
        return

    var angulo_paso = 2.0 * PI / float(num_copias)

    # 1. Generación de Vértices
    for i in range(num_copias):
        var angulo = float(i) * angulo_paso
        var cos_a = cos(angulo)
        var sin_a = sin(angulo)

        for j in range(num_puntos_perfil):
            var p2 = perfil[j]
            var x = p2.x
            var y = p2.y

            # Rotación del perfil (x, y, 0) sobre el eje Y
            var x_rot = x * cos_a
            var z_rot = x * sin_a # Rotación en el plano XZ

            # Coordenada Y (altura) permanece igual
            var nuevo_vertice = Vector3(x_rot, y, z_rot)
            # Se añaden vértices al array de salida
            vertices.append(nuevo_vertice) 

    # 2. Generación de Triángulos (Índices)
    # Se crean cuadriláteros (quads) y cada uno se divide en dos triángulos.
    for i in range(num_copias):
        # El índice 'siguiente_i' conecta el último segmento con el primero (cierre completo)
        var siguiente_i = (i + 1) % num_copias 

        for j in range(num_puntos_perfil - 1):
            # Índices en la capa actual (i) y la siguiente (i+1)
            var i0 = i * num_puntos_perfil + j           # Vértice A (i, j)
            var i1 = siguiente_i * num_puntos_perfil + j  # Vértice B (i+1, j)
            var i2 = siguiente_i * num_puntos_perfil + j + 1 # Vértice C (i+1, j+1)
            var i3 = i * num_puntos_perfil + j + 1           # Vértice D (i, j+1)

            # Triángulo 1: (A, B, D) 
            triangulos.append(i0)
            triangulos.append(i1)
            triangulos.append(i3)

            # Triángulo 2: (B, C, D)
            triangulos.append(i1)
            triangulos.append(i2)
            triangulos.append(i3)
