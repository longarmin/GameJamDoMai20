extends BewohnerState
class_name Running


func update_physics(_delta: float) -> void:
	bewohner.vDirection = bewohner.calculate_direction(bewohner.vDirection)
	if bewohner.vDirection.x < 0:
		bewohner.sprite.flip_h = true
	elif bewohner.vDirection.x > 0:
		bewohner.sprite.flip_h = false
	var velocity = bewohner.calculate_move_velocity(
		bewohner.vVelocity, bewohner.vDirection, bewohner.fSpeed
	)
	bewohner.vVelocity = bewohner.move_and_slide(velocity, bewohner.FLOOR_NORMAL)
	if velocity.x == 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit 0"
		message.emitter = "RunningState"
		state_machine.respond_to(message)


func handle_input(_event) -> void:
	pass


func respond_to(message: Message) -> Response:
	var response = Response.new()
	match message.status:
		1:
			response.sTargetState = "Idle"
			response.dParams = {}
		2:
			response.sTargetState = "Dropping"
			response.dParams = {}
		3:
			response.sTargetState = "Picking"
			response.dParams = {}
		4:
			response.sTargetState = "EnteringDoor"
			var up: bool = message.params["up"]
			var double: bool = message.params["double"]
			response.dParams = {"up": up, "double": double}
		5:
			response.sTargetState = "Talking"
			var wait: int = int(message.content)
			response.dParams = {"wait": wait}
		6:
			response.sTargetState = "BeingInFlat"
			response.dParams = {}
		_:
			pass
	return response


func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("runningTrash")
	else:
		bewohner.animationPlayer.play("running")
	bewohner.animationPlayer.playback_speed = bewohner.fSpeed * 0.008


func exit() -> void:
	pass
