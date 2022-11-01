#ReleMasa.gd
class_name ReleMasa
extends Node2D

## Metodos
func _ready() -> void:
	Eventos.emit_signal("minimapa_objeto_creado")

## Metodos Custom
func atraer_player(body: Node) -> void:
	$Tween.interpolate_property(
		body,
		"global_position",
		body.global_position,
		global_position,
		1.0,
		Tween.TRANS_CIRC,
		Tween.EASE_IN
	)
	$Tween.start()

## Señales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		$AnimationPlayer.play("activada")

func _on_DeteccionPlayer_body_entered(body: Node) -> void:
	$DeteccionPlayer/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("super_activada")
	body.desactivar_controladores()
	atraer_player(body)

func _on_Tween_tween_all_completed() -> void:
	print("Sos un crack pasaste de nivel")
