extends Area2D
class_name Stairwell

onready var animated_sprite: AnimatedSprite = $AnimatedSprite


func _ready():
	pass  # Replace with function body.


func _on_Stairwell_body_entered(_body: Node) -> void:
	animated_sprite.play("opening")


func _on_Stairwell_body_exited(_body: Node) -> void:
	animated_sprite.play("closing")


func use_stairwell(position: Vector2, up: bool) -> Vector2:
	var newPosition: Vector2 = position
	if ! up && position.y < 250:
		newPosition.y += 96
	elif position.y > 150:
		newPosition.y -= 96
	return newPosition
