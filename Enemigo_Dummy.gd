#Enemigo_Dummy.gd
extends Node2D

## Atributos
var hitpoints:float = 10.0

## Metodos
func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		queue_free()

func _process(_delta: float) -> void:
	$Canion.set_esta_disparando(true)

## Señales
func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.destruir()
