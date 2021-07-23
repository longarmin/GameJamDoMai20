extends BewohnerState
class_name Running


func update(delta: float) -> void:
	var direction = bewohner.calculate_direction(bewohner.direction)
	var velocity = bewohner.calculate_move_velocity(bewohner._velocity, direction, bewohner.speed)
	bewohner._velocity = bewohner.move_and_slide(velocity, bewohner.FLOOR_NORMAL)
	if velocity.x == 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit 0"
		message.emitter = "RunningState"
		get_machine().respond_to(message)


func handle_input(event) -> void:
	pass


func respond_to(message: Message) -> String:
	if message.status == 1:
		return "Idle"
	return ""


func enter() -> void:
	pass


func exit() -> void:
	pass
