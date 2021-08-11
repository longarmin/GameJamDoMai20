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


func respond_to(message: Message) -> Dictionary:
	match message.status:
		1:
			return {"sTargetState": "Idle", "dParams": {}}
		2:
			return {"sTargetState": "Dropping", "dParams": {}}
		3:
			return {"sTargetState": "Picking", "dParams": {}}
		4:
			var up: bool = false
			if message.content == "up":
				up = true
			return {"sTargetState": "EnteringDoor", "dParams": {"up": up}}
		5:
			var wait: int = int(message.content)
			return {"sTargetState": "Talking", "dParams": {"wait": wait}}
		6:
			return {"sTargetState": "BeingInFlat", "dParams": {}}
		_:
			return {"sTargetState": "Running", "dParams": {}}


func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("runningTrash")
	else:
		bewohner.animationPlayer.play("running")


func exit() -> void:
	pass
