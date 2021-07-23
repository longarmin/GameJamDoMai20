extends BewohnerState
class_name Dropping


func respond_to(message: Message) -> String:
	if message.status == 1:
		return "Idle"
	return ""


func enter() -> void:
	if bewohner.carrying_trash:
		bewohner.animationPlayer.connect(
			"animation_finished", self, " _on_AnimationPlayer_animation_finished"
		)
		bewohner.animationPlayer.play("dropping")
	else:
		pass


func exit() -> void:
	print("Trash gedroppt")
	bewohner.carrying_trash = false
	# Bewohner-TrashAmount updaten + Signal fuer UI
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "dropping":
		var message = Message.new()
		message.status = 1
		message.content = "Animation stopp"
		message.emitter = "DroppingState"
		get_machine().respond_to(message)
