extends KinematicBody

class_name Snake

signal beat_hit
signal beat_missed

export var snake_body: PackedScene

onready var input := $PlayerInput
onready var timer := $Timer
onready var move := $MoveState

var target_position = Vector3.ZERO
var velocity = Vector3.ZERO

var grid: IsometricMap
var is_moving = false
var beat = false

var linked_body

func _ready():
	move.connect("reached_destination", self, "_reached_destination")


func _reached_destination():
	is_moving = false


func set_grid(g: IsometricMap) -> void:
	grid = g


func grow():
	if linked_body:
		linked_body.grow(snake_body)
	else:
		var body = snake_body.instance()
		body.linked_move = move
		linked_body = body

		var pos = grid.get_grid_position(move.last_position)
		grid.add_to_grid(body, pos)


func _physics_process(_delta):
	if not is_moving and beat:
		var motion = input.get_motion()
		var target_position = grid.update_grid_position(global_transform.origin, motion)
		
		if move.target_position != target_position:
			is_moving = true
			beat = false
			move.target_position = target_position
			
			look_at(target_position, Vector3.UP)
			rotate_y(deg2rad(180)) # Setting rotation on object seems to get overwritten
			
			emit_signal("beat_hit")
			input.reset_inputs()
	elif not beat and input.get_motion().length() > 0.01:
		emit_signal("beat_missed")
		input.reset_inputs()

func on_beat():
	beat = true
	timer.start()


func _on_Timer_timeout():
	beat = false
