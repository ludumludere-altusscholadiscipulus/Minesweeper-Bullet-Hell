extends CharacterBody2D

enum varies {
	NORMAL,
	MOVE_HORI,
	MOVE_VERT,
	MOVE_DIAG,
	MOVE_CIRC,
}

@export var type : varies
@export var time_delay : float = 1
@export var speed : float = 5
@export var health : int = 3
@export var bullet_instance : PackedScene
@export var spin : bool = false

@onready var delay_shoot = $Timer
@onready var bullet_spawn = $Positions

var left := false
var up := false
var player = null
var d := 0.0

func _ready():
	player = get_parent().get_node("Player")
	var call = Callable(self,"shoot")
	delay_shoot.connect("timeout",call)
	delay_shoot.wait_time = time_delay
	delay_shoot.start()

func _physics_process(delta):
	if spin:
		rotation_degrees += 1
	if type == varies.MOVE_HORI:
		if !left:
			set_velocity(speed * Vector2.RIGHT)
		else:
			set_velocity(speed * Vector2.LEFT)
		move_and_slide()
	if type == varies.MOVE_VERT:
		if !up:
			set_velocity(speed * Vector2.DOWN)
		else:
			set_velocity(speed * Vector2.UP)
		move_and_slide()
	if type == varies.MOVE_DIAG:
		if !left:
			if !up:
				set_velocity(speed * Vector2(1,1))
			else:
				set_velocity(speed * Vector2(1,-1))
		else:
			if !up:
				set_velocity(speed * Vector2(-1,1))
			else:
				set_velocity(speed * Vector2(-1,-1))
		move_and_slide()
	if type == varies.MOVE_CIRC:
		d += delta
		var vel = sin(d)
		
	if health <= 0:
		self.queue_free()

func shoot():
	for child in bullet_spawn.get_children():
		var obj = bullet_instance.instantiate()
		obj.global_position = child.global_position
		obj.global_rotation = child.global_rotation
		get_parent().add_child(obj)

func take_damage():
	health -= 1
	modulate = Color(7,7,7)
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
