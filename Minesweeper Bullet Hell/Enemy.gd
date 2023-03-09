extends KinematicBody2D
class_name enemy

export (int) var health = 3
export (PackedScene) var bullet_instance
export (float) var speed = 5

onready var delay_shoot = $Timer
onready var bullet_spawn = $Positions

func _ready():
	delay_shoot.connect("timeout",self,"shoot")

func _physics_process(delta):
	if health == 0:
		queue_free()

func shoot():
	for child in bullet_spawn.get_children():
		var obj = bullet_instance.instance()
		obj.global_position = child.global_position
		obj.global_rotation = child.global_rotation
		get_parent().add_child(obj)

func take_damage():
	health -= 1
	modulate = Color(7,7,7)
	yield(get_tree().create_timer(0.1),"timeout")
	modulate = Color.white
