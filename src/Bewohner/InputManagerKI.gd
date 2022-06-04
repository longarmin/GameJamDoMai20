extends InputManager
class_name InputManagerKI

var target

func calculate_direction(position: Vector2) -> Vector2:
	if owner.eventManager.current_event:
		target = owner.eventManager.current_event.target
		if abs(owner.eventManager.current_event.target.position.x - position.x) < 5:
			owner.eventManager.remove_current_event()
			target = owner.home
	else:
		target = owner.home
	var fDir: float = 1
	if has_to_use_stairwell(position, target):
		if abs(STAIRWELLDOOR_POSX - position.x) < 10:
			emit_stairwell_message(position, target)
		if STAIRWELLDOOR_POSX != position.x:
			fDir = sign(STAIRWELLDOOR_POSX - position.x)
	else:
		fDir = sign(target.position.x - position.x)
	return Vector2(fDir, 1)


func has_to_use_stairwell(position: Vector2, target: Node2D) -> bool:
	var abs_delta_y = abs(position.y - target.position.y)
	if abs_delta_y <= MAX_Y_DELTA_ON_SAME_LEVEL:
		return false
	else:
		return true


func emit_stairwell_message(position: Vector2, target: Node2D) -> void:
	var message_params: Dictionary = {"up": false, "down": false, "double": false};
	if position.y > target.position.y:
		message_params["up"] = true
	if abs(position.y - target.position.y) > 150:
		message_params["double"] = true
	var message = Message.new(4, "Treppen steigen", self, message_params)
	owner.stateMachine.respond_to(message)
