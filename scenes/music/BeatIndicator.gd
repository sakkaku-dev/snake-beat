extends CenterContainer

export var beat_texture: Texture

export var distance_per_sec = 200

export var music_beat_path: NodePath
onready var music_beat: MusicBeat = get_node(music_beat_path)

onready var beats = $Beats
onready var beat_circle = $AnimationPlayer

var beat_scene = preload("res://scenes/music/Beat.tscn")

func _ready():
	music_beat.connect("beat", self, "add_beat")

func add_beat() -> void:
	var beat = beat_scene.instance()
	var x_pos = distance_per_sec * music_beat.secPerBeat
	beat.destination = beat.rect_position.x + x_pos
	beat.rect_position.x -= x_pos

	var speed = x_pos / music_beat.secPerBeat
	beat.speed = speed

	beats.add_child(beat)
	

func hit_beat():
	print("Hit")
	beat_circle.play("Hit")
	
	
func miss_beat():
	print("Miss")
	beat_circle.play("Miss")

