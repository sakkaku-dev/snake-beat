extends Spatial

export var snake_scene: PackedScene

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
	grid.add_to_grid(snake, Vector2.ZERO)


func _on_MusicBeat_beat():
	snake.on_beat()
