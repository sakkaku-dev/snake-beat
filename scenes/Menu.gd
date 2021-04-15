extends CenterContainer

export var music_beat_path: NodePath
onready var music_beat := get_node(music_beat_path)

onready var main_menu := $Main
onready var options := $Options
onready var vol_slider := $Options/GridContainer/MasterVolume

var master_id
var vol_range = 60
var vol_offset = 5

func _ready():
	master_id = AudioServer.get_bus_index("Master")
	vol_slider.value = get_volume_percentage()

func show():
	.show()
	show_menu(main_menu)

func show_menu(menu):
	for m in get_children():
		m.hide()
	menu.show()
	music_beat.audio_player.stop()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		show()


func get_volume_percentage():
	var volume = AudioServer.get_bus_volume_db(master_id)
	return (volume - vol_offset + vol_range) * 100 / vol_range # Just reversed the equation of #get_volume


func get_volume(percentage: float) -> float:
	var vol_value = -vol_range + (vol_range * percentage / 100) # Volume from -vol_range to 0
	vol_value += vol_offset
	return vol_value


func _on_MasterVolume_value_changed(value: float):
	if value == 0:
		AudioServer.set_bus_mute(master_id, true)
	else:
		AudioServer.set_bus_mute(master_id, false)
		AudioServer.set_bus_volume_db(master_id, get_volume(value))


func _on_Options_pressed():
	music_beat.audio_player.play()
	show_menu(options)
