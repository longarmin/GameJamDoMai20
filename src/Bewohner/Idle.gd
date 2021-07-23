extends BewohnerState
class_name Idle


func update(_delta: float) -> void:
	if bewohner.calculate_direction(bewohner.direction).x != 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit ungleich 0"
		message.emitter = "IdleState"
		get_machine().respond_to(message)


func handle_input(event) -> void:
	pass


func respond_to(message: Message) -> String:
	if message.status == 1:
		return "Running"
	return ""


func enter():
	pass


func exit():
	pass
