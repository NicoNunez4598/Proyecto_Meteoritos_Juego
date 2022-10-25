#LaserBeam2D
class_name RayoLaser
extends RayCast2D

## Atributos Export
export var cast_speed := 7000.0
export var max_length := 1400.0
export var growth_time := 0.1
export var radio_danio:float = 4.0
export var energia:float = 8.0
export var radio_desgaste:float = -1.0

## Atributos
var is_casting := false setget set_is_casting
var energia_original:float

## Atributos Onready
onready var fill := $FillLine2D
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D
onready var laser_sfx: AudioStreamPlayer2D = $LaserSFX
onready var line_width: float = fill.width

## Metodos
func _ready() -> void:
	energia_original = energia
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam(delta)

## Metodos Custom
func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		laser_sfx.play()
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		Eventos.emit_signal("ocultar_energia_laser")
		laser_sfx.stop()
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting

func cast_beam(delta: float) -> void:
	var cast_point := cast_to
	
	if energia <= 0.0:
		set_is_casting(false)
		return
	
	controlar_energia(radio_desgaste * delta)
	
	force_raycast_update()
	collision_particles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		if get_collider().has_method("recibir_danio"):
			get_collider().recibir_danio(radio_danio * delta)
	
	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func controlar_energia(consumo: float) -> void:
	energia += consumo
	if energia > energia_original:
		energia = energia_original
	Eventos.emit_signal("cambio_energia_laser", energia_original, energia)

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time)
	tween.start()

func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
