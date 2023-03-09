extends KinematicBody2D

var speed = 100
var face_left = false
var can_shoot = true
var mode := "attack"
var selection_sprite = null

onready var sprite = $PlanePlayer
onready var pos = $Position2D
onready var shoot_delay = $Delay

const bullet = preload("res://Bullet.tscn")
const flag = preload("res://Flag.tscn")

func _ready():
	randomize()
	selection_sprite = get_parent().get_node("Sprite")

func _process(delta):
	look_at(get_global_mouse_position())
	input()
	if mode == "search":
		var pos = selection_sprite.global_position + Vector2(24,24)
		var tile_obj = get_parent().get_tile(pos)
		if Input.is_action_just_pressed("mouse_click") and !tile_obj.open and !tile_obj.marked:
			get_parent().destroy_tile(tile_obj)
		if Input.is_action_just_pressed("right_click") and !tile_obj.open:
			#Mark the tile
			tile_obj.marked = !tile_obj.marked
		selection_sprite.global_position.x = clamp(int(get_global_mouse_position().x / 48) * 48, int(global_position.x / 48) * 48 - 96,int(global_position.x / 48) * 48 + 96)
		selection_sprite.global_position.y = clamp(int(get_global_mouse_position().y / 48) * 48, int(global_position.y / 48) * 48 - 96,int(global_position.y / 48) * 48 + 96)

	elif mode == "attack":
		if Input.is_action_pressed("mouse_click") and can_shoot:
			shoot()
	if Input.is_action_just_pressed("switch"):
		if mode == "attack":
			mode = "search"
		elif mode == "search":
			mode = "attack"
	
	selection_sprite.visible = true if mode == "search" else false

func input():
	var vel = Vector2()
	if Input.is_action_pressed("down"):
		vel.y += 1
	if Input.is_action_pressed("left"):
		vel.x -= 1
		face_left = true
	if Input.is_action_pressed("right"):
		vel.x += 1
		face_left = false
	if Input.is_action_pressed("up"):
		vel.y -= 1
	
	vel.normalized()
	move_and_slide(speed * vel)

func shoot():
	var obj = bullet.instance()
	obj.global_position = pos.global_position
	obj.global_rotation = global_rotation + rand_range(-0.15,0.15)
	get_parent().add_child(obj)
	can_shoot = false
	shoot_delay.start()

func take_damage():
	pass

func _on_Delay_timeout():
	can_shoot = true
