extends BewohnerState
class_name Running


func update_physics(_delta: float) -> void:
	var direction = bewohner.calculate_direction(bewohner.vNPCDirection)
	var velocity = bewohner.calculate_move_velocity(
		bewohner.vNPCVelocity, direction, bewohner.fSpeed
	)
	bewohner.vNPCVelocity = bewohner.move_and_slide(velocity, bewohner.FLOOR_NORMAL)
	if velocity.x == 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit 0"
		message.emitter = "RunningState"
		state_machine.respond_to(message)


func handle_input(_event) -> void:
	pass


func respond_to(message: Message) -> String:
	if message.status == 1:
		return "Idle"
	return ""


func enter() -> void:
	pass


func exit() -> void:
	pass
