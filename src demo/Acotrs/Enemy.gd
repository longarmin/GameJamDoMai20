extends "res://src/Acotrs/Actor.gd"

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	_velocity.y = 0.0

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	$CollisionShape2D.disabled = true
	queue_free()


func _physics_process(delta: float) -> void:
	if is_on_wall():	
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	_velocity.y += gravity * delta

