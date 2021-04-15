extends Node

class_name MusicBeat

signal beat

onready var audio_player = $AudioStreamPlayer

# beats per minute of a song
export var bpm: float = 60;

# the number of beats in each loop
export var beatsPerLoop: int = 16;

# the current beat
var prevBeat = -1

# the current position of the song (in seconds)
var songPosition;

# the current position of the song (in beats)
var songPosInBeats;

# the duration of a beat
var secPerBeat;

# how much time (in seconds) has passed since the song started
var dsptimesong;

# the total number of loops completed since the looping clip first started
var completedLoops = 0;

# The current position of the song within the loop in beats.
var loopPositionInBeats


func _ready():
	secPerBeat = 60 / bpm

func _process(delta):
	if not audio_player.is_playing(): return
	
	# calculate the position in seconds
	songPosition = audio_player.get_song_position()
	
	# calculate the position in beats
	songPosInBeats = songPosition / secPerBeat
	
	if (songPosInBeats >= (completedLoops + 1) * beatsPerLoop):
		completedLoops += 1
	loopPositionInBeats = floor(songPosInBeats - completedLoops * beatsPerLoop)
	
	if prevBeat != loopPositionInBeats:
		emit_signal("beat")
		prevBeat = loopPositionInBeats

func stop():
	audio_player.stop()

func play():
	audio_player.play()
