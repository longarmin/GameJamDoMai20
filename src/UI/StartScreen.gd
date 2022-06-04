extends Node2D

var selected_menu = 0

func change_menu_color():
	$NewGame.color = Color.gray
	$HallOfFame.color = Color.gray
	$ExitGame.color = Color.gray
	
	match selected_menu:
		0:
			$NewGame.color = Color.greenyellow
		1:
			$HallOfFame.color = Color.greenyellow
		2:
			$ExitGame.color = Color.greenyellow

func _ready():
	change_menu_color()

func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 3;
		change_menu_color()
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 2
		change_menu_color()
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				# New game
				get_tree().change_scene("res://src/Levels/Treppenhaus.tscn")
			1:
				# Load game
				pass
#				var next_level_resource = load("res://src/Levels/Treppenhaus.tscn");
#				var next_level = next_level_resource.instance()
#				next_level.load_saved_game = true
#				get_tree().root.call_deferred("add_child", next_level)
#				queue_free()
			2:
				# Quit game
				get_tree().quit()
