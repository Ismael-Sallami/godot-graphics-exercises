# Script de Godot para asignar a un nodo de tipo 'Node2D' 
# de forma que se visualizan los ejes, con fondo blanco, la 
# vista 2D es controlable con el ratón.
# Fija la vista para que inicialmente la región visible incluya a 
# un cuadrado de lado 2 y centro en el origen ( [-1,-1] .. [+1,+1] )

extends Node2D

# -------------------------------
# tamaños del viewport guardados

var viewport_tamano_dcc_int  : Vector2i = Vector2i( 0, 0 ) # tamaño actual del area de dibujo en pixels (dcc)
var viewport_tamano_dcc      : Vector2 = Vector2( 0, 0 )

var vp : Viewport = null 

# -------------------------------
# Definición de la vista (transf. de vista, desde WCC a DC)

const ejeX := Vector2( 1.0, 0.0 )
const ejeY := Vector2( 0.0, 1.0 )

var tp  : float = 1.0 # tamaño (== alto, ancho) de un pixel en coords de mundo (WCC)
var cvp : Vector2 = Vector2( 0, 0 ) # centro del viewport en coordenadas de mundo (WCC)
var fev : float = 1.0 # factor de escalado de la vista, se controla con la rueda del ratón

# --------------------------
# Estado de arrastre del ratón

var raton_izq_pulsado : bool = false 

# -------------------------------
# Actualiza la transformación de vista en función del tamaño del área de dibujo

var c : int = 0

func _actualiza_transf_vista(  ) -> void : 

	tp = 2.0/(fev*min( vp.size.x, vp.size.y )) 
	var t1 := Transform2D( ejeX, ejeY, -cvp )
	var t2 := Transform2D( ejeX/tp, -ejeY/tp, cvp+0.5*vp.size )	
	transform = t2*t1
	
# --------------------------
# Procesar evento de entrada.
# Se usa por ahora únicamente para controlar la vista 2d con el ratón

func _unhandled_input( event : InputEvent ):
	
	var actualizada : bool = false
	
	if event is InputEventMouseButton:	
		if event.button_index == MOUSE_BUTTON_LEFT:
			raton_izq_pulsado = event.pressed
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fev *= 1.05
			actualizada = true
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fev /= 1.05
			actualizada = true 
			
	elif event is InputEventMouseMotion and raton_izq_pulsado:
		cvp += tp * Vector2( -event.relative.x, +event.relative.y ) 
		actualizada = true 
		
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_released():
			get_tree().quit()

	if actualizada:
		_actualiza_transf_vista(   )
		
# ----------------------------------------------
# crear objetos para los ejes y añadirlos como hijos

func _crear_ejes_2d() :
	
	const w2 : float = 0.01  # mitad del ancho de la barra (en X)
	const f  : float = 2.5  # ancho de la flecha en X relativo al ancho de la barra
	const l : float = 0.9   # longitud de la flecha en Y (entre 0 y 1), resto hasta 1 es el triangulo.
	
	# crear tablas para una barra (indexado) y un triángulo
	var t_barra : Array = [] ; t_barra.resize( Mesh.ARRAY_MAX )
	t_barra[ Mesh.ARRAY_VERTEX ] = PackedVector2Array([ 
		Vector2(-w2,-w2/2.0), Vector2(w2,-w2/2.0), Vector2(-w2,l), Vector2(w2,l)
	])
	t_barra[ Mesh.ARRAY_INDEX ] = PackedInt32Array([ 0,1,2, 2,1,3 ])
	
	var t_tri : Array = [] ; t_tri.resize( Mesh.ARRAY_MAX )
	t_tri[ Mesh.ARRAY_VERTEX ] = PackedVector2Array([ 
		Vector2(-w2*f,l), Vector2(w2*f,l), Vector2(0,1)
	])
	
	# crear un arrayMesh y añadir las dos surfaces
	var am := ArrayMesh.new() 
	am.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES, t_barra ) 
	am.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES, t_tri ) 
	
	# crear mesh instances, para ej X (rojo) y para eje Y (verde)
	var ex := MeshInstance2D.new(); ex.mesh = am; ex.rotate( -PI/2.0 )
	var ey := MeshInstance2D.new(); ey.mesh = am
	ex.modulate = Color(1,0,0)
	ey.modulate = Color(0,1,0)
	
	# crear lineas en el eje X y en el Y
	var lex := Line2D.new() 
	lex.points = PackedVector2Array([ Vector2(-1000,0), Vector2(1000,0) ])
	lex.width = w2*0.75
	lex.default_color = Color(1,0,0)
	lex.antialiased = true 
	
	var ley := Line2D.new() 
	ley.points = PackedVector2Array([ Vector2(0,-1000), Vector2(0,1000) ])
	ley.width = w2*0.75
	ley.default_color = Color(0,1,0)
	ley.antialiased = true 
	
	# añadir eje X e Y a un nuevo nodo 2D 
	var ejes := Node2D.new() 
	ejes.add_child( ex ) ; ejes.add_child( lex )
	ejes.add_child( ey ) ; ejes.add_child( ley )
	ejes.z_index = RenderingServer.CANVAS_ITEM_Z_MIN  # ponerlo detrás de todo
	
	# poner ejes como hijo de este:
	add_child( ejes )
	
	
# inicialización 
	
func _ready() -> void:	
	
	_crear_ejes_2d()
	RenderingServer.set_default_clear_color( Color( 1.0, 1.0, 1.0 ))
	
	# actualizar el viewport ('vp') y la vista.
	vp = get_viewport() ; assert( vp is Viewport )
	_actualiza_transf_vista()
	vp.connect( "size_changed", _actualiza_transf_vista )