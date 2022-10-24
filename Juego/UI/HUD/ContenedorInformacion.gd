#ContenedorInformacion
class_name ContenedorInformacion
extends NinePatchRect

## Atributos Export
export var auto_ocultar:bool = false setget set_auto_ocultar

## Atributos Onready
onready var animacion:AnimationPlayer = $AnimationPlayer
onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer

## Setters y Getters
func set_auto_ocultar(valor:bool) -> void:
	auto_ocultar = valor

## Metodos Custom
func mostrar() -> void:
	animacion.play("mostrar")

func ocultar() -> void:
	animacion.play("ocultar")

func mostrar_suavisado() -> void:
	animacion.play("mostar_suavisado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavisado() -> void:
	animacion.play("ocultar_suavisado")

func modificar_texto(text: String) -> void:
	texto_contenedor.text = text

func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavisado()
