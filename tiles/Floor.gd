extends Sprite

var Mat = Material

func _ready():
	pass

func set_color(_color):
	self.get_material().resource_local_to_scene = true
	Mat = self.get_material()
	Mat.set_shader_param("color", _color)
