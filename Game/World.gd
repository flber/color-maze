extends Node2D

export var background : Color

const WALL = preload("res://tiles/Wall.tscn")
const FLOOR = preload("res://tiles/Floor.tscn")
const ENEMY = preload("res://enemy/Enemy.tscn")
onready var player = $Player
onready var gate = $Gate
export var size : int

var time = 0
var sec_to_wave = 4
var enemy_spawn_num = 0.0

var r
var g
var b

func _ready():
	if get_tree().paused:
		get_tree().paused = false
	VisualServer.set_default_clear_color(background)
	r = lerp(0, 1, background.r)
	g = lerp(0, 1, background.g)
	b = lerp(0, 1, background.b)
	size = 15 * GameState.level
	add_to_group("world")
	generate_map()
	for i in range(0, get_child_count()):
		get_child(i).set_z_index(get_child_count() - i)

func _process(delta):
	time += 1
	if time > sec_to_wave * 60 + 1:
		time = 0
	if time == sec_to_wave * 60:
		var level_factor = 1.2 * GameState.level
		enemy_spawn_num = floor(pow(level_factor, (enemy_spawn_num - 10.0)) + 3.0)
		for i in range(1, enemy_spawn_num):
			randomize()
			var e = ENEMY.instance()
			var theta = rand_range(0, 2*PI)
			var rad = 1500
			var pos = Vector2(player.position.x+cos(theta)*rad, player.position.x+sin(theta)*rad)
			e.position = pos
			e.set_player(player)
			e.set_size(rand_range(0.0, 1.0))
			get_node("Enemies").add_child(e)

func generate_map():
	randomize()
	for i in range(0, size):
		for j in range (0, size):
			var midpoint = ceil(size/2 + 0.1)
			if i == midpoint and j == midpoint:
				player.position = Vector2(i*128, j*128)
				
				var f = FLOOR.instance()
				f.position = Vector2(i*128, j*128)
				f.set_color(Vector3(r, g, b))
				get_node("Floors").add_child(f)
			elif i == 0 or i == (size - 1) or j == 0 or j == (size - 1):
				var w = WALL.instance()
				w.position = Vector2(i*128, j*128)
				w.set_color(Vector3(r*0.9, g*0.9, b*0.9))
				get_node("Walls").add_child(w)
			elif i == 1 or i == (size - 2) or j == 1 or j == (size - 2):
				var f = FLOOR.instance()
				f.position = Vector2(i*128, j*128)
				f.set_color(Vector3(r, g, b))
				get_node("Floors").add_child(f)
			elif rand_range(0, 1) < 0.25:
				var w = WALL.instance()
				w.position = Vector2(i*128, j*128)
				w.set_color(Vector3(r, g, b))
				get_node("Walls").add_child(w)
			else:
				var f = FLOOR.instance()
				f.position = Vector2(i*128, j*128)
				f.set_color(Vector3(r, g, b))
				get_node("Floors").add_child(f)
	var side = round(rand_range(1, 4))
	if side == 1:
		gate.position = Vector2(size*64 + 64, 128)
	if side == 2:
		gate.position = Vector2((size-2)*128, size*64 + 64)
	if side == 3:
		gate.position = Vector2(size*64 + 64, (size-2)*128)
	if side == 4:
		gate.position = Vector2(128, size*64 + 64)

func _on_Player_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	b.start(_position, _direction)
	get_node("Bullets").add_child(b)

func add_splatter(splatter, _position, _color):
	var s = splatter.instance()
	s.position = _position
	s.rotation = rand_range(0, 2*PI)
	s.start(_color)
	get_node("Splatters").add_child(s)
	
func add_blood(blood, _position, _velocity, _color):
	var b = blood.instance()
	b.start(_position, _velocity, _color)
	get_node("Bullets").add_child(b)


func _on_Gate_next_level():
	get_tree().reload_current_scene()
	GameState.level += 1
