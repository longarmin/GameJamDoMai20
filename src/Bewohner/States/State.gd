extends Node
class_name State

var state_machine = null
var sTargetState: String = ""
var dParams: Dictionary = {}


func update(_delta: float) -> void:
	pass


func update_physics(_delta: float) -> void:
	pass


func handle_input(_event) -> void:
	pass


func respond_to(_message: Message) -> Response:
	var response = Response.new(sTargetState, dParams)
	return response


func enter(_dParams: Dictionary) -> void:
	pass


func exit():
	pass

	# Create Message function
