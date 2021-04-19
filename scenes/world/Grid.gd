extends GridMap

class_name IsometricMap

signal moving_into_occupied

export var ground_size = 1.0
export var grid_size = Vector2(5, 5)

# Saves what objects are on the grid
var grid = []

func reset():
	clear()
	
	var block = mesh_library.find_item_by_name("block")
	
	var start_position = Vector2(0, 0)
	var position = start_position
	grid = []
	for z in range(0, grid_size.y):
		var line = []
		
		for x in range(0, grid_size.x):
			line.append(0)
			set_cell_item(position.x, 0, position.y, block)
			position.x += 1
			
		position.y += 1
		position.x = 0
		grid.append(line)


func get_all_free_positions() -> Array:
	var free_pos = []
	for y in range(0, grid_size.y):
		for x in range(0, grid_size.x):
			var pos = Vector2(x, y)
			if not is_grid_position_occupied(pos):
				free_pos.append(pos)
	return free_pos


func get_random_free_position():
	var free_pos = get_all_free_positions()
	
	if free_pos.size() == 0:
		return null
	
	var idx = randi() % free_pos.size()
	return free_pos[idx]


func add_to_grid(instance: Spatial, grid_pos: Vector2, block = true) -> bool:
	if is_grid_position_occupied(grid_pos):
		print("On grid position is already an object")
		return false
	
	var pos = get_position_on_grid(grid_pos)
	pos.y += ground_size

	if instance.has_method("set_grid"):
		instance.set_grid(self)

	add_child(instance)
	
	if instance.has_method("set_initial_pos"):
		instance.set_initial_pos(pos)
	else:
		instance.global_transform.origin = pos
	
	if block:
		set_grid_value(grid_pos, 1)

	return true


func is_grid_position_occupied(grid_pos: Vector2) -> bool:
	return get_grid_value(grid_pos) == 1


func get_grid_value(grid_pos: Vector2) -> int:
	if is_inside_grid(grid_pos):
		return grid[grid_pos.y][grid_pos.x]
	return -1


func set_grid_value(grid_pos: Vector2, value: int) -> void:
	if is_inside_grid(grid_pos):
		grid[grid_pos.y][grid_pos.x] = value


func is_inside_grid(grid_pos: Vector2) -> bool:
	return grid_pos.y >= 0 and grid_pos.y < grid.size() and \
		grid_pos.x >= 0 and grid_pos.x < grid[0].size()


# get global position of the ground surface based on grid position index
func get_position_on_grid(grid_pos: Vector2) -> Vector3:
	return map_to_world(grid_pos.x, 0, grid_pos.y)


# get grid position based on global position
func get_grid_position(global_pos: Vector3) -> Vector2:
	var grid_pos = world_to_map(global_pos)
	return Vector2(grid_pos.x, grid_pos.z)


func update_grid_position(pos: Vector3, dir: Vector2):
	var grid_pos = get_grid_position(pos)
	var new_grid_pos = grid_pos + dir
	
	var result = get_position_on_grid(grid_pos)
	
	if not is_inside_grid(new_grid_pos):
		return null
	
	if not is_grid_position_occupied(new_grid_pos):
		set_grid_value(grid_pos, 0)
		set_grid_value(new_grid_pos, 1)
		result = get_position_on_grid(new_grid_pos)
	
	result.y += ground_size
	return result


func get_grid_center() -> Vector3:
	var last_pos = get_last_position()
	last_pos.z += ground_size / 2
	last_pos.x += ground_size / 2
	return last_pos / 2


func get_last_position() -> Vector3:
	return map_to_world(grid_size.x, 0, grid_size.y)


func get_first_position() -> Vector3:
	return map_to_world(0, 0, 0)
