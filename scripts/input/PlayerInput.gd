extends InputReader

"""
Input Reader for a single player
"""

class_name PlayerInput

var joypad_input = false
var device_id = 0

func _init(device = 0, joypad = false):
	self.device_id = device
	self.joypad_input = joypad


func is_player_event(event: InputEvent) -> bool:
	return joypad_input == _is_joypad_event(event) and device_id == event.device

	
func _is_joypad_event(event: InputEvent) -> bool:
	return event is InputEventJoypadButton or event is InputEventJoypadMotion


func get_motion() -> Vector2:
	return Vector2(
		get_action_strength("move_right") - get_action_strength("move_left"),
		get_action_strength("move_down") - get_action_strength("move_up")
	)


func handle_input(event: InputEvent) -> bool:
	if not is_player_event(event):
		return false
	
	.handle_input(event)
	return true


func _unhandled_input(event):
	handle_input(event)

