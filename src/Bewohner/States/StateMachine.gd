extends Node
class_name StateMachine

export var inital_state := NodePath()
var current_state: State

signal transitioned_to_state(new_state)


func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	current_state = get_node(inital_state)
	emit_signal("transitioned_to_state", current_state)
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
		emit_signal("transitioned_to_state", current_state)
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


func _on_Timer_timeout():
	var message = Message.new()
	message.status = 1
	message.content = "Timer aus"
	message.emitter = "StateMachine"
	respond_to(message)
