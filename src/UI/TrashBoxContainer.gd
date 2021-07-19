extends HBoxContainer
class_name TrashBoxContainer 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var trash_full = preload("res://assets/muellIcon1.png")
var trash_empty = preload("res://assets/muellIcon2.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func update_trash(value: int):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = trash_full
		else:
			get_child(i).texture = trash_empty

