extends Spatial

signal apple_eaten
signal beat_missed

export var snake_scene: PackedScene
export var apple_scene: PackedScene

onready var camera := $Camera
onready var grid := $Grid
onready var beat_indicator := $CanvasLayer/BeatIndicator
onready var music_beat := $MusicBeat
onready var game_over_sound := $GameOver
onready var game_over_screen := $CanvasLayer/GameOver
onready var score_screen := $CanvasLayer/ScoreContainer
onready var menu := $CanvasLayer/Menu
onready var score_board := $CanvasLayer/Scoreboard

var apple
var snake
var game_over = true

func _ready():
	open_menu()

func reset():
	if snake:
		snake.delete()
	
	if apple:
		apple.queue_free()
	
	game_over = false
	game_over_screen.hide()
	menu.hide()
	
	beat_indicator.show()
	score_screen.show()
	score_board.submitted = false
	
	score_screen.reset()
	music_beat.play()
	grid.reset()
	
	position_camera()
	spawn_snake()
	spawn_apple()


func spawn_snake():
	snake = snake_scene.instance()
	grid.add_to_grid(snake, Vector2.ZERO)
	snake.connect("beat_hit", beat_indicator, "hit_beat")
	snake.connect("beat_missed", self, "beat_missed")
	snake.connect("died", self, "game_over")


func spawn_apple():
	apple = apple_scene.instance()
	var pos = grid.get_random_free_position()
	
	if pos != null:
		grid.add_to_grid(apple, pos, false)
		apple.connect("eaten", self, "apple_eaten")


func apple_eaten():
	emit_signal("apple_eaten")
	spawn_apple()


func beat_missed():
	emit_signal("beat_missed")
	beat_indicator.miss_beat()


func position_camera():
	var last = grid.get_last_position()
	var center = grid.get_grid_center()
	var dir = last - center
	dir = dir.rotated(Vector3.FORWARD, deg2rad(-45))

	var diagonal_size = (grid.get_first_position() - last).length()
	dir = dir * diagonal_size

	camera.global_transform.origin = center + dir
	camera.look_at(center, Vector3.UP)


func open_scoreboard():
	game_over_screen.hide()
	score_board.show()
	menu.hide()


func open_menu():
	game_over_screen.hide()
	score_board.hide()
	beat_indicator.hide()
	score_screen.hide()
	menu.show()


func _on_MusicBeat_beat():
	if not game_over:
		snake.on_beat()


func game_over():
	music_beat.stop()
	game_over_sound.play()
	game_over_screen.show()
	game_over = true
	beat_indicator.hide()
