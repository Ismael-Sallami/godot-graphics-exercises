extends Node 
y
# Transformación identidad auxiliar para facilitar la lectura del código
var tr_identidad := Transform2D()

# Variables para almacenar las mallas generadas
var cuadrado: ArrayMesh
var triangulo: ArrayMesh
var casa: ArrayMesh
var circunferencia: ArrayMesh


# ===========================
# FUNCIÓN: _inicializar_meshes
# Propósito: Construye las geometrías básicas (primitivas) que se reutilizarán.
# Se ejecuta una sola vez al inicio para optimizar memoria.
# ===========================
func _inicializar_meshes():
	# Definición del Cuadrado (Unitario)
	cuadrado = CrearArrayMesh(PackedVector2Array([
		Vector2(0.0, 0.0), Vector2(1.0, 0.0),
		Vector2(1.0, 1.0), Vector2(0.0, 1.0),
		Vector2(0.0, 0.0)
	]))
	
	# Definición del Triángulo
	triangulo = CrearArrayMesh(PackedVector2Array([
		Vector2(0.0, 0.0), Vector2(1.0, 0.0), Vector2(0.0, 1.0),
		Vector2(0.0, 0.0)
	]))
	
	# Definición de la Casa (Polígono irregular)
	casa = CrearArrayMesh(PackedVector2Array([
		Vector2(0.0, 0.0), Vector2(1.0, 0.0),
		Vector2(1.0, 1.0), Vector2(0.5, 1.4), Vector2(0.0, 1.0),
		Vector2(0.0, 0.0)
	]))
	
	# Definición de la Circunferencia (64 segmentos)
	circunferencia = CrearCircunferencia(64)


# ===========================
# FUNCIONES AUXILIARES: GENERACIÓN DE GEOMETRÍA
# ===========================

# ===========================
# Función: CrearArrayMesh
# Descripción: Crea un objeto ArrayMesh a partir de un array de vectores.
# Usa la primitiva PRIMITIVE_LINE_STRIP (polilínea abierta).
# Parámetros: v (PackedVector2Array) - Lista de vértices.
# Retorno: ArrayMesh configurado.
# ===========================
func CrearArrayMesh(v: PackedVector2Array) -> ArrayMesh:
	var tablas: Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = v
	var am: ArrayMesh = ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, tablas)
	return am

# ===========================
# Función: CrearCircunferencia
# Descripción: Genera una malla circular aproximada por segmentos de línea.
# Parámetros: n (int) - Número de segmentos (resolución).
# Retorno: ArrayMesh con la forma de la circunferencia.
# ===========================
func CrearCircunferencia(n: int) -> ArrayMesh:
	var v := PackedVector2Array()
	for i in range(n + 1):
		var a: float = (float(i) * 2.0 * PI) / float(n)
		v.append(Vector2(cos(a), sin(a)))
	return CrearArrayMesh(v)


# ===========================
# FUNCIONES AUXILIARES: INSTANCIACIÓN Y TRANSFORMACIÓN DE NODOS
# ===========================

# ===========================
# Función: CrearMeshInstance2D
# Descripción: Crea un nodo visual (MeshInstance2D) asignándole una malla y una
# transformación inicial. Asigna un color azul por defecto (modulate).
# Parámetros: 
#   - am: La malla (ArrayMesh) a visualizar.
#   - tr: La transformación (Transform2D) a aplicar.
# Retorno: MeshInstance2D listo para añadir al árbol.
# ===========================
func CrearMeshInstance2D(am: ArrayMesh, tr: Transform2D) -> MeshInstance2D:
	var mi := MeshInstance2D.new()
	mi.transform = tr
	mi.modulate = Color(0.0, 0.0, 0.7) ## Azul estándar
	mi.mesh = am
	return mi

# ===========================
# Función: TransformaNode2D
# Descripción: Aplica una transformación adicional a un nodo existente.
# Realiza una composición por la izquierda (tr * n.transform).
# Parámetros:
#   - n: El nodo a transformar.
#   - tr: La matriz de transformación a aplicar.
# Retorno: El mismo nodo 'n' modificado.
# ===========================
func TransformaNode2D(n: Node2D, tr: Transform2D) -> Node2D:
	n.transform = tr * n.transform
	return n


# ===========================
# CONSTRUCCIÓN DEL MODELO JERÁRQUICO (ÁRBOL 2D)
# Funciones que construyen las partes compuestas del objeto "Casa".
# ===========================

# ===========================
# Componente: Pomo
# Descripción: Crea el pomo de la puerta usando la circunferencia escalada y trasladada.
# ===========================
func Pomo() -> Node2D:
	var tra = Transform2D().translated(Vector2(0.1, 0.5))
	var esc = Transform2D().scaled(Vector2(0.06, 0.06))
	return CrearMeshInstance2D(circunferencia, tra * esc)

# ===========================
# Componente: HojaDer (Hoja Derecha)
# Descripción: Crea una hoja de puerta compuesta por un cuadrado y un pomo.
# ===========================
func HojaDer() -> Node2D:
	var tra = Transform2D().translated(Vector2(0.5, 0.0))
	var esc = Transform2D().scaled(Vector2(0.5, 1.0))
	var n = Node2D.new()
	# Añade el pomo transformado
	n.add_child(TransformaNode2D(Pomo(), tra))
	# Añade la base de la hoja (cuadrado transformado)
	n.add_child(CrearMeshInstance2D(cuadrado, tra * esc))
	return n

# ===========================
# Componente: Puerta
# Descripción: Crea una puerta doble compuesta por una hoja normal y otra reflejada.
# ===========================
func Puerta() -> Node2D:
	var tra = Transform2D().translated(Vector2(1.0, 0.0))
	var esc = Transform2D().scaled(Vector2(-1.0, 1.0)) # Escalado negativo para reflejar
	var n = Node2D.new()
	n.add_child(HojaDer()) # Hoja derecha original
	n.add_child(TransformaNode2D(HojaDer(), tra * esc)) # Hoja izquierda (reflejada)
	return n

# ===========================
# Componente: MarcoIzq (Marco Izquierdo)
# Descripción: Parte decorativa de la ventana, compuesta por un cuadrado y un triángulo.
# ===========================
func MarcoIzq() -> Node2D:
	var tra = Transform2D().translated(Vector2(0.0, 1.0))
	var esc = Transform2D().scaled(Vector2(0.9, -0.8))
	var n = Node2D.new()
	n.add_child(CrearMeshInstance2D(cuadrado, tr_identidad))
	n.add_child(CrearMeshInstance2D(triangulo, tra * esc))
	return n

# ===========================
# Componente: Marcos
# Descripción: Conjunto de marcos para la ventana (izquierdo y derecho reflejado).
# ===========================
func Marcos() -> Node2D:
	var esc1 = Transform2D().scaled(Vector2(0.8, 1.0))
	var tra = Transform2D().translated(Vector2(2.4, 0.0))
	var esc2 = Transform2D().scaled(Vector2(-1.0, 1.0))
	var n = Node2D.new()
	n.add_child(TransformaNode2D(MarcoIzq(), esc1))
	n.add_child(TransformaNode2D(MarcoIzq(), esc1 * tra * esc2))
	return n

# ===========================
# Componente: Ventana
# Descripción: Crea una ventana completa con fondo (cuadrado) y marcos interiores.
# ===========================
func Ventana() -> Node2D:
	var tra = Transform2D().translated(Vector2(0.1, 0.1))
	var esc = Transform2D().scaled(Vector2(0.4, 0.8))
	var n = Node2D.new()
	n.add_child(CrearMeshInstance2D(cuadrado, tr_identidad))
	n.add_child(TransformaNode2D(Marcos(), tra * esc))
	return n

# ===========================
# Componente: InstPuerta (Instancia de Puerta)
# Descripción: Instancia la puerta completa en su posición final relativa a la fachada.
# ===========================
func InstPuerta() -> Node2D:
	var tra = Transform2D().translated(Vector2(0.56, 0.0))
	var esc = Transform2D().scaled(Vector2(0.3, 0.43))
	var n = Node2D.new()
	n.add_child(TransformaNode2D(Puerta(), tra * esc))
	return n

# ===========================
# Componente: InstVentana (Instancia de Ventana)
# Descripción: Prepara una instancia de ventana con una escala base.
# ===========================
func InstVentana() -> Node2D:
	var esc = Transform2D().scaled(Vector2(0.3, 0.3))
	var n = Node2D.new()
	n.add_child(TransformaNode2D(Ventana(), esc))
	return n

# ===========================
# Componente Principal: Fachada
# Descripción: Raíz del modelo jerárquico. Ensambla la estructura de la casa,
# la puerta y múltiples instancias de ventanas en posiciones específicas.
# ===========================
func Fachada() -> Node2D:
	# Definición de transformaciones para posicionar elementos
	var tra1 = Transform2D().translated(Vector2(0.13, 0.13))
	var tra2 = Transform2D().translated(Vector2(0.00, 0.43))
	var tra3 = Transform2D().translated(Vector2(0.43, 0.00))
	
	var n = Node2D.new()
	
	# 1. Estructura base de la casa
	n.add_child(CrearMeshInstance2D(casa, tr_identidad))
	
	# 2. Puerta principal
	n.add_child(TransformaNode2D(InstPuerta(), tr_identidad))
	
	# 3. Ventana inferior izquierda
	n.add_child(TransformaNode2D(InstVentana(), tra1))
	
	# 4. Ventana superior izquierda (tra1 + tra2)
	n.add_child(TransformaNode2D(InstVentana(), tra1 * tra2))
	
	# 5. Ventana superior derecha (tra1 + tra2 + tra3)
	n.add_child(TransformaNode2D(InstVentana(), tra1 * tra2 * tra3))
	
	return n


# ===========================
# FUNCIONES EXTRA PARA EJERCICIOS ESPECÍFICOS
# ===========================

# ===========================
# Helper Local para Rellenos (PRIMITIVE_TRIANGLES)
# Necesario porque 'funcionesauxiliarest5.CrearArrayMesh' usa LINE_STRIP.
# ===========================

func _crear_malla_rellena(v: PackedVector2Array) -> ArrayMesh:
	var tablas: Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = v
	var am: ArrayMesh = ArrayMesh.new()
	# Aquí usamos TRIANGLES en lugar de LINE_STRIP
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas) 
	return am

# ===========================
# Helper Local para Líneas por pares (PRIMITIVE_LINES)
# Necesario para dibujar líneas discontinuas o saltando vértices.
# ===========================
func _crear_malla_lineas_pares(v: PackedVector2Array) -> ArrayMesh:
	var tablas: Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = v
	var am: ArrayMesh = ArrayMesh.new()
	# Usamos LINES en lugar de LINE_STRIP
	am.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, tablas)
	return am