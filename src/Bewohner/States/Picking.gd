extends BewohnerState
class_name Picking

var trashToPickup: Trash

signal trash_collected


func respond_to(message: Message) -> Dictionary:
	if message.status == 1:
		return {"sTargetState": "Idle", "dParams": {}}
	return {}


func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags.size() < bewohner.iMaxTrashAmount && bewohner.bIsOnTrash:
		trashToPickup = bewohner.trashes[0]
		bewohner.animationPlayer.play("picking")
	else:
		var message = Message.new()
		message.status = 1
		message.content = "Zu viel Trash oder kein Trash vorhanden"
		message.emitter = "PickingState"
		state_machine.respond_to(message)


func exit() -> void:
	if ! bewohner.bIsOnTrash:
		return
	bewohner.aTrashBags.push_front(trashToPickup)
# warning-ignore:return_value_discarded
	trashToPickup.pick_up()
	bewohner.trashes.erase(trashToPickup)
	bewohner.fSpeed -= bewohner.change_speed(bewohner.NORMAL_SPEED / 4)
	emit_signal("trash_collected", bewohner.aTrashBags.size(), bewohner.position)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "picking":
		var message = Message.new()
		message.status = 1
		message.content = "Animation stopp"
		message.emitter = "PickingState"
		state_machine.respond_to(message)
