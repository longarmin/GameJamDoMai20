extends BewohnerState
class_name BeingInFlat


func respond_to(message: Message) -> Response:
	if message.iStatus == 7:
		sTargetState = "Idle"
	return Response.new(sTargetState, dParams)


func enter(_dParams: Dictionary) -> void:
	bewohner.hide()


func exit() -> void:
	bewohner.show()
