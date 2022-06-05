extends Node2D

onready var selected_menu = 0
onready var lineedit: LineEdit = $LineEdit
var highscoreList: Array

func change_menu_color():
	$EnterScore.color = Color.gray
	$ExitGame.color = Color.gray

	match selected_menu:
		0:
			$EnterScore.color = Color.greenyellow
		1:
			$ExitGame.color = Color.greenyellow


func _ready():
	change_menu_color()
	$ScoreLabel.text = "Your Score: " + str(GlobalVars.uScoreTime) + " seconds"
	$HTTPRequest.request("https://omashighscore.herokuapp.com/halloffame")


func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu -= 1
		else:
			selected_menu = 1
		change_menu_color()
	elif Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 2
		change_menu_color()
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				var score = {"name": lineedit.text, "score": GlobalVars.uScoreTime}
				var query = JSON.print(score)
				var headers = ["Content-Type: application/json"]
				$HTTPRequest.request("https://omashighscore.herokuapp.com/halloffame", headers, true, HTTPClient.METHOD_POST, query)
			1:
				get_tree().change_scene("res://src/UI/StartScreen.tscn")


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var aJson = JSON.parse(body.get_string_from_utf8())
	print(str(typeof(aJson.result)))
	#if typeof(aJson) == "Array("
	for score in aJson.result:
		highscoreList.append(score)
	print(highscoreList)
