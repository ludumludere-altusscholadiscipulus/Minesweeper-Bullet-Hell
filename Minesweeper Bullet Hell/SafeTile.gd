extends "res://Tile.gd"

var value = 0

onready var number_label = $Label

func _ready():
	pass

func _on_CheckSurroundings_area_entered(area):
	if area.is_in_group("bomb"):
		value += 1
		number_label.text = str(value)
