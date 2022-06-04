extends Popup

onready var player = get_node("/root/Level/Player")
var already_paused
var selected_menu
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_menu_color():
	$Resume.color = Color.gray
	$Restart.color = Color.gray
	$Quit.color = Color.gray
	
	match selected_menu:
		0:
			$Resume.color = Color.greenyellow
		1:
			$Restart.color = Color.greenyellow
		2:
			$Quit.color = Color.greenyellow
			
func _input(event):
	if not visible:
		if Input.is_action_just_pressed("menu"):
			# Pause game
			get_tree().paused = true
			# Reset the popup
			selected_menu = 0
			change_menu_color()
			# Show popup
			player.set_process_input(false)
			popup()
	else:
		if Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
		elif Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3
			change_menu_color()
		elif Input.is_action_just_pressed("ui_accept"):
			match selected_menu:
				0:
					#resume
					if not already_paused:
						get_tree().paused = false
					player.set_process_input(true)
					hide()
				1:
					#restart
					get_tree().change_scene("res://src/Levels/Treppenhaus.tscn")
					get_tree().paused = false
				2:
					#Quit
					get_tree().change_scene("res://src/UI/StartScreen.tscn")
					get_tree().paused = false
					


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
