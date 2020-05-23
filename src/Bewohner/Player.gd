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
	speed = Vector2(300.0, 1000.0)


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
	playing_animation()

	$Label.set_text(str(on_stairs))
	
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
	if (Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")) && on_stairs:
		self.set_collision_layer(10)
	elif !on_stairs:
		self.set_collision_layer(9)

func collect_trash():
	if near_trash.size() > 0 && Input.is_action_just_pressed("action1"):
		var trash = near_trash[0]
		trash.hide()
		carrying_trash = true
		carried_trash.push_back(trash)
		near_trash.erase(trash)
		speed.x -= 30
		$CollectTrash.text = "Müll ablegen mit X"
		emit_signal("trash_collected", carried_trash.size())

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
			emit_signal("trash_dropped", carried_trash.size())

func playing_animation():
	if _velocity.x > 0:
		if carrying_trash:
			$AnimatedSprite.play("walkingTrash")
		else:
			$AnimatedSprite.play("walking")
		$AnimatedSprite.flip_h = false
	elif _velocity.x < 0:
		if carrying_trash:
			$AnimatedSprite.play("walkingTrash")
		else:
			$AnimatedSprite.play("walking")
		$AnimatedSprite.flip_h = true
	else:
		if carrying_trash:
			$AnimatedSprite.play("defaultTrash")
		else:
			$AnimatedSprite.play("default")

func _on_Muell_player_entered(trash) -> void:
	near_trash.push_back(trash)
	if carrying_trash == false:
		$CollectTrash.text = "Müll aufsammeln mit Y"
	
func _on_Muell_player_exited(trash) -> void:
	near_trash.erase(trash)
	if carrying_trash == false:
		$CollectTrash.text = ""

func _on_Area2D_body_entered(body: Node) -> void:
	if body == self:
		on_stairs = true

func _on_Area2D_body_exited(body: Node) -> void:
	if body == self:
		on_stairs = false

func _on_Area2D2_body_entered(body: Node) -> void:
	if body == self:
		on_stairs = true

func _on_Area2D2_body_exited(body: Node) -> void:
	if body == self:
		on_stairs = false


