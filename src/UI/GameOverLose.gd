extends Node2D

var selected_menu = 0

func change_menu_color():
	$ExitGame.color = Color.greenyellow
	match GlobalVars.sGameOverReason:
		"NothingYet":
			$Label.text = "We feel very sorry for you."
		"OthersWin":
			$Label.text = "Another tenant has obtained grandmother's grace."
		"PlayerKarmaAtButtom":
			$Label.text = "Your messiness drove grandmother into insanity."


func _ready():
	change_menu_color()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://src/UI/StartScreen.tscn")
