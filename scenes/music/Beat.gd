extends TextureRect

var speed = 0
var destination = 0

func _physics_process(delta):
	rect_position.x += speed * delta
	
	if rect_position.x >= destination:
		queue_free()
