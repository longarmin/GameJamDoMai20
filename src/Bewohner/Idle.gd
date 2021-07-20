extends State
class_name Idle


func update(delta: float) -> void:
	pass


func handle_input(event) -> void:
	pass


func respond_to(message: Message) -> String:
	return "Running"


func enter():
	print("Bin idle")


func exit():
	print("Bin nicht mehr idle")
