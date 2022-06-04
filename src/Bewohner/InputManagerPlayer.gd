extends InputManager
class_name InputManagerPlayer

func calculate_direction(_position: Vector2) -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)
