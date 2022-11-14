#PantallaFinal.gd
extends Node

## Atributos Export
export(String, FILE, "*.tscn") var nivel_inicial = ""
export(String, FILE, "*.tscn") var menu_principal = ""

## Metodos
func _ready() -> void:
	OS.set_window_fullscreen(true)
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)

## Señales Internas
func _on_BotonJugar_pressed() -> void:
	MusicaJuego.play_boton()
	get_tree().change_scene(nivel_inicial)

func _on_BotonSalir_pressed():
	MusicaJuego.play_boton()
	get_tree().quit()

func _on_BotonVolver_pressed():
	get_tree().change_scene(menu_principal)
