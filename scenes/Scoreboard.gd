extends CenterContainer

export var score_container_path: NodePath
onready var score_container := get_node(score_container_path)

onready var http: HTTPRequest = $ScoreRequest
onready var table = $VBoxContainer/ScoreTable
onready var username = $VBoxContainer/HBoxContainer/Username
onready var submit_btn = $VBoxContainer/HBoxContainer/Submit

const GAME_ID = "SNAKE_BEAT"
const URL = "https://kgd07w68ll.execute-api.eu-central-1.amazonaws.com/prod/score/" + GAME_ID + "/highscore"

var submitted = false
var submitting = false

func show():
	.show()
	_request_scores()
	submit_btn.disabled = true

func _request_scores():
	if http.request(URL) != OK:
		print("Failed to get scores")

func set_scores(scores):
	table.clear()
	
	for score in scores:
		var datetime = OS.get_datetime_from_unix_time(score.time)
		var datetime_str = "%s-%s-%s %s:%s" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute]
		table.add_row_label([score.score, score.user, datetime_str])
		
		if score_container.score >= score.score and not submitted:
			submit_btn.disabled = false


func _on_ScoreRequest_request_completed(result, response_code, headers, body: PoolByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Request was not successful")
		return
	
	var body_str = body.get_string_from_utf8()
	var data = JSON.parse(body_str)
	if typeof(data.result) == TYPE_ARRAY: # GET request should be an array
		set_scores(data.result)
	elif submitting:
		_request_scores() # reload after submitting new score
		username.text = ""
		submitted = true
		submitting = false


func _on_Submit_pressed():
	if not username.text or submitted:
		return
	
	var data = {
		'score': score_container.score,
		'user': username.text,
		'time': OS.get_unix_time()
	}
	if http.request(URL, [], true, HTTPClient.METHOD_POST, to_json(data)) == OK:
		submit_btn.disabled = true
		submitting = true
	else:
		print("Failed to submit score")
