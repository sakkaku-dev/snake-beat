extends CenterContainer

onready var score_table := $VBoxContainer/ScoreTable

func show_scoreboard(new_score):
	score_table.score = new_score
	show()

func show():
	.show()
	score_table.load_scores()
