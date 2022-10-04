#ExplosionMeteorito.gd
class_name ExplosionMeteorito
extends Node2D

func _ready() -> void:
	$AnimationPlayer.play(elegir_explosion_aleatoria())

func elegir_explosion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	if num_anim == 0:
		return lista_animacion[num_anim]
	else:
		var indice_anim_aleatoria:int = randi() % num_anim + 1
		return lista_animacion[indice_anim_aleatoria]

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
