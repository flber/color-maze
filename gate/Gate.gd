extends Area2D

func _ready():
	pass

signal next_level

func _on_Gate_body_entered(body):
	if body.name == "Player":
		emit_signal('next_level')
