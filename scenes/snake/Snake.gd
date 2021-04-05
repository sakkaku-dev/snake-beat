extends KinematicBody

export var speed = 100
export var accel = 100

var target_position = Vector3.ZERO
var velocity = Vector3.ZERO

func get_height():
	return 1.0


func _physics_process(delta):
	var motion = target_position - global_transform.origin
	motion.y = 0

	velocity = velocity.move_toward(motion * speed, accel  * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	print(velocity)
