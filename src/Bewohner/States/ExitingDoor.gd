extends BewohnerState
class_name ExitingDoor


func respond_to(message: Message) -> Response:
	var response = Response.new()
	if message.status == 1:
		response.sTargetState = "Idle"
		response.dParams = {}
	return response


func enter(_dParams: Dictionary) -> void:
	bewohner.animationPlayer.play("exitingDoor")


func exit() -> void:
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "exitingDoor":
		var message = Message.new()
		message.status = 1
		message.content = "Animation stopp"
		message.emitter = "ExitingDoorState"
		state_machine.respond_to(message)
