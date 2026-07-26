# Extracted from the LaTeX write-up.
# Source: docs/latex/pr1-2-Resolución.tex — Problema de los cuadrados
# Caption: Script de la raíz para alternar visualización de aristas y normales
# Regenerate with: python3 tools/extract-from-latex.py

extends Node3D

# --- Variables de Estado ---
var dibujar_aristas: bool = false  # Indica si se debe mostrar el modo alambre (aristas)
var dibujar_normales_activado: bool = false  # Indica si se deben mostrar las normales
var nodos_visualizadores: Array = []  # Almacena los nodos que visualizan las normales

# --- Funciones de Godot ---

# Se ejecuta al crear el nodo. Activa la generación de wireframes en el motor.
func _init():
    RenderingServer.set_debug_generate_wireframes(true)

# Gestiona la entrada de teclado no procesada por la interfaz.
func _unhandled_key_input(event: InputEvent):
    # Solo actúa cuando la tecla se suelta para evitar repeticiones.
    if event is InputEventKey and not event.pressed:

        # --- Tecla 'W': Alterna el modo alambre ---
        if event.keycode == KEY_W:
            dibujar_aristas = not dibujar_aristas  # Cambia el estado del modo alambre
            if dibujar_aristas:
                dibujar_normales_activado = false  # Desactiva el modo normales si se activa el alambre
            _actualizar_modos_de_vista()

        # --- Tecla 'N': Alterna la visualización de normales ---
        elif event.keycode == KEY_N:
            dibujar_normales_activado = not dibujar_normales_activado  # Cambia el estado del modo normales
            if dibujar_normales_activado:
                dibujar_aristas = false  # Desactiva el modo alambre si se activan las normales
            _actualizar_modos_de_vista()

# --- Funciones de Ayuda ---

# Actualiza la vista según el estado de las variables de modo.
func _actualizar_modos_de_vista():
    var viewport = get_viewport()

    # 1. Elimina los visualizadores de normales antiguos.
    for nodo in nodos_visualizadores:
        if is_instance_valid(nodo):
            nodo.queue_free()
    nodos_visualizadores.clear()

    # 2. Activa el modo correspondiente.
    if dibujar_aristas:
        viewport.debug_draw = Viewport.DEBUG_DRAW_WIREFRAME  # Activa el modo alambre
        print("Dibujar en modo aristas: activado")
    elif dibujar_normales_activado:
        viewport.debug_draw = Viewport.DEBUG_DRAW_DISABLED  # Desactiva el modo alambre
        print("Mostrando normales...")
        _buscar_y_crear_visualizadores(get_tree().root)  # Busca y crea visualizadores de normales
    else:
        viewport.debug_draw = Viewport.DEBUG_DRAW_DISABLED  # Desactiva todos los modos de depuración
        print("Modos de depuración: desactivados")

# Busca recursivamente en la escena todos los nodos de malla visibles y les crea un visualizador de normales.
func _buscar_y_crear_visualizadores(nodo_actual: Node):
    # Si el nodo es una malla visible, crea su visualizador de normales.
    if nodo_actual is MeshInstance3D and nodo_actual.is_visible_in_tree():
        var visualizador = Utilidades.crear_visualizador_de_normales(nodo_actual)
        if is_instance_valid(visualizador):
            get_tree().root.add_child(visualizador)  # Añade el visualizador a la escena
            nodos_visualizadores.append(visualizador)  # Lo guarda para poder eliminarlo después

    # Llama recursivamente a todos los hijos del nodo actual.
    for hijo in nodo_actual.get_children():
        _buscar_y_crear_visualizadores(hijo)
