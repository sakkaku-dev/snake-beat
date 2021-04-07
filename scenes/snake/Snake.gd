extends KinematicBody

export var speed = 10
export var accel = 1000
export var target_distance = 0.1

onready var input := $PlayerInput
onready var timer := $Timer

var target_position = Vector3.ZERO
var velocity = Vector3.ZERO

var grid: IsometricMap
var is_moving = false
var beat = false

func set_grid(g: IsometricMap) -> void:
	grid = g


func reached_target_position() -> bool:
	var dir = target_position - global_transform.origin
	return dir.length() <= target_distance

func _physics_process(delta):
	if is_moving:
		var dir = target_position - global_transform.origin
		dir = dir.normalized()
		
		velocity = velocity.move_toward(dir * speed, accel * delta)
		velocity = move_and_slide(velocity, Vector3.UP)
		
		if reached_target_position():
			is_moving = false
			global_transform.origin = target_position
	elif beat:
		var motion = input.get_motion()
		target_position = grid.update_grid_position(global_transform.origin, motion)
		target_position.y = global_transform.origin.y
		
		if not reached_target_position():
			is_moving = true
			beat = false

func on_beat():
	beat = true
	timer.start()


func _on_Timer_timeout():
	beat = false
