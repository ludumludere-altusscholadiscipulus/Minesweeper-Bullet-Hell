extends Area2D

export (float) var speed = 15

onready var visibility = $VisibilityNotifier2D

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility.connect("screen_exited",self,"_on_VisibilityNotifier2D_screen_exited")
	connect("body_entered",self,"body_collide")

func _process(delta):
	position += global_transform.x * speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func body_collide(body : Node):
	if (body is enemy and is_in_group("player_bullet")) or (body.name == "Player" and is_in_group("enemy_bullet")):
		body.take_damage()
		queue_free()
