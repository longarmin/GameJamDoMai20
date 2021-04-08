extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var UpSprite: AnimatedSprite = $UpSprite
onready var DownSprite: AnimatedSprite = $DownSprite
var onStairs = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ContextBubble_area_entered(area: Area2D) -> void:
	if area is Stairwell:
		if get_global_position()[1] > 150:
			UpSprite.visible = true
		else:
			UpSprite.visible = false
		if get_global_position()[1] < 250:
			DownSprite.visible = true
		else:
			DownSprite.visible = false


func _on_ContextBubble_area_exited(area: Area2D) -> void:
	if area is Stairwell && ! onStairs:
		UpSprite.visible = false
		DownSprite.visible = false


func _on_Player_stairs_climbed():
	onStairs = false


func _on_Player_stairs_climbing():
	onStairs = true
