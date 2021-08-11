extends BewohnerState
class_name BeingInFlat


func respond_to(message: Message) -> Dictionary:
	if message.status == 7:
		return {"sTargetState": "Idle", "dParams": {}}
	return {}


func enter(_dParams: Dictionary) -> void:
	bewohner.hide()


func exit() -> void:
	bewohner.show()
