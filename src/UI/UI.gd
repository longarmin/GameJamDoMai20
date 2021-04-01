extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var label: Label = $MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Player_trash_collected(trash_amount) -> void:
	label.text = "Müll: " + str(trash_amount)


func _on_Player_trash_dropped(trash_amount) -> void:
	label.text = "Müll: " + str(trash_amount)