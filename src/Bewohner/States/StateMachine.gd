extends Node
class_name StateMachine

export var inital_state := NodePath()
var current_state: State


func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	current_state = get_node(inital_state)
	current_state.enter({})


func _unhandled_input(event):
	current_state.handle_input(event)


func _physics_process(delta: float) -> void:
	current_state.update_physics(delta)


func transition_to(target_state_name: String, dParams: Dictionary):
	var next_state = get_state(target_state_name)

	if next_state != null:
		current_state.exit()
		current_state = next_state
		current_state.enter(dParams)
		return
	else:
		return


func respond_to(message: Message):
	var response = current_state.respond_to(message)
	if response:
		transition_to(response.sTargetState, response.dParams)


func get_state(state_name: String) -> State:
	if not has_node(state_name):
		return null
	var state: State = get_node(state_name)
	return state
