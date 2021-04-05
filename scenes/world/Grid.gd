extends GridMap

export var ground: PackedScene
export var ground_size = 1.0
export var grid_size = Vector2(5, 5)

# Saves what objects are on the grid
var grid = []

func _ready():
	var block = mesh_library.find_item_by_name("block")
	
	
	var start_position = Vector2(0, 0)
	var position = start_position
#	grid = []
	for z in range(0, grid_size.y):
#		var line = []
		
		for x in range(0, grid_size.x):
#			line.append(null)
			set_cell_item(start_position.x, 0, start_position.y, block)
#			var ground_instance: Spatial = ground.instance()
#			add_child(ground_instance)
#			ground_instance.transform.origin = Vector3(position.x, 0, position.y)
			
			position.x += 1
			
		position.y += 1
		position.x = 0
#		grid.append(line)


func is_grid_position_occupied(grid_pos: Vector2) -> bool:
	return get_grid_value(grid_pos) == 1


func get_grid_value(grid_pos: Vector2) -> int:
	if is_inside_grid(grid_pos):
		return grid[grid_pos[0]][grid_pos[1]]
	return -1


func set_grid_value(grid_pos: Vector2, value: int) -> void:
	if is_inside_grid(grid_pos):
		grid[grid_pos[0]][grid_pos[1]] = value


func is_inside_grid(grid_pos: Vector2) -> bool:
	return grid_pos.y >= 0 and grid_pos.y < grid.size() and \
		grid_pos.x >= 0 and grid_pos.x < grid[0].size()

# get global position based on grid position index
func get_position_on_grid(pos: Vector2) -> Vector3:
	if pos.y >= grid_size.y or pos.x >= grid_size.x:
		return Vector3.ZERO
	
	var idx = pos.y * grid_size.y
	idx += pos.x
	
	if idx >= get_child_count():
		return Vector3.ZERO
	
	var position = get_child(idx).global_transform.origin
	position.y += ground_size / 2
	return position

# get grid position based on global position
func get_grid_position(global_pos: Vector3) -> Vector2:
	if global_pos.x < 0 or global_pos.z < 0:
		return Vector2.ZERO
	
	var row = floor(global_pos.z / ground_size)
	var col = floor(global_pos.x / ground_size)
	var grid_pos = Vector2(col, row)
	
	if is_inside_grid(grid_pos):
		return grid_pos
	return Vector2.ZERO


func get_grid_move_position(grid_pos: Vector2, dir: Vector2) -> Vector2:
	var new_pos = grid_pos + dir.normalized()
	if not is_inside_grid(new_pos):
		return grid_pos
	
	if is_grid_position_occupied(new_pos):
		return grid_pos
	
	return new_pos

func get_grid_center() -> Vector3:
	var last_pos = get_last_position()
	last_pos.z += ground_size / 2
	last_pos.x += ground_size / 2
	return last_pos / 2


func get_last_position() -> Vector3:
	var last_grid_child: Spatial = get_child(get_child_count() - 1)
	return last_grid_child.global_transform.origin


func get_first_position() -> Vector3:
	var first_grid_child: Spatial = get_child(0)
	return first_grid_child.global_transform.origin
