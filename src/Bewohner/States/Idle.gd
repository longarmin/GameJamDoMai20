extends BewohnerState
class_name Idle


func update_physics(_delta: float) -> void:
	if bewohner.calculate_direction(bewohner.vDirection).x != 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit ungleich 0"
		message.emitter = "IdleState"
		state_machine.respond_to(message)


func respond_to(message: Message) -> Dictionary:
	match message.status:
		1:
			return {"sTargetState": "Running", "dParams": {}}
		2:
			return {"sTargetState": "Dropping", "dParams": {}}
		3:
			return {"sTargetState": "Picking", "dParams": {}}
		4:
			var up: bool = message.params["up"]
			var double: bool = message.params["double"]
			return {"sTargetState": "EnteringDoor", "dParams": {"up": up, "double": double}}
		5:
			var wait: int = int(message.content)
			return {"sTargetState": "Talking", "dParams": {"wait": wait}}
		6:
			return {"sTargetState": "BeingInFlat", "dParams": {}}
		_:
			return {"sTargetState": "Idle", "dParams": {}}


func enter(_params):
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("idleTrash")
	else:
		bewohner.animationPlayer.play("idle")


func exit():
	pass
