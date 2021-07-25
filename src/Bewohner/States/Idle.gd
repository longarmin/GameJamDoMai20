extends BewohnerState
class_name Idle


func update_physics(_delta: float) -> void:
	if bewohner.calculate_direction(bewohner.vNPCDirection).x != 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit ungleich 0"
		message.emitter = "IdleState"
		state_machine.respond_to(message)


func handle_input(_event) -> void:
	if Input.is_action_pressed("action1"):
		var message = Message.new()
		message.status = 2
		message.content = "Actionbutton gedrueckt"
		message.emitter = "IdleState"
		state_machine.respond_to(message)


func respond_to(message: Message) -> String:
	if message.status == 1:
		return "Running"
	elif message.status == 2:
		return "Dropping"
	return ""


func enter():
	bewohner.animationPlayer.play("idle")


func exit():
	pass
