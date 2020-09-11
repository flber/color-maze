extends Area2D

export (int) var speed = 600
export (float) var lifetime = 5
var color = -1
var Mat = Material

onready var splatter = preload("res://enemy/Splatter.tscn")

var velocity = Vector2()

func start(_position, _direction, _color):
	$Sprite.get_material().resource_local_to_scene = true
	position = _position
	rotation = _direction.angle()
	color = _color
	Mat = $Sprite.get_material()
	Mat.set_shader_param("size", color)
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta
	
func _on_Blood_body_entered(body):
	if body.name != "Player":
		if body.has_method("kill"):
			pass
		else:
			explode()
			#get_tree().call_group("world", "add_splatter", splatter, position)

func _on_Lifetime_timeout():
	queue_free()

func explode():
	get_tree().call_group("world", "add_splatter", splatter, position, color)
	queue_free()
