extends BewohnerBase
class_name Player


func _ready():
	sName = "Player"
	home = get_tree().get_nodes_in_group("flatsEmpty")[0]
	home.remove_from_group("flatsEmpty")
	home.add_to_group("flats")
	home.setText(sName)
	Events.emit_signal("new_game_started", self)


func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
		var message_params: Dictionary
		if Input.is_action_just_pressed("ui_up"):
			message_params["up"] = true
		else:
			message_params["up"] = false
		message_params["double"] = false
		var message = Message.new(4, "Treppen rauf oder runter", self, message_params)
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("action2"):
		var message = Message.new(2, "Actionbutton 2 gedrueckt", self)
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("action1"):
		var message = Message.new(3, "Actionbutton 1 gedrueckt", self)
		stateMachine.respond_to(message)

