extends Area2D

export (int) var speed = 200
export (int) var damage = 1
export (float) var lifetime = 5

onready var blood = preload("res://player/Blood.tscn")

var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta
	
func _on_Bullet_body_entered(body):
	randomize()
	if body.name != "Player":
		if body.has_method("kill"):
			body.kill()
			var color = body.get_size()
			var num_blood = rand_range(6, 10)
			for i in range(0, num_blood):
				var op_rot = rotation - PI
				var a = rand_range(op_rot - PI/4, op_rot + PI/4)
				var to_vec = Vector2(position.x + cos(a), position.y + sin(a))
				var vel = position - to_vec
				vel = vel.normalized()
				get_tree().call_group("world", "add_blood", blood, position, vel, color)
			explode()
		else:
			explode()
			#get_tree().call_group("world", "add_splatter", splatter, position)

func _on_Lifetime_timeout():
	explode()

func explode():
	queue_free()
