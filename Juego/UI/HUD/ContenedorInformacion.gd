#ContenedorInformacion.gd
class_name ContenedorInformacion
extends NinePatchRect

## Atributos Export
export var auto_ocultar:bool = false setget set_auto_ocultar

## Atributos
var esta_activo:bool = true setget set_esta_activo

## Atributos Onready
onready var animacion:AnimationPlayer = $AnimationPlayer
onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer

## Setters y Getters
func set_auto_ocultar(valor:bool) -> void:
	auto_ocultar = valor

func set_esta_activo(valor:bool) -> void:
	esta_activo = valor

## Metodos Custom
func mostrar() -> void:
	if esta_activo:
		animacion.play("mostrar")

func ocultar() -> void:
	if not esta_activo:
		animacion.stop()
	animacion.play("ocultar")

func mostrar_suavisado() -> void:
	if not esta_activo:
		return
	animacion.play("mostar_suavisado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavisado() -> void:
	if esta_activo:
		animacion.play("ocultar_suavisado")

func modificar_texto(text: String) -> void:
	texto_contenedor.text = text

## Señales Internas
func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavisado()
