extends BewohnerBase
class_name Player


func _ready():
	sName = "Player"


func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("action2"):
		var message = Message.new(2, "Actionbutton 2 gedrueckt", self)
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("action1"):
		var message = Message.new(3, "Actionbutton 1 gedrueckt", self)
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
		var message_params: Dictionary
		if Input.is_action_just_pressed("ui_up"):
			message_params["up"] = true
		else:
			message_params["up"] = false
		message_params["double"] = false
		var message = Message.new(4, "Treppen rauf oder runter", self, message_params)
		stateMachine.respond_to(message)


func calculate_direction(_direction: Vector2) -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)
