extends Node
class_name StateMachine

export var inital_state := NodePath()
var current_state: State

signal transitioned_to_state(new_state)


func _ready():
	current_state = get_node(inital_state)
	current_state.enter()


func _unhandled_input(event):
	current_state.handle_input(event)


func _physics_process(delta: float) -> void:
	current_state.update(delta)


func transition_to(target_state_name: String):
	var next_state = get_state(target_state_name)

	if next_state != null:
		current_state.exit()
		next_state.enter()
		current_state = next_state
		emit_signal("transitioned_to_state", current_state)
		return
	else:
		return


func respond_to(message: Message):
	var state_answer = current_state.respond_to(message)
	transition_to(state_answer)


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
