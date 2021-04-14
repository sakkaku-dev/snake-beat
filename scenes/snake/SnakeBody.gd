extends KinematicBody

var linked_move: MoveState
var grid: IsometricMap

var linked_body

onready var move := $MoveState

func _ready():
	linked_move.connect("moving", self, "set_destination")
	move.target_position = linked_move.last_position


func delete():
	if linked_body:
		linked_body.delete()
	queue_free()


func grow(body_scene: PackedScene):
	if linked_body:
		linked_body.grow(body_scene)
	else:
		var body = body_scene.instance()
		body.linked_move = move
		linked_body = body

		var pos = grid.get_grid_position(move.last_position)
		grid.add_to_grid(body, pos)


func set_grid(g):
	grid = g


func set_destination(old_pos: Vector3, new_pos: Vector3):
	var dir = old_pos - global_transform.origin
	var motion = Vector2(dir.x, dir.z).normalized() 
	var target_position = grid.update_grid_position(global_transform.origin, motion)
	if target_position != null:
		move.target_position = target_position
