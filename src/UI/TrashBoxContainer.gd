extends HBoxContainer
class_name TrashBoxContainer 

var trash_full = preload("res://assets/trashIcon1.png")
var trash_empty = preload("res://assets/trashIcon2.png")


func _ready():
	pass


func update_trash(value: int):
	for i in get_child_count():
		if value > i:
# warning-ignore:unsafe_property_access
			get_child(i).texture = trash_full
		else:
# warning-ignore:unsafe_property_access
			get_child(i).texture = trash_empty

