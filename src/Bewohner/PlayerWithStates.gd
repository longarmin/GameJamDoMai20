extends KinematicBody2D
class_name PlayerWithStates
export (PackedScene) onready var Trash

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

# DEBUGGING
onready var label: Label = $Label

func _ready():
	pass

func _unhandled_input(_event) -> void:
	if Input.is_action_pressed("action2"):
		var message = Message.new()
		message.status = 2
		message.content = "Actionbutton 2 gedrueckt"
		message.emitter = "IdleState"
		stateMachine.respond_to(message)
	if Input.is_action_pressed("action1"):
		var message = Message.new()
		message.status = 3
		message.content = "Actionbutton 1 gedrueckt"
		message.emitter = "IdleState"
		stateMachine.respond_to(message)
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
		var message = Message.new()
		message.status = 4
		if Input.is_action_just_pressed("ui_up"):
			message.content = "up"
		else:
			message.content = "down"
		message.emitter = "IdleState"
		stateMachine.respond_to(message)


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


# Hitbox-Detector

func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("store_trash"):
		bIsOnDump = false
		dump = null
		emit_signal("trash_notPickable")
	if area.has_method("pick_up"):
		aTrashesNear.erase(area)
		if !aTrashesNear:
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
		else:
			emit_signal("trash_notPickable")
	if area.has_method("pick_up"):
		bIsOnTrash = true
		aTrashesNear.push_front(area)
		emit_signal("trash_pickable")
	if area.has_method("use_stairwell"):
		bIsOnDoor = true
		door = area
