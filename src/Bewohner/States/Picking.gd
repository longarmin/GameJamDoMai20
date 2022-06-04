extends BewohnerState
class_name Picking

var trashToPickup: Trash


func respond_to(message: Message) -> Response:
	if message.iStatus == 1:
		sTargetState = "Idle"
		return Response.new(sTargetState, dParams)
	else:
		return null


func enter(_dParams: Dictionary) -> void:
	if (
		(bewohner.aTrashBags.size() < bewohner.iMaxTrashAmount)
		&& (bewohner.bIsOnTrash || (bewohner.bIsOnDump && bewohner.dump.has_trash()))
	):
		if bewohner.bIsOnTrash:
			trashToPickup = bewohner.aTrashesNear[0]
		elif bewohner.dump.has_trash():
			trashToPickup = bewohner.dump.retrieve_trash()
		bewohner.animationPlayer.play("picking")
	else:
		trashToPickup = null
		var message = Message.new(1, "Zu viel Trash oder kein Trash vorhanden", self)
		state_machine.respond_to(message)


func exit() -> void:
	if !trashToPickup:
		return
	trashToPickup.pick_up()
	bewohner.add_trash_bag(trashToPickup)
# warning-ignore:return_value_discarded
	if bewohner.bIsOnDump:
		bewohner._on_Hitbox_area_entered(bewohner.dump)
	bewohner.aTrashesNear.erase(trashToPickup)
	bewohner.fSpeed -= bewohner.change_speed(bewohner.NORMAL_SPEED / 4)
	Events.emit_signal("trash_picked", bewohner)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "picking":
		var message = Message.new(1, "Animation stopp", self)
		state_machine.respond_to(message)
