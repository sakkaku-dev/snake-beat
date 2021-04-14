extends Control

onready var score_label = $HBoxContainer/Score
onready var multiplier_label = $HBoxContainer/MarginContainer/Multiplier
onready var tween = $Tween

var score = 0 setget set_score
var multiplier = 1 setget set_multiplier

func _ready():
	self.score = 0
	self.multiplier = 1

func set_multiplier(value):
	if multiplier == value: return
	
	multiplier = value
	multiplier_label.text = str(multiplier) + "x"
	
	var final_scale = min(1 + multiplier / 10.0, 2)
	var start_scale = rect_scale / (1 + final_scale / 10)
	
	tween.interpolate_property(self, "rect_scale", start_scale, Vector2(final_scale, final_scale), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()


func set_score(value):
	score = value
	score_label.text = str(score)


func increase_score():
	self.score += 1 * multiplier
	self.multiplier += 1


func lose_combo():
	self.multiplier = 1
