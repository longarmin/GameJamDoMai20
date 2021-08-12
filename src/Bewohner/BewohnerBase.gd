extends KinematicBody2D
class_name BewohnerBase

const FLOOR_NORMAL := Vector2.UP
const NORMAL_SPEED := 50.0
const GRAVITY := 3000

export var fSpeed := NORMAL_SPEED
export var iMaxTrashAmount := 5
var vVelocity := Vector2.ZERO
var vDirection := Vector2(1, 0)
var bIsOnDump := false
var bIsOnDoor := false
var bIsOnTrash := false
var door: Stairwell
var dump: Dump
var aTrashesNear: Array
var aTrashBags: Array

signal trash_pickable
signal trash_notPickable
signal trash_dropable
signal trash_notDropable

onready var sprite: Sprite = $Sprite
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var stateMachine: StateMachine = $StateMachine


func _ready():
	pass


func calculate_direction(direction: Vector2) -> Vector2:
	return direction


func calculate_move_velocity(
	linear_velocity: Vector2, current_direction: Vector2, current_speed: float
) -> Vector2:
	var out := linear_velocity
	out.x = current_speed * current_direction.x
	if ! is_on_floor():
		out.y += GRAVITY * get_physics_process_delta_time()
	else:
		out.y = 0
	return out


func change_speed(fAmount := NORMAL_SPEED / 4) -> float:
	if fSpeed < fAmount:
		return 0.0
	else:
		return fAmount


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
