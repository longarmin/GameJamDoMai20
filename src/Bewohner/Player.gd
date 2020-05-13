extends Bewohner

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var carrying_trash: bool = false
var near_trash: Array
var carried_trash: Array

signal trash_collected
signal trash_dropped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:
	
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	change_layer()
	drop_trash()
	collect_trash()

	$Label.set_text(str(carrying_trash))
	
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
	if Input.is_action_just_pressed("ui_down"):
		if collision_layer == 10:
			set_collision_layer(9)
		elif collision_layer == 9:
			set_collision_layer(10)

func collect_trash():
	if near_trash.size() > 0 && Input.is_action_just_pressed("action1"):
		var trash = near_trash[0]
		trash.hide()
		carrying_trash = true
		carried_trash.push_back(trash)
		near_trash.erase(trash)
		speed.x -= 30

func drop_trash():
	if carrying_trash:
		if Input.is_action_just_pressed("action2"):
			var trash:Node = carried_trash.pop_back()
			if carried_trash.size() ==  0:
				carrying_trash = false
			trash.position = self.position
			trash.show()
			trash.startTimer()
			speed.x += 30
			if collision_layer == 2:
				set_collision_layer(10)
			else:
				set_collision_layer(9)
			emit_signal("dropTrash")

func _on_Muell_collectedTrash(trash) -> void:
	carrying_trash = true
	carried_trash.push_back(trash)
	speed.x -= 30

func _on_Muell_player_entered(trash) -> void:
	near_trash.push_back(trash)
	
func _on_Muell_player_exited(trash) -> void:
	near_trash.erase(trash)
