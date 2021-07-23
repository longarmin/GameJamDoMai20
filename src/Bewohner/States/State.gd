extends Node
class_name State


func get_machine() -> Node:
	return get_parent()


func update(delta: float) -> void:
	pass


func handle_input(event) -> void:
	pass


func respond_to(message) -> String:
	return ""


func enter():
	pass


func exit():
	pass

	# Create Message function
