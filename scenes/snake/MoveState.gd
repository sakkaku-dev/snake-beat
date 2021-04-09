extends Node

class_name MoveState

signal moving(old_pos, new_pos)
signal reached_destination

export var body_path: NodePath
onready var body: KinematicBody = get_node(body_path)

export var speed = 10
export var accel = 1000
export var target_distance = 0.1

var last_position = Vector3.ZERO
var target_position = Vector3.ZERO setget set_target
var velocity = Vector3.ZERO


func set_target(pos: Vector3) -> void:
	last_position = body.global_transform.origin
	target_position = pos
	emit_signal("moving", last_position, target_position)


func _physics_process(delta):
	var dir = target_position - body.global_transform.origin
	dir = dir.normalized()
	
	velocity = velocity.move_toward(dir * speed, accel * delta)
	velocity = body.move_and_slide(velocity, Vector3.UP)
	
	if reached_target_position():
		emit_signal("reached_destination")
		body.global_transform.origin = target_position


func reached_target_position() -> bool:
	var dir = target_position - body.global_transform.origin
	return dir.length() <= target_distance
