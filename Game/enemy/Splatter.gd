extends Sprite

var color = -1
var Mat = Material

func start(_color):
	color = _color

func _ready():
	self.get_material().resource_local_to_scene = true
	Mat = self.get_material()
	Mat.set_shader_param("size", color)
