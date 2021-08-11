extends BewohnerState
class_name Running


func update_physics(_delta: float) -> void:
	bewohner.vDirection = bewohner.calculate_direction(bewohner.vDirection)
	if bewohner.vDirection.x < 0:
		bewohner.sprite.flip_h = true
	elif bewohner.vDirection.x > 0:
		bewohner.sprite.flip_h = false
	var velocity = bewohner.calculate_move_velocity(bewohner.vVelocity, bewohner.vDirection, bewohner.fSpeed)
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
	if message.status == 1:
		return {"sTargetState": "Idle", "dParams": {}}
	return {}


func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("runningTrash")
	else:
		bewohner.animationPlayer.play("running")


func exit() -> void:
	pass
