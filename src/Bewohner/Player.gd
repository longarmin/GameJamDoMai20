extends Bewohner

export (PackedScene) var Muell

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var is_carrying_trash: bool = false
var is_near_trash: bool = false
var carried_trash: Node

signal collectTrash
signal dropTrash

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
	$Label.set_text(str(is_carrying_trash))
	
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
		set_collision_layer(9)
	if Input.is_action_just_pressed("ui_down"):
		set_collision_layer(10)

func drop_trash():
	if is_carrying_trash:
		if Input.is_action_just_pressed("ui_accept"):
			is_carrying_trash = !is_carrying_trash
			carried_trash.position = self.position
			carried_trash.show()
			carried_trash = null
			if collision_layer == 2:
				set_collision_layer(10)
			else:
				set_collision_layer(9)
			emit_signal("dropTrash")


func _on_Muell_collectedTrash(trash) -> void:
	is_carrying_trash = true
	carried_trash = trash
	print(carried_trash)
	if collision_layer == 10:
		set_collision_layer(2)
	else:
		set_collision_layer(1)
