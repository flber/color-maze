extends KinematicBody2D

const MOVE_SPEED = 500
export (PackedScene) var Bullet

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_and_slide(move_vec * MOVE_SPEED)

	var look_vec = get_global_mouse_position() - global_position
	look_vec = look_vec.normalized()
	look_at(look_vec)

	if Input.is_action_just_pressed("shoot"):
#		for i in range(0, 8*PI):
#			_shoot(Vector2(cos(i), sin(i)))
		_shoot(look_vec)

signal shoot(bullet, _position, _direction)
func _shoot(_dir):
	emit_signal('shoot', Bullet, position, _dir)

signal died
func kill():
	emit_signal("died")
#	get_tree().reload_current_scene()
