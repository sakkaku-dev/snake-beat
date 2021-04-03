extends ColorRect

var toggled = false

func toggle():
	if toggled:
		self_modulate = Color.white
	else:
		self_modulate = Color.red
	toggled = !toggled
