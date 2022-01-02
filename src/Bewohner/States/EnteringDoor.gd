extends BewohnerState
class_name EnteringDoor

var up: bool = false
var double: bool = false


func respond_to(message: Message) -> Response:
	if message.iStatus == 1:
		sTargetState = "Idle"
		return Response.new(sTargetState, dParams)
	if message.iStatus == 2:
		sTargetState = "ChangingFloor"
		dParams = {"up": up, "double": double}
		return Response.new(sTargetState, dParams)
	return null


func enter(dParams: Dictionary) -> void:
	if bewohner.bIsOnDoor:
		up = dParams.up
		double = dParams.double
		if (up && bewohner.position.y > 150) || (!up && bewohner.position.y < 250):
			bewohner.animationPlayer.play("enteringDoor")
		else:
			var message = Message.new(1, "Zu hoch oder zu tief", self)
			state_machine.respond_to(message)
	else:
		var message = Message.new(1, "Keine Tuer", self)
		state_machine.respond_to(message)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "enteringDoor":
		var message = Message.new(2, "Animation stopp", self)
		state_machine.respond_to(message)
