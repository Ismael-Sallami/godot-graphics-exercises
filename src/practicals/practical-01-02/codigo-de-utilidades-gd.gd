# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — 
# Caption: Código de utilidades.gd
# Regenerate with: python3 tools/extract-from-latex.py

extends Node  # El script extiende la clase Node de Godot

## -----------------------------------------------------------------------------
## Función que calcula las normales promedio de los vértices de una malla,
## a partir de la tabla de posiciones de vértices y la tabla de triángulos

@export var normal_length: float = 0.6  # longitud de las líneas de las normales
@export var normal_color: Color = Color(0.967, 0.83, 0.917, 1.0)  # color de las normales

func calcNormales(verts: PackedVector3Array, tris: PackedInt32Array) -> PackedVector3Array:
    # Paso 1: comprobar precondiciones
    assert(verts.size() >= 3, "CalcNormales: la malla debe tener al menos 3 vértices")
    assert(tris.size() % 3 == 0, "CalcNormales: el número de enteros en 'tris' debe ser múltiplo de 3")

    var nv: int = verts.size()  # número de vértices
    var nt: int = tris.size() / 3  # número de triángulos

    # Paso 2: inicializa normales a cero
    var normales := PackedVector3Array([])
    for i in nv:
        normales.append(Vector3.ZERO)

    # Paso 3: sumar en cada vértice las normales de sus triángulos adyacentes
    for it in nt:
        var t := Vector3i(tris[3 * it + 0], tris[3 * it + 1], tris[3 * it + 2])
        var a := verts[t[0]]
        var b := verts[t[1]]
        var c := verts[t[2]]
        var normalv := (c - a).cross(b - a).normalized()  # calcula la normal del triángulo
        for iv in 3:
            normales[t[iv]] += normalv  # suma la normal al vértice correspondiente

    # Paso 4: normalizar normales
    for iv in nv:
        normales[iv] = normales[iv].normalized()

    # Hecho
    return normales

## -----------------------------------------------------------------------------
## Función de parametrización de un toroide (donut)
## u, v: parámetros entre 0 y 1; R: radio mayor; r: radio menor

func ParamDonut(u, v, r, R: float) -> Vector3:
    var cu := cos(2.0 * PI * u)
    var su := sin(2.0 * PI * u)
    var cv := cos(2.0 * PI * v)
    var sv := sin(2.0 * PI * v)
    return Vector3((R + r * cv) * cu, (R + r * cv) * su, r * sv)

## -----------------------------------------------------------------------------
## Genera una tabla de triángulos (índices) con topología toroidal
## nu: divisiones del primer parámetro; nv: divisiones del segundo parámetro

func GenTriToroidal(nu, nv: int, indices: PackedInt32Array):
    for i in nu:
        var isig = (i + 1) % nu
        for j in nv:
            var jsig = (j + 1) % nv
            var i00 = i * nv + j
            var i01 = i * nv + jsig
            var i10 = isig * nv + j
            var i11 = isig * nv + jsig

            indices.append(i00)
            indices.append(i11)
            indices.append(i10)
            indices.append(i00)
            indices.append(i01)
            indices.append(i11)

## -----------------------------------------------------------------------------
## Función que genera un toroide (donut) con 'nu x nv' vértices
## vertices: tabla de vértices; indices: tabla de índices

func generarDonut(vertices: PackedVector3Array, indices: PackedInt32Array,
                  nu: int = 128, nv: int = 32, R: float = 1.2, r: float = 0.4):
    # Genera vértices con la geometría de un donut
    for i in nu:
        for j in nv:
            vertices.append(ParamDonut(float(i) / nu, float(j) / nv, r, R))

    # Genera los triángulos con topología toroidal
    GenTriToroidal(nu, nv, indices)

## -----------------------------------------------------------------------------
## Función que crea y devuelve un nodo MeshInstance3D que dibuja las normales
## de una malla ya existente

func crear_visualizador_de_normales(malla_instancia: MeshInstance3D) -> MeshInstance3D:
    # Comprobar que el objeto y su malla son válidos
    if not is_instance_valid(malla_instancia) or not is_instance_valid(malla_instancia.mesh):
        return null

    var malla_original: Mesh = malla_instancia.mesh
    var transform_global: Transform3D = malla_instancia.global_transform

    # Usamos MeshDataTool para leer los datos de la malla
    var mdt = MeshDataTool.new()

    # Creamos la malla para dibujar las líneas
    var immediate_mesh = ImmediateMesh.new()
    var material = StandardMaterial3D.new()
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED  # sin sombreado
    material.albedo_color = normal_color  # color de las normales

    immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

    # Recorremos cada superficie de la malla
    for i in range(malla_original.get_surface_count()):
        mdt.clear()
        # Extraemos los datos de la superficie
        if mdt.create_from_surface(malla_original, i) == OK:
            # Recorremos cada vértice para dibujar su normal
            for v_idx in range(mdt.get_vertex_count()):
                var vertice = mdt.get_vertex(v_idx)
                var normal = mdt.get_vertex_normal(v_idx)
                immediate_mesh.surface_add_vertex(vertice)  # inicio de la línea
                immediate_mesh.surface_add_vertex(vertice + normal * normal_length)  # fin de la línea

    immediate_mesh.surface_end()

    # Creamos el nodo que contendrá las líneas
    var visualizador = MeshInstance3D.new()
    visualizador.mesh = immediate_mesh
    visualizador.name = "VisualizadorNormales_" + malla_instancia.name

    # Colocamos el visualizador en la misma posición y rotación que el objeto original
    visualizador.global_transform = transform_global

    return visualizador
