extends KinematicBody2D
 
var MOVE_SPEED = 200
export var gradient : GradientTexture = null
var size = 0
var Mat = Material
onready var raycast = $RayCast2D

var player = null
 
func _ready():
	$Sprite.get_material().resource_local_to_scene = true
	add_to_group("enemies")

func set_size(_size):
	size = _size
	Mat = $Sprite.get_material()
	Mat.set_shader_param("size", size)
	MOVE_SPEED += (size - 0.5)*150

func get_size():
	return size
 
func _physics_process(delta):
	if player == null:
		return
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player":
			coll.kill()

func _on_Enemy_body_entered(body):
	if body.name == "Player":
		if body.has_method("kill"):
			body.kill()
 
func kill():
	queue_free()
 
func set_player(p):
	player = p
