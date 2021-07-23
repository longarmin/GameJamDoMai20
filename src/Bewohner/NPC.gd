extends KinematicBody2D
class_name NPC

const FLOOR_NORMAL := Vector2.UP
const NORMAL_SPEED := 50.0
const GRAVITY := 3000

export var speed := NORMAL_SPEED
var _velocity := Vector2.ZERO
var direction := Vector2(1, 0)

# DEBUGGING
onready var label: Label = $Label


func calculate_direction(_direction: Vector2) -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)


func calculate_move_velocity(
	linear_velocity: Vector2, current_direction: Vector2, current_speed: float
) -> Vector2:
	var out := linear_velocity
	out.x = current_speed * current_direction.x
	if ! is_on_floor():
		out.y += GRAVITY * get_physics_process_delta_time()
	else:
		out.y = 0
	return out


func _on_StateMachine_transitioned_to_state(new_state):
	label.text = "State: " + new_state.get_name()
