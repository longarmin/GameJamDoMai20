extends Bewohner
class_name BewohnerNPC


var direction:= Vector2(1,0)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)
	_velocity.x = speed.x
#	change_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(_delta: float) -> void:	

#	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
#	_velocity.y += gravity * delta
	_velocity = calculate_move_velocity(_velocity, speed)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	sprite_flip_direction()
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.name != "TileMapL2" && collision.collider.name != "TileMap":
#			print("Collided with: ", collision.collider.name)
	
func sprite_flip_direction():
	if direction.x < 0:
		($Sprite as Sprite).flip_h = true
	else:
		($Sprite as Sprite).flip_h = false
	
func calculate_move_velocity(
		linear_velocity: Vector2,
		speed: Vector2
	) -> Vector2:
	var out: = linear_velocity
	if !is_on_floor():
		out.y += gravity * get_physics_process_delta_time()
	else:
		out.y = 0
	if is_on_wall():	
		change_direction()
	out.x = speed.x * direction.x
	return out

func change_direction():
	direction.x *= -1.0

		
#func _on_Timer_timeout() -> void:
#	change_direction()
#	change_layer()
	
func _on_Wohnungstuer_DoorCollision() -> void:
	var l = self.get_collision_layer()
	print("Door Collision! Layer: " + str(l))
	if l == 1:
		self.set_collision_layer(2)
	else:
		self.set_collision_layer(1)
	print("New Layer: " + str(l))
