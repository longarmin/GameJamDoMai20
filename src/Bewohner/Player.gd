extends Bewohner


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var is_carrying_trash: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:
	
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	change_layer()
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	if !is_on_floor():
		out.y += gravity * get_physics_process_delta_time()
	else:
		out.y = 0
	return out

func change_layer():
	if Input.is_action_pressed("ui_up"):
		set_collision_layer(4)
	if Input.is_action_just_pressed("ui_down"):
		set_collision_layer(1)

func collect_trash():
	if !is_carrying_trash:
		if Input.is_action_just_pressed("ui_accept"):
