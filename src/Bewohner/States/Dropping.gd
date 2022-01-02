extends BewohnerState
class_name Dropping

	
func enter(_dParams: Dictionary) -> void:
	if bewohner.aTrashBags.size() > 0:
		bewohner.animationPlayer.play("dropping")
	else:
		var message = Message.new(1, "Keinen Trash", self)
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
			
			
func handle_input(_event) -> void:
	pass
				

func respond_to(message: Message) -> Response:
	match message.iStatus:
		1:
			sTargetState = "Idle"
		5:
			sTargetState = "Talking"
			var wait: int = int(message.sContent)
			dParams = {"wait": wait}
		_:
			pass
	return Response.new(sTargetState, dParams)

func update_physics(_delta: float) -> void:
	pass

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "dropping":
		var message = Message.new(1, "Animation stopp", self)
		state_machine.respond_to(message)
