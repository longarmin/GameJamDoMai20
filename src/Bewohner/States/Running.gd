extends BewohnerState
class_name Running



func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("runningTrash")
	else:
		bewohner.animationPlayer.play("running")
		bewohner.animationPlayer.playback_speed = bewohner.fSpeed * 0.008
	pass
		
		
func exit() -> void:
	bewohner.animationPlayer.stop()


func handle_input(_event) -> void:
	pass


func update_physics(_delta: float) -> void:
	bewohner.vDirection = bewohner.inputManager.calculate_direction(bewohner.position)
	if bewohner.vDirection.x < 0:
		bewohner.sprite.flip_h = true
	elif bewohner.vDirection.x > 0:
		bewohner.sprite.flip_h = false
	var velocity: Vector2 = Vector2(bewohner.fSpeed * bewohner.vDirection.x, 1)
	bewohner.vVelocity = bewohner.move_and_slide(velocity, bewohner.FLOOR_NORMAL)
	if velocity.x == 0:
		var message = Message.new(1, "Geschwindigkeit 0", self)
		state_machine.respond_to(message)


func respond_to(message: Message) -> Response:
	match message.iStatus:
		1:
			sTargetState = "Idle"
		2:
			sTargetState = "Dropping"
		3:
			sTargetState = "Picking"
		4:
			#todo: Was ist mit "down"?
			sTargetState = "EnteringDoor"
			var up: bool = message.dParams["up"]
			var double: bool = message.dParams["double"]
			dParams = {"up": up, "double": double}
		5:
			sTargetState = "Talking"
			var wait: int = int(message.sContent)
			dParams = {"wait": wait}
		6:
			sTargetState = "BeingInFlat"
		_:
			pass
	return Response.new(sTargetState, dParams)

		
