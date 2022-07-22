#Player.gd
class_name Player
extends RigidBody2D

## Atributos Export
export var potencia_motor:int = 20
export var potencia_rotacion:int = 280

## Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

## Atributos Onready
onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D

## Metodos
func _unhandled_input(event: InputEvent) -> void:
	#Disparo Laser
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func _process(delta: float) -> void:
	player_input()

## Metodos Custom
func player_input() -> void:
	# Empuje
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
	
	# Rotacion
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
	elif Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1
	
	# Disparar
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)


func _ready():
	pass # Replace with function body.