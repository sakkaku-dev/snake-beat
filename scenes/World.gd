extends Spatial

export var snake_scene: PackedScene
export var player_input_path: NodePath
onready var player_input: PlayerInput = get_node(player_input_path)

onready var camera := $Camera
onready var grid := $Grid

var snake

func _ready():
	var last = grid.get_last_position()
	var center = grid.get_grid_center()
	var dir = last - center
	dir = dir.rotated(Vector3.FORWARD, deg2rad(-45))

	var diagonal_size = (grid.get_first_position() - last).length()
	dir = dir * diagonal_size

	camera.global_transform.origin = center + dir
	camera.look_at(center, Vector3.UP)

	snake = snake_scene.instance()
	add_instance_to_grid(snake, Vector2.ZERO)


func add_instance_to_grid(instance: Spatial, grid_pos: Vector2) -> void:
	if grid.get_grid_value(grid_pos) != null:
		print("On grid position is already an object")
		return
	
	add_child(instance)
	var pos = grid.get_position_on_grid(grid_pos)
	if instance.has_method("get_height"):
		pos.y += instance.get_height() / 2
	instance.global_transform.origin = pos
	grid.set_grid_value(grid_pos, 1)

func _process(delta):
	var motion = player_input.get_motion()
	var grid_pos = grid.get_grid_position(snake.global_transform.origin)
	var new_grid_pos = grid.get_grid_move_position(grid_pos, motion)
	snake.target_position = grid.get_position_on_grid(new_grid_pos)
