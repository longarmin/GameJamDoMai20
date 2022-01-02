extends BewohnerState
class_name BeingInFlat


func respond_to(message: Message) -> Response:
	if message.iStatus == 7:
		sTargetState = "Idle"
		return Response.new(sTargetState, dParams)
	return null


func enter(_dParams: Dictionary) -> void:
	bewohner.hide()
	for b in bewohner.get_children():
		if b is Area2D:
			b.set_deferred("monitoring", false)


func exit() -> void:
	for b in bewohner.get_children():
		if b is Area2D:
			b.set_deferred("monitoring", true)
	bewohner.show()
