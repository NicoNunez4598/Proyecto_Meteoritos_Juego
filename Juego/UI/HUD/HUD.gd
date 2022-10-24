#HUD.gd
extends CanvasLayer

## Atributos Onready
onready var info_zona_recarga:ContenedorInformacion = $InfoZonaRecarga
onready var info_zona_meteoritos:ContenedorInformacion = $InfoZonaMeteoritos
onready var info_tiempo_restante:ContenedorInformacion = $InfoTiempoRestante
onready var info_laser:ContenedorInformacionEnergia = $InfoLaser

## Metodos
func _ready() -> void:
	conectar_seniales()

## Metodos Custom
func conectar_seniales() -> void:
	Eventos.connect("nivel_iniciado", self, "fade_out")
	Eventos.connect("nivel_terminado", self, "fade_in")
	Eventos.connect("detecto_zona_recarga", self, "on_detecto_zona_recarga")
	Eventos.connect("cambio_numero_meteoritos", self, "on_cambio_numero_meteoritos")
	Eventos.connect("actualizar_tiempo", self, "_on_actualizar_info_tiempo")
	Eventos.connect("cambio_energia_laser", self, "_on_actualizar_energia_laser")
	Eventos.connect("ocultar_energia_laser", info_laser, "ocultar")

func fade_in() -> void:
	$FadeCanvas/AnimationPlayer.play("fade_in")

func fade_out() -> void:
	$FadeCanvas/AnimationPlayer.play_backwards("fade_in")

func on_detecto_zona_recarga(en_zona: bool) -> void:
	if en_zona:
		info_zona_recarga.mostrar_suavisado()
	else:
		info_zona_recarga.ocultar_suavisado()

func on_cambio_numero_meteoritos(numero: int) -> void:
	info_zona_meteoritos.mostrar_suavisado()
	info_zona_meteoritos.modificar_texto("Meteoritos\n Restantes\n {cantidad}".format({"cantidad":numero}))

func _on_actualizar_info_tiempo(tiempo_restante: int) -> void:
	var minutos:int = floor(tiempo_restante * 0.01666666666667)
	var segundos:int = tiempo_restante % 60
	info_tiempo_restante.modificar_texto(
		"Tiempo \n Restante\n%02d:%02d" % [minutos, segundos]
	)
	
	if tiempo_restante % 10 == 0:
		info_tiempo_restante.mostrar_suavisado()
	
	if tiempo_restante == 11:
		info_tiempo_restante.set_auto_ocultar(false)
	elif tiempo_restante == 0:
		info_tiempo_restante.ocultar()

func _on_actualizar_energia_laser(energia_max:float, energia_actual:float) -> void:
	info_laser.mostrar()
	info_laser.actualizar_energia(energia_max, energia_actual)
