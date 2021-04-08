extends HBoxContainer
class_name ButtonBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dropButton: AnimatedSprite = $DropButton
onready var pickupButton: AnimatedSprite = $PickupButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func update_trash_dropable(dropable: bool) -> void:
	if dropable:
		dropButton.play("action")
	else:
		dropButton.play("default")


func update_trash_pickable(pickable: bool) -> void:
	if pickable:
		pickupButton.play("action")
	else:
		pickupButton.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
