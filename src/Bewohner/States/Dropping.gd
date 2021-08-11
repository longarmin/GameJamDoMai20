extends BewohnerState
class_name Dropping

signal trash_dropped


func respond_to(message: Message) -> Dictionary:
	if message.status == 1:
		return {"sTargetState": "Idle", "dParams": {}}
	return {}


func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags.size() > 0:
		bewohner.animationPlayer.play("dropping")
	else:
		var message = Message.new()
		message.status = 1
		message.content = "Keinen Trash"
		message.emitter = "DroppingState"
		state_machine.respond_to(message)


func exit() -> void:
	if bewohner.aTrashBags.size() == 0:
		return
	var trash: Trash = bewohner.aTrashBags.pop_back()
	if bewohner.bIsOnDump:
		if ! bewohner.dump.store_trash(trash):
			bewohner.aTrashBags.append(trash)
			return
		bewohner._on_Hitbox_area_entered(bewohner.dump)
	else:
		trash.drop_down(bewohner.position)
	bewohner.fSpeed += bewohner.change_speed(bewohner.NORMAL_SPEED / 4)
	emit_signal("trash_dropped", bewohner.aTrashBags.size(), bewohner.position)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "dropping":
		var message = Message.new()
		message.status = 1
		message.content = "Animation stopp"
		message.emitter = "DroppingState"
		state_machine.respond_to(message)
