#EstacionRecarga
class_name EstacionRecarga
extends Node2D

## Atributos Export
export var energia:float = 6.0
export var radio_energia_entregada:float = 0.5

## Atributos
var nave_player:Player = null
var player_en_zona:bool = false

## Atributos Onready
onready var carga_sfx:AudioStreamPlayer = $CargaSFX
onready var vacio_sfx:AudioStreamPlayer = $VacioSFX

## Metodos
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	controlar_enegia()
	if event.is_action_pressed("recargar_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action_pressed("recargar_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)

## Metodos Custom
func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action("recargar_escudo") or event.is_action("recargar_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
			carga_sfx.play()
		return true
	return false

func controlar_enegia() -> void:
	energia -= radio_energia_entregada
	if energia <= 0.0:
		vacio_sfx.play()

## Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_AreaAtraccion_body_entered(body: Node) -> void:
	player_en_zona = true
	if body is Player:
		nave_player = body

func _on_AreaAtraccion_body_exited(body: Node) -> void:
	player_en_zona = false
