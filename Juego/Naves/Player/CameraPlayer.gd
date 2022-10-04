#CamaraPlayer.gd
class_name CamaraPlayer
extends CamaraJuego

## Atributos Export
export var variacion_zoom:float = 0.1
export var zoom_minimo:float = 0.5
export var zoom_maximo:float = 2.0

## Metodos
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_acercar"):
		controlar_zoom(-variacion_zoom)
	elif event.is_action_pressed("zoom_alejar"):
		controlar_zoom(variacion_zoom)

## Metodos Custom
func controlar_zoom(mod_zoom:float) -> void:
	var zoom_x = clamp(zoom.x + mod_zoom, zoom_minimo, zoom_maximo)
	var zoom_y = clamp(zoom.y + mod_zoom, zoom_minimo, zoom_maximo)
	zoom_suavizado(zoom_x, zoom_y, 0.15)
