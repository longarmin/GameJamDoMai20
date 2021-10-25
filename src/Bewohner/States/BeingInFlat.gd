extends BewohnerState
class_name BeingInFlat


func respond_to(message: Message) -> Response:
	var response = Response.new()
	if message.status == 7:
		response.sTargetState = "Idle"
		response.dParams = {}
	return response

func enter(_dParams: Dictionary) -> void:
	bewohner.hide()


func exit() -> void:
	bewohner.show()
