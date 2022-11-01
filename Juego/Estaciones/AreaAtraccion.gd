#AreaAtraccion.gd
extends Area2D

func _on_body_entered(body):
	body.set_gravity_scale(0.1)

func _on_body_exited(body):
	body.set_gravity_scale(0.0)
