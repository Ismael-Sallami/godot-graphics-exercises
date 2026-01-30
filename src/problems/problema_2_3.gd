extends MeshInstance2D
const n: int = 8
const r: float = 0.8 
const activate_2_1: bool = true

func _ready():
    if activate_2_1:
        var vertices = PackedVector2Array()
        var indices = PackedInt32Array()
        
        var center = Vector2(0, 0)
        var angle_step = TAU / n
        
        # --- 1. GENERACIÓN DE VÉRTICES (TABLA DE VÉRTICES) ---
        # Añadimos el centro (Índice 0)
        vertices.push_back(center)
        
        # Añadimos los puntos del perímetro (Índices 1 a n)
        for i in range(n):
            var angle = i * angle_step
            var p = Vector2(cos(angle), sin(angle)) * r
            vertices.push_back(p)
            
        # --- 2. GENERACIÓN DE ÍNDICES (TABLA DE TRIÁNGULOS) ---
        # Conectamos los vértices ya existentes
        for i in range(n):
            # El centro siempre es el índice 0
            var idx_center = 0
            
            # Vértice actual del perímetro (empiezan en el índice 1)
            var idx_current = i + 1
            
            # Siguiente vértice. Usamos módulo (%) para cerrar el círculo
            # (Si estamos en el último, el siguiente debe ser el 1)
            var idx_next = (i + 1) % n + 1
            
            # Definimos el triángulo
            indices.push_back(idx_center)
            indices.push_back(idx_current)
            indices.push_back(idx_next)

        # --- 3. CREACIÓN DE LA MALLA ---
        var tablas = []
        tablas.resize(Mesh.ARRAY_MAX)
        tablas[Mesh.ARRAY_VERTEX] = vertices
        tablas[Mesh.ARRAY_INDEX] = indices # ¡Ahora usamos índices!
        
        mesh = ArrayMesh.new()
        mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
        
        # Color plano para toda la malla
        modulate = Color(1.0, 0.7, 0.0)
    else:
        var vertices = PackedVector2Array()
        var colors = PackedColorArray()
        var indices = PackedInt32Array()
        
        var angle_step = TAU / n
        
        # Colores definidos
        var c_center = Color(1.0, 1.0, 1.0) # Blanco
        var c_light = Color(0.8, 0.8, 0.8)  # Gris Claro (Inicio arco)
        var c_dark = Color(0.2, 0.2, 0.2)   # Gris Oscuro (Fin arco)
        
        # --- 1. VÉRTICES Y COLORES ---
        
        # Vértice 0: El Centro (Compartido por todos)
        vertices.push_back(Vector2(0,0))
        colors.push_back(c_center)
        
        # Vértices del perímetro (No se pueden compartir entre triángulos vecinos)
        for i in range(n):
            var angle1 = i * angle_step
            var angle2 = (i + 1) * angle_step
            
            var p1 = Vector2(cos(angle1), sin(angle1)) * r
            var p2 = Vector2(cos(angle2), sin(angle2)) * r
            
            # Para cada triángulo, añadimos sus dos vértices del borde específicos
            vertices.push_back(p1) # Vértice 'Light' de este triángulo
            colors.push_back(c_light)
            
            vertices.push_back(p2) # Vértice 'Dark' de este triángulo
            colors.push_back(c_dark)
            
        # --- 2. ÍNDICES ---
        for i in range(n):
            # El centro siempre es 0
            # Los vértices del perímetro están agrupados de 2 en 2 a partir del índice 1
            # Triángulo 0 usa índices: 1 y 2
            # Triángulo 1 usa índices: 3 y 4...
            var base_idx = 1 + (i * 2)
            
            indices.push_back(0)        # Centro
            indices.push_back(base_idx) # Light
            indices.push_back(base_idx + 1) # Dark

        # --- 3. MALLA ---
        var tablas = []
        tablas.resize(Mesh.ARRAY_MAX)
        tablas[Mesh.ARRAY_VERTEX] = vertices
        tablas[Mesh.ARRAY_COLOR] = colors
        tablas[Mesh.ARRAY_INDEX] = indices
        
        mesh = ArrayMesh.new()
        mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)