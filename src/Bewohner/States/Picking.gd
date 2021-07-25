extends BewohnerState
class_name Picking


func respond_to(message: Message) -> String:
	if message.status == 1:
		return "Idle"
	return ""


func enter() -> void:
	if bewohner.aTrashBags.size():
		bewohner.animationPlayer.play("dropping")
	else:
		var message = Message.new()
		message.status = 1
		message.content = "Keinen Trash"
		message.emitter = "DroppingState"
		state_machine.respond_to(message)


func exit() -> void:
	var trash: Trash = bewohner.aTrashBags.pop_back()
	if bewohner.bIsOnDump:
		if ! bewohner.dump.store_trash(trash):
			bewohner.aTrashBags.append(trash)
			return
	else:
		trash.position = bewohner.position
		trash.position.y -= 7
		trash.show()
	bewohner.fSpeed += bewohner.change_speed(bewohner.NORMAL_SPEED / 4)
	emit_signal("trash_dropped", bewohner.aTrashBags.size(), bewohner.position)
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "dropping":
		var message = Message.new()
		message.status = 1
		message.content = "Animation stopp"
		message.emitter = "DroppingState"
		state_machine.respond_to(message)
