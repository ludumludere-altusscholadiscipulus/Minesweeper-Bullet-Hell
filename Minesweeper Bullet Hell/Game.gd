extends Node2D

var bombs_position := []
var safe_children := []
var start := false

@export var size := Vector2(0,0)

@onready var tile_parent = $Tiles
@onready var tilemap = $TileMap
@onready var cam = $Player/Camera2D
@onready var play = $Player

const bomb_instance := preload("res://Bomb.tscn")
const safe_instance := preload("res://Safe.tscn")
const square := 48
const offset := 24

func _ready():
	var bombs = int(0.12 * size.x * size.y)
	randomize()
	while bombs_position.size() < bombs:
		var pos : Vector2 = Vector2(randi() % int(size.x) , randi() % int(size.y))
		if not bombs_position.has(pos):
			bombs_position.append(pos)
			var obj = bomb_instance.instantiate()
			obj.position = Vector2(pos.x * square + offset,pos.y * square + offset)
			tile_parent.add_child(obj)
	for x in range(size.x):
		for y in range(size.y):
			if not bombs_position.has(Vector2(x,y)):
				var obj = safe_instance.instantiate()
				obj.position = Vector2(x*square + offset,y*square + offset)
				tile_parent.add_child(obj)
				safe_children.append(obj)
			tilemap.set_cells_terrain_connect(0,[Vector2i(x,y)],0,0)
			var flower_type = randi() % 50 - 40
			tilemap.set_cell(1,Vector2(x,y),1,Vector2(flower_type,0))
			
	cam.limit_right = size.x * square
	cam.limit_bottom = size.y * square
	
func _process(delta):
	debug()

func destroy_tile(tile_obj : tile):
	var tile_loc = tilemap.local_to_map(tile_obj.global_position)
	tilemap.set_cells_terrain_connect(0,[tile_loc],0,-1)
	tilemap.set_cell(1,tile_loc,1)
#	tilemap.erase_cell(0,tile_loc)
	tile_obj.open = true
	if tile_obj in safe_children:
		if tile_obj.value == 0:
			bfs(tile_loc)
	else:
		pass

func bfs(mouse_pos : Vector2):
	var frontier = []
	var came_from = {}
	var start_location = mouse_pos
	frontier.push_front(start_location)
	came_from[start_location] = null
	while !frontier.is_empty():
		var current = frontier.pop_front()
		for next in get_neighbours(current):
			var tile_obj = get_tile(next * square + Vector2(offset,offset))
			if not (next in bombs_position) and tilemap.get_cell_source_id(0,next) != -1 and !came_from.has(next) and !tile_obj.marked and !tile_obj.open:
				tilemap.set_cells_terrain_connect(0,[next],0,-1)
				tilemap.set_cell(1,next,1)
				tile_obj.open = true
				came_from[next] = current
				if get_tile_value(next * square + Vector2(offset,offset)) == 0:
					frontier.push_back(next)

func get_neighbours(node):
	var neighbours = []
	neighbours.append(node + Vector2(0,1))
	neighbours.append(node + Vector2(0,-1))
	neighbours.append(node + Vector2(1,0))
	neighbours.append(node + Vector2(-1,0))
	neighbours.append(node + Vector2(-1,-1))
	neighbours.append(node + Vector2(1,-1))
	neighbours.append(node + Vector2(1,-1))
	neighbours.append(node + Vector2(1,1))
	return neighbours

func get_tile_value(target : Vector2):
	for i in safe_children:
		if i.global_position == target:
			return i.value
	return null

func get_tile(target : Vector2):
	for i in tile_parent.get_children():
		if i.global_position == target:
			return i
	return null

func debug():
	pass
#	tilemap.visible = !Input.is_action_pressed("toggle_tilemap_visible")
