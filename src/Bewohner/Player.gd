extends BewohnerBase
class_name Player


func _ready():
	sName = "Player"


func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("action2"):
		var message = Message.new()
		message.status = 2
		message.content = "Actionbutton 2 gedrueckt"
		message.emitter = "Player"
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("action1"):
		var message = Message.new()
		message.status = 3
		message.content = "Actionbutton 1 gedrueckt"
		message.emitter = "Player"
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
		var message = Message.new()
		message.status = 4
		if Input.is_action_just_pressed("ui_up"):
			message.params["up"] = true
		else:
			message.params["up"] = false
		message.params["double"] = false
		message.emitter = "Player"
		stateMachine.respond_to(message)


func calculate_direction(_direction: Vector2) -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)
