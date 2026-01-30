# Problema 2.2:
# Crea otro Node2D, y asígnale un script para
# visualizar el mismo polígono regular que antes
# (también con una malla no indexada), solo que
# ahora debes asignar colores a los vértices para
# que los triángulos aparezcan con una gradua7
# ción en tonos de gris como en la figura. Cada
# triángulo que forma el polígono regular será
# blanco en el vértice del centro, gris claro en
# otro y gris oscuro en el tercero.
# Responde razonadamente a esta cuestión:
# ¿ cuantos vértices debe tener la tabla de vér7
# tices ?

extends MeshInstance2D

const n: int = 8
const r: float = 0.8 

func _ready():
    # 1. Creamos arrays para vértices Y para colores
    var vertices = PackedVector2Array()
    var colors = PackedColorArray()
    
    var center_pos = Vector2(0, 0)
    var angle_step = TAU / n
    
    # Definimos los colores según pide el enunciado [cite: 2422]
    var c_center = Color(1.0, 1.0, 1.0) # Blanco (Centro)
    var c_light = Color(0.8, 0.8, 0.8)  # Gris Claro (Vértice 1)
    var c_dark = Color(0.2, 0.2, 0.2)   # Gris Oscuro (Vértice 2)
    
    for i in range(n):
        var angle1 = i * angle_step
        var angle2 = (i + 1) * angle_step
        
        # Calculamos posiciones del borde
        var p1 = Vector2(r * cos(angle1), r * sin(angle1))
        var p2 = Vector2(r * cos(angle2), r * sin(angle2))
        
        # --- AÑADIMOS VÉRTICES (Topología Triángulos) ---
        vertices.push_back(center_pos)
        vertices.push_back(p1)
        vertices.push_back(p2)
        
        # --- AÑADIMOS COLORES (En el mismo orden estricto) ---
        colors.push_back(c_center)
        colors.push_back(c_light)
        colors.push_back(c_dark)
        
    # 2. Preparamos las tablas (SOA - Structure of Arrays)
    var tablas = []
    tablas.resize(Mesh.ARRAY_MAX)
    tablas[Mesh.ARRAY_VERTEX] = ver
    
    # 3. Generamos la malla
    mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
    
    # NOTA: Ya no usamos 'modulate' porque los colores vienen dentro de la malla.