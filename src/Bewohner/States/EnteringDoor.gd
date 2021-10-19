extends BewohnerState
class_name EnteringDoor

var up: bool = false
var double: bool = false


func respond_to(message: Message) -> Dictionary:
	if message.status == 1:
		return {"sTargetState": "Idle", "dParams": {}}
	if message.status == 2:
		return {"sTargetState": "ChangingFloor", "dParams": {"up": up, "double": double}}
	return {}


func enter(dParams: Dictionary) -> void:
	if bewohner.bIsOnDoor:
		up = dParams.up
		double = dParams.double
		if (up && bewohner.position.y > 150) || (!up && bewohner.position.y < 250):
			bewohner.animationPlayer.play("enteringDoor")
		else:
			var message = Message.new()
			message.status = 1
			message.content = "Zu hoch oder zu tief"
			message.emitter = "EnteringDoorState"
			print(message.content)
			state_machine.respond_to(message)
	else:
		var message = Message.new()
		message.status = 1
		message.content = "Keine Tuer"
		message.emitter = "EnteringDoorState"
		state_machine.respond_to(message)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "enteringDoor":
		var message = Message.new()
		message.status = 2
		message.content = "Animation stopp"
		message.emitter = "EnteringDoorState"
		state_machine.respond_to(message)
