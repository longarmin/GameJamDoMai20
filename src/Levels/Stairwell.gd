extends Area2D
class_name Stairwell

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Stairwell_body_entered(_body):
	animated_sprite.play("opening")

func _on_Stairwell_body_exited(_body):
	animated_sprite.play("closing")
