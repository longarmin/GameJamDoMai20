extends BewohnerState
class_name Idle


func update_physics(_delta: float) -> void:
	if bewohner.calculate_direction(bewohner.vDirection).x != 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit ungleich 0"
		message.emitter = "IdleState"
		state_machine.respond_to(message)


func respond_to(message: Message) -> Response:
	var response  = Response.new()
	match message.status:
		1:
			response.sTargetState = "Running"
			response.dParams = {}
		2:
			response.sTargetState = "Dropping"
			response.dParams = {}
		3:
			response.sTargetState = "Picking"
			response.dParams = {}
		4:
			response.sTargetState = "Running"
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


func enter(_params):
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("idleTrash")
	else:
		bewohner.animationPlayer.play("idle")


func exit():
	pass
