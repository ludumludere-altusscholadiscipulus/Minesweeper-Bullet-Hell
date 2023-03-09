extends enemy

export (float) var time_delay = 1

enum varies {
	NORMAL,
	SPIN,
	MOVE_HORI,
	MOVE_VERT,
	MOVE_DIAG,
}

export (varies) var type

var left := false
var up := false

func _ready():
	delay_shoot.wait_time = time_delay
	delay_shoot.start()

func _process(delta):
	if type == varies.NORMAL:
		pass
	if type == varies.SPIN:
		rotation_degrees += 1
	if type == varies.MOVE_HORI:
		if !left:
			move_and_slide(speed * Vector2.RIGHT)
		else:
			move_and_slide(speed * Vector2.LEFT)
	if type == varies.MOVE_VERT:
		if !up:
			move_and_slide(speed * Vector2.DOWN)
		else:
			move_and_slide(speed * Vector2.UP)
