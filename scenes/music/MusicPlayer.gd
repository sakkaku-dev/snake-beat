extends AudioStreamPlayer

class_name MusicPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_song_position():
	return get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
