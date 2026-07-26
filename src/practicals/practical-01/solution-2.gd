# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios_adicionales.tex — Práctica 1
# Regenerate with: python3 tools/extract-from-latex.py

extends MeshInstance3D

@export var n: int = 8

func _ready():
    if n < 3:
        n = 3
        print("El polígono debe tener al menos 3 lados. Usando n=3.")
    var new_mesh = poligono_regular(n)
    self.mesh = new_mesh
    var material = StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
    self.material_override = material

func poligono_regular(p_n: int) -> ArrayMesh:
    var vertices = PackedVector3Array()
    var colors = PackedColorArray()
    var indices = PackedInt32Array()
    var centro = Vector3(0.5, 0.5, 0)
    vertices.push_back(centro)
    colors.push_back(Color.WHITE)
    var radio = 0.5
    for i in range(p_n):
        var angulo = (float(i) / float(p_n)) * TAU
        var x = centro.x + radio * cos(angulo)
        var y = centro.y + radio * sin(angulo)
        var z = 0.0
        vertices.push_back(Vector3(x, y, z))
        colors.push_back(Color(x, y, z))
    for i in range(p_n):
        var idx_centro = 0
        var idx_v1 = i + 1
        var idx_v2 = (i + 1) % p_n + 1
        indices.push_back(idx_centro)
        indices.push_back(idx_v1)
        indices.push_back(idx_v2)
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arrays[ArrayMesh.ARRAY_COLOR] = colors
    arrays[ArrayMesh.ARRAY_INDEX] = indices
    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    return mesh
