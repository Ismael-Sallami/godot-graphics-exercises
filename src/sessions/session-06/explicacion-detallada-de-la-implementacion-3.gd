# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte1.tex — Sesión 6 / Explicación detallada de la implementación
# Regenerate with: python3 tools/extract-from-latex.py

extends Camera3D

# -------------
# constantes y variables de instancia 

const at   := 2.5   # angulo de rot. con teclas
const ar   := 0.5   # angulo de rot. con raton
var   bdrp := false # boton derecho del raton presionado si/no
var   dz   := 3.0   # distancia en Z de la camara al origen
var   dxy  := Vector2( 0.0, 0.0 ) # angulos hor. y vert.

# -------------
# actualiza la variable 'transform' de este nodo camara

func _actualiza_transf_vista(  ) -> void : 
    var ahr  := ((45.0+float(dxy.x))*2.0*PI)/360.0 
    var avr  := ((30.0+float(dxy.y))*2.0*PI)/360.0 
    var tras := Transform3D().translated( Vector3( 0.0, 0.0, dz))   
    var rotx := Transform3D().rotated( Vector3.RIGHT, -avr )
    var roty := Transform3D().rotated( Vector3.UP, ahr ) 
    transform = roty*rotx*tras   

# -------------
# NUEVA FUNCION: Ajuste dinamico de la proyeccion (Problema 6.6)
func _actualiza_proyeccion() -> void:
    # 1. Obtener tamano del viewport
    var vp_size := get_viewport().size

    # Evitamos division por cero si la ventana se minimiza completamente
    if vp_size.y == 0: return 

    # 2 y 3. Calcular relacion de aspecto (ancho / alto)
    var aspect_ratio := float(vp_size.x) / float(vp_size.y)

    # 4. Ajuste segun la forma de la ventana
    if aspect_ratio < 1.0:
        # Si es mas alto que ancho (Portrait), fijamos el ancho
        keep_aspect = Camera3D.KEEP_WIDTH
    else:
        # Si es mas ancho que alto (Landscape), fijamos el alto (por defecto)
        keep_aspect = Camera3D.KEEP_HEIGHT

    # Aseguramos que el FOV base sea siempre 75 grados
    fov = 75.0

# -------------
func _ready() -> void :  
    _actualiza_transf_vista() 

    # Conectamos la senal de redimensionado a nuestra nueva funcion
    get_tree().root.size_changed.connect(_actualiza_proyeccion)

    # Llamamos a la funcion una vez al inicio para configurar el estado inicial
    _actualiza_proyeccion()

# -------------
# procesa evento de entrada (sin cambios respecto al original)

func _input( event : InputEvent ): 
    var av : bool = true 

    if event is InputEventKey and event.pressed: 
        match event.keycode:
            KEY_UP:    dxy += Vector2( 0, -at )
            KEY_DOWN:  dxy += Vector2( 0, +at )
            KEY_RIGHT: dxy += Vector2( -at, 0 )
            KEY_LEFT:  dxy += Vector2( at, 0 )
            KEY_MINUS, KEY_PAGEDOWN, KEY_KP_SUBTRACT: dz *= 1.05 
            KEY_PLUS, KEY_PAGEUP, KEY_KP_ADD: dz = max( dz/1.05, 0.1 )
            _: av = false

    elif event is InputEventMouseButton: 
        match event.button_index:
            MOUSE_BUTTON_RIGHT: 
                bdrp = event.pressed 
                av = false 
            MOUSE_BUTTON_WHEEL_DOWN: dz *= 1.05
            MOUSE_BUTTON_WHEEL_UP:   dz = max( dz/1.05, 0.1 )
            _: av = false

    elif event is InputEventMouseMotion and bdrp: 
        dxy += ar * Vector2( -event.relative.x, event.relative.y ) 

    else: 
        av = false 

    if av:
        _actualiza_transf_vista( )
