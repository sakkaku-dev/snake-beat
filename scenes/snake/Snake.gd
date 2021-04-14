extends KinematicBody

class_name Snake

signal beat_hit
signal beat_missed
signal died

export var snake_body: PackedScene

onready var input := $PlayerInput
onready var timer := $Timer
onready var move := $MoveState

var grid: IsometricMap
var is_moving = false
var beat = false

var linked_body

func _ready():
	move.connect("reached_destination", self, "_reached_destination")


func set_initial_pos(pos):
	global_transform.origin = pos
	move.target_position = global_transform.origin


func _reached_destination():
	is_moving = false


func set_grid(g: IsometricMap) -> void:
	grid = g


func delete():
	if linked_body:
		linked_body.delete()
	queue_free()


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
		
		if target_position != null and motion.length() > 0.01:
			if target_position == global_transform.origin:
				rotate_to(global_transform.origin + Vector3(motion.x, 0, motion.y))
				emit_signal("died")
			elif move.target_position != target_position:
				is_moving = true
				beat = false
				move.target_position = target_position
				rotate_to(target_position)
				emit_signal("beat_hit")
				input.reset_inputs()
	elif not beat and input.get_motion().length() > 0.01:
		emit_signal("beat_missed")
		input.reset_inputs()


func rotate_to(pos):
	look_at(pos, Vector3.UP)
	rotate_y(deg2rad(180)) # Setting rotation on object seems to get overwritten


func on_beat():
	beat = true
	timer.start()


func _on_Timer_timeout():
	beat = false
