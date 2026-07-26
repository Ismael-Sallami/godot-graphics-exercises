# Extracted from the LaTeX write-up.
# Source: docs/latex/ejercicios-parte2.tex — Sesión 9
# Regenerate with: python3 tools/extract-from-latex.py

extends Node

# Variable para almacenar el tiempo acumulado en segundos

var tiempo_acumulado: float = 0.0

# Bandera para controlar el estado de la tecla (si se está manteniendo pulsada)

var tecla_esta_pulsada: bool = false

func _process(delta: float) -> void:
# Verificamos si la tecla P está siendo presionada en este frame
if Input.is_key_pressed(KEY_P):
# Marcamos que la tecla está activa
tecla_esta_pulsada = true

    # Acumulamos el tiempo transcurrido desde el último frame
    tiempo_acumulado += delta

else:
    # Si la tecla NO está pulsada, verificamos si lo estaba en el frame anterior
    # Esto indica el evento ''Just Released'' (Acaba de soltarse)
    if tecla_esta_pulsada:

        # Verificamos la condición del enunciado: 
        # ''permanecido pulsada al menos el tiempo de un frame''
        # Si tiempo_acumulado > 0, significa que al menos un frame sumó delta.
        if tiempo_acumulado > 0.0:
            print(''La tecla P se mantuvo pulsada durante: '', 
                  tiempo_acumulado, '' segundos.'')

        # Reiniciamos el estado para la próxima pulsación
        tiempo_acumulado = 0.0
        tecla_esta_pulsada = false
