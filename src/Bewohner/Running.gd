extends State
class_name Running


func update(delta: float) -> void:
	# var velocity = owner.calculate_move_velocity(owner._velocity, owner.direction, owner.speed)
	var movement = owner.move_and_slide_with_snap(owner._velocity, owner.SNAP, owner.FLOOR_NORMAL)


func handle_input(event) -> void:
	pass


func respond_to(message: Message) -> String:
	return "Idle"


func enter():
	print("Bin am rennen")
	owner._velocity.x = 100
	print(owner._velocity)


func exit():
	print("Hoere auf zu rennen")
