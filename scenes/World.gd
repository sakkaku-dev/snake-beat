extends Spatial

export var snake_scene: PackedScene
export var apple_scene: PackedScene

onready var camera := $Camera
onready var grid := $Grid
onready var beat_indicator := $CanvasLayer/BeatIndicator

var snake

func _ready():
	position_camera()

	spawn_snake()
	spawn_apple()
	

func spawn_snake():
	snake = snake_scene.instance()
	grid.add_to_grid(snake, Vector2.ZERO)
	snake.connect("beat_hit", beat_indicator, "hit_beat")
	snake.connect("beat_missed", beat_indicator, "miss_beat")


func spawn_apple():
	var apple = apple_scene.instance()
	var pos = grid.get_random_free_position()
	
	if pos != null:
		grid.add_to_grid(apple, pos, false)
		apple.connect("eaten", self, "spawn_apple")


func position_camera():
	var last = grid.get_last_position()
	var center = grid.get_grid_center()
	var dir = last - center
	dir = dir.rotated(Vector3.FORWARD, deg2rad(-45))

	var diagonal_size = (grid.get_first_position() - last).length()
	dir = dir * diagonal_size

	camera.global_transform.origin = center + dir
	camera.look_at(center, Vector3.UP)

func _on_MusicBeat_beat():
	snake.on_beat()
