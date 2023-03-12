extends Area2D
class_name tile

@onready var flag = $Flag
var marked := false
var open := false

func _ready():
	flag.z_index = 1
	
func _process(delta):
	flag.visible = marked
