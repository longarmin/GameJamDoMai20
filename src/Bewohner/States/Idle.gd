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
			var up: bool = false
			if message.content == "up":
				up = true
			return {"sTargetState": "EnteringDoor", "dParams": {"up": up}}
		_:
			return {"sTargetState": "Idle", "dParams": {}}


func enter(_params):
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("idleTrash")
	else:
		bewohner.animationPlayer.play("idle")


func exit():
	pass
