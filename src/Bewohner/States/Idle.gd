extends BewohnerState
class_name Idle


func update_physics(_delta: float) -> void:
	if bewohner.inputManager.calculate_direction(bewohner.position).x != 0:
		var message = Message.new(1, "Geschwindigkeit ungleich 0", self)
		state_machine.respond_to(message)


func respond_to(message: Message) -> Response:
	match message.iStatus:
		1:
			sTargetState = "Running"
		2:
			sTargetState = "Dropping"
		3:
			sTargetState = "Picking"
		4:
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


func enter(_params):
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("idleTrash")
	else:
		bewohner.animationPlayer.play("idle")


func exit():
	pass
