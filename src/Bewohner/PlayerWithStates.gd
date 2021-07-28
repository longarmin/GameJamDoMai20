extends KinematicBody2D
class_name PlayerWithStates
export (PackedScene) onready var Trash

const FLOOR_NORMAL := Vector2.UP
const NORMAL_SPEED := 50.0
const GRAVITY := 3000

export var fSpeed := NORMAL_SPEED
export var iMaxTrashAmount := 5
var vNPCVelocity := Vector2.ZERO
var vNPCDirection := Vector2(1, 0)
var bIsOnDump := false
var bIsOnDoor := false
var bIsOnTrash := false
var door: Stairwell
var dump: Dump
var trashes: Array
var aTrashBags: Array

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

signal trash_created(trash)

# DEBUGGING
onready var label: Label = $Label

func _ready():
	var trash: Trash = Trash.instance()
	yield(owner, "ready")
	emit_signal("trash_created", trash)
	aTrashBags = [trash]


func calculate_direction(_direction: Vector2) -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)


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


func _on_StateMachine_transitioned_to_state(new_state: State) -> void:
	label.text = "State: " + new_state.get_name()


func change_speed(fAmount := NORMAL_SPEED / 4) -> float:
	if fSpeed < fAmount:
		return 0.0
	else:
		return fAmount


func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("store_trash"):
		bIsOnDump = false
		dump = null
	if area.has_method("pick_up"):
		bIsOnTrash = false
		trashes.erase(area)
	if area.has_method("use_stairwell"):
		bIsOnDoor = false
		door = null


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("store_trash"):
		bIsOnDump = true
		dump = area
	if area.has_method("pick_up"):
		bIsOnTrash = true
		trashes.push_front(area)
	if area.has_method("use_stairwell"):
		bIsOnDoor = true
		door = area
