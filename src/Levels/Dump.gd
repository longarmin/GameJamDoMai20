extends Area2D
class_name Dump

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var aTrashBags := []
var object_type: String = "Dump"
export var maximumTrashAmount := 5

onready var animationPlayer: AnimationPlayer = $Sprite/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	update_fuellstand()


func store_trash(trash: Trash) -> bool:
	if !is_full():
		aTrashBags.append(trash)
		update_fuellstand()
		return true
	else:
		return false


func retrieve_trash() -> Trash:
	var trash = aTrashBags.pop_back()
	update_fuellstand()
	return trash


func get_trashFuellstand() -> int:
	return aTrashBags.size()


func has_trash() -> bool:
	if aTrashBags.size() > 0:
		return true
	else:
		return false


func update_fuellstand() -> void:
	var fuellstand = get_trashFuellstand()
	match fuellstand:
		0:
			animationPlayer.play("none")
		1:
			animationPlayer.play("low")
		2, 3:
			animationPlayer.play("mid")
		4, 5:
			animationPlayer.play("high")
		_:
			animationPlayer.play("none")


func is_full() -> bool:
	if aTrashBags.size() < maximumTrashAmount:
		return false
	else:
		return true


func remove_trash() -> void:
	for trash in aTrashBags:
		trash.queue_free()
	aTrashBags = []
	update_fuellstand()


func _on_Muellabfuhr_timeout():
	remove_trash()
