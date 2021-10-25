extends BewohnerState
class_name ExitingDoor


func respond_to(message: Message) -> Response:
	if message.iStatus == 1:
		sTargetState = "Idle"
	return Response.new(sTargetState, dParams)


func enter(_dParams: Dictionary) -> void:
	bewohner.animationPlayer.play("exitingDoor")


func exit() -> void:
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "exitingDoor":
		var message = Message.new(1, "Animation stopp", self)
		state_machine.respond_to(message)
