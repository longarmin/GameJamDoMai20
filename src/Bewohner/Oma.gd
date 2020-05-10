extends Bewohner

var direction: = Vector2(-1,0)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)
	_velocity.x = speed.x
#	change_direction()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:	
	if is_on_wall():	
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	_velocity.y += gravity * delta
#	_velocity = calculate_move_velocity(_velocity, direction, speed)
#	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var out: = linear_velocity
	if !is_on_floor():
		out.y += gravity * get_physics_process_delta_time()
	else:
		out.y = 0
	if is_on_wall():	
		change_direction()
#	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
#	_velocity.y += gravity * delta
	out.x = speed.x * direction.x
	return out

func change_layer():
#	set_collision_layer(9) if collision_layer == 10 else set_collision_layer(10)
	pass
	
func change_direction():
#	direction = Vector2(rand_range(-1,1), 0)
	direction.x *= -1.0

func _on_Timer_timeout() -> void:
	change_direction()
	change_layer()
