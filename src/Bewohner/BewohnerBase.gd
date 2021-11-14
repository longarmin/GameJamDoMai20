extends Bewohner
class_name BewohnerBase

var bIsOnDump := false
var bIsOnTrash := false
var dump: Dump
var aTrashesNear: Array

signal trash_pickable
signal trash_notPickable
signal trash_dropable
signal trash_notDropable


func _ready():
	pass


func add_trash_bag(trashBag: Trash) -> void:
	aTrashBags.push_front(trashBag)
# warning-ignore:return_value_discarded
	has_trash_bags()


func remove_trash_bag() -> Trash:
	var trash: Trash = aTrashBags.pop_back()
# warning-ignore:return_value_discarded
	has_trash_bags()
	return trash


func has_trash_bags() -> bool:
	if aTrashBags.size() == 0:
		emit_signal("trash_notDropable")
		return false
	else:
		emit_signal("trash_dropable")
		return true


# Hitbox-Detector
# Schaut auch, ob Muell aufgenommen oder abgelegt werden kann.
# Wirkt etwas fehl am Platz.


func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("store_trash"):
		bIsOnDump = false
		dump = null
		emit_signal("trash_notPickable")
	if area.has_method("pick_up"):
		fSpeed += change_speed(NORMAL_SPEED / 4)
		aTrashesNear.erase(area)
		if aTrashesNear.size() == 0:
			bIsOnTrash = false
			emit_signal("trash_notPickable")
			if !stateMachine.current_state.name == "Idle":
				Events.emit_signal("neighbour_passed_trash", self)
	if area.has_method("use_stairwell"):
		bIsOnDoor = false
		door = null


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("store_trash"):
		bIsOnDump = true
		dump = area
		if dump.has_trash():
			emit_signal("trash_pickable")
			emit_signal("trash_notDropable")
		else:
			emit_signal("trash_notPickable")
	if area.has_method("pick_up"):
		fSpeed -= change_speed(NORMAL_SPEED / 4)
		bIsOnTrash = true
		aTrashesNear.push_front(area)
		emit_signal("trash_pickable")
	if area.has_method("use_stairwell"):
		bIsOnDoor = true
		door = area
