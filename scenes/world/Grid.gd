extends Spatial

export var ground: PackedScene
export var ground_size = 1.0
export var grid_size = Vector2(5, 5)

# Saves what objects are on the grid
var grid = []

func _ready():
	var start_position = Vector2(0, 0)
	var position = start_position
	grid = []
	for z in range(0, grid_size.y):
		var line = []
		
		for x in range(0, grid_size.x):
			line.append(0)
			
			var ground_instance: Spatial = ground.instance()
			add_child(ground_instance)
			ground_instance.transform.origin = Vector3(position.x, 0, position.y)
			
			position.x += ground_size
			
		position.y += ground_size
		position.x = start_position.x
		grid.append(line)


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
