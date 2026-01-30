# Problema 3.12:
# Crea un script global (autoload) con una función
# llamada gancho (sin parámetros) que crea y
# devuelve un objeto de la clase Mesh con una
# polilínea azul como la de la figura (los ejes se han
# dibujado por claridad).
# Crea en tu proyecto un nodo 2D de tipo
# MeshInstance2D y en _ready asígnale como
# malla (propiedad mesh) el objeto resultado de
# llamar a gancho(), ponle un color azul (propie7
# dad modulate) y verifica que el gancho aparece
# en pantalla al ejecutar el proyecto.
extends MeshInstance2D

func _ready():
    self.mesh = Global.gancho()
    self.modulate = Color(0,0,1)