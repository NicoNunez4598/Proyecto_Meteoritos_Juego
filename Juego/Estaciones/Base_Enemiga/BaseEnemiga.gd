#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

## Atributos Export
export var hitpoints:float = 30.0
export var enemigo_orbital:PackedScene = null

## Atributos Onready
onready var impacto_sfx:AudioStreamPlayer2D = $Impacto_SFX

## Atributos
var esta_destruida:bool = false

## Metodos
func _ready() -> void:
	$AnimationPlayer.play(elegir_explosion_aleatoria())

func _process(delta: float) -> void:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())

## Metodos Custom
func elegir_explosion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	return lista_animacion[indice_anim_aleatoria]

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0 and not esta_destruida:
		destruir()
		esta_destruida = true
		queue_free()
	impacto_sfx.play()

func destruir() -> void:
	var posiciones_partes = [
		$Sprites/Sprite4.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite.global_position,
		$Sprites/Sprite2.global_position
	]
	Eventos.emit_signal("base_destruida", self, posiciones_partes)
	queue_free()

func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		if sign(angulo_player) > 0:
			return $PosicionesSpawn/Sur.position
		else:
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position

func spawnear_orbital() -> void:
	var pos_spawn:Vector2 = deteccion_cuadrante()
	
	var new_orbital:EnemigoOrbital = enemigo_orbital.instance()
	new_orbital.crear(
		global_position + pos_spawn,
		self
	)
	
	Eventos.emit_signal("spawn_orbital", new_orbital)

## Señales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	spawnear_orbital()
