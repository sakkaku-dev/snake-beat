extends Spatial

onready var camera := $Camera
onready var grid := $Grid

func _ready():
	var last = grid.get_last_position()
	var center = grid.get_grid_center()
	var dir = last - center
	dir = dir.rotated(Vector3.FORWARD, deg2rad(-45))
	
	var diagonal_size = (grid.get_first_position() - last).length()
	dir = dir * diagonal_size
	
	camera.global_transform.origin = center + dir
	camera.look_at(center, Vector3.UP)
