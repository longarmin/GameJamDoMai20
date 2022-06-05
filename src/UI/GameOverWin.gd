extends Node2D

var selected_menu = 0

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
	$ScoreLabel.text = "Your Score: " + "%0.0f" % GlobalVars.uScoreTime + " seconds"

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				get_tree().change_scene("res://src/UI/HallOfFame.tscn")
			1:
				get_tree().change_scene("res://src/UI/StartScreen.tscn")
	elif Input.is_action_just_pressed("ui_up"):
		if (selected_menu > 0):
			selected_menu = selected_menu - 1
		else:
			selected_menu = 1
		change_menu_color()
	elif Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 2
		change_menu_color()
