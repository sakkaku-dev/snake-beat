extends Area

signal eaten

onready var anim := $AnimationPlayer


func _ready():
	anim.play("Move")


func _on_Apple_body_entered(body):
	body.grow()
	emit_signal("eaten")
	queue_free()
