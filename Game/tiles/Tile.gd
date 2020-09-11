extends KinematicBody2D

var Mat = Material

func _ready():
	pass

func set_color(_color):
	$Sprite.get_material().resource_local_to_scene = true
	Mat = $Sprite.get_material()
	Mat.set_shader_param("color", _color)
