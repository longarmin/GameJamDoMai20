extends Node2D

signal DoorCollision

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Oma':
		emit_signal("DoorCollision")
	pass # Replace with function body.
