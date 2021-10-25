extends BewohnerState
class_name Dropping


func respond_to(message: Message) -> Response:
	var response = Response.new()
	match message.status:
		1:
			response.sTargetState = "Idle"
			response.dParams = {}
		5:
			response.sTargetState = "Talking"
			var wait: int = int(message.content)
			response.dParams = {"wait": wait}
		_:
			pass
	return response


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
	var bOnDump = false
	if bewohner.aTrashBags.size() == 0:
		return
	var trash: Trash = bewohner.remove_trash_bag()
	if bewohner.bIsOnDump:
		if !bewohner.dump.store_trash(trash):
			bewohner.add_trash_bag(trash)
			return
		if bewohner.dump.is_in_group("dumps"):
			bOnDump = true
		bewohner._on_Hitbox_area_entered(bewohner.dump)
	else:
# warning-ignore:return_value_discarded
		trash.drop_down(bewohner.position)
	bewohner.fSpeed += bewohner.change_speed(bewohner.NORMAL_SPEED / 4)
	Events.emit_signal("trash_dropped", bewohner, bOnDump)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "dropping":
		var message = Message.new()
		message.status = 1
		message.content = "Animation stopp"
		message.emitter = "DroppingState"
		state_machine.respond_to(message)
