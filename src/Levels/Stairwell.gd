extends Area2D
class_name Stairwell

onready var animated_sprite: AnimatedSprite = $AnimatedSprite


func _ready():
	pass  # Replace with function body.


func _on_Stairwell_body_entered(_body: Node) -> void:
	animated_sprite.play("opening")


func _on_Stairwell_body_exited(_body: Node) -> void:
	animated_sprite.play("closing")
