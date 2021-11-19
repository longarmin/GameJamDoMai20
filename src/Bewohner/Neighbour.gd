extends BewohnerBase
class_name Neighbour

# Declare member variables here.
const TIME_FACTOR := 20
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 30
const STANDARD_TIME_IDLE := 15

var bAllowDropOnHalde: bool = true
var home: Wohnung
var target: Dump

onready var nameLabel: Label = $Label
onready var eventManager: EventManager = $EventManager


func _ready() -> void:
	nameLabel.text = sName


func calculate_direction(current_direction: Vector2) -> Vector2:
	var fDir: float = 1
	var currentTarget: Node2D
	if eventManager.current_event != null:
		target = eventManager.current_event.target
	if target != null:
		currentTarget = target
	else:
		currentTarget = home
	if has_to_use_stairwell(position, currentTarget.position):
		if abs(STAIRWELLDOOR_POSX - position.x) < 10:
			emit_stairwell_message(position, currentTarget.position)
		if STAIRWELLDOOR_POSX != position.x:
			fDir = sign(STAIRWELLDOOR_POSX - position.x)
	else:
		fDir = sign(currentTarget.position.x - position.x)
	return Vector2(fDir, current_direction.y)


func has_to_use_stairwell(vPos: Vector2, vTargetPos: Vector2) -> bool:
	var abs_delta_y = abs(vPos.y - vTargetPos.y)
	if abs_delta_y <= MAX_Y_DELTA_ON_SAME_LEVEL:
		return false
	else:
		return true


func emit_stairwell_message(vPos: Vector2, vTargetPos: Vector2) -> void:
	var message_params: Dictionary
	if vPos.y > vTargetPos.y:
		message_params["up"] = true
	else:
		message_params["up"] = false
	if abs(vPos.y - vTargetPos.y) > 150:
		message_params["double"] = true
	else:
		message_params["double"] = false
	var message = Message.new(4, "Treppen steigen", self, message_params)
	stateMachine.respond_to(message)


# weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
func instanciate(homeNew: Wohnung, sNeighbourName: String, fSpeedNew: float = fSpeed) -> void:
	position = homeNew.position + Vector2(0, 20)
	home = homeNew
	sName = sNeighbourName
	fSpeed = fSpeedNew


func _on_Hitbox_area_entered(area: Area2D) -> void:
	._on_Hitbox_area_entered(area)
	if area is Dump && target != null && abs(target.position.x - area.position.x) < 5:
		var message = Message.new(2, "Neighbour on Dump", self)
		stateMachine.respond_to(message)

	# Check, ob Neighbour wieder in seine Flat zurueck soll:
	if area == target:
		# neues Ziel setzen: Flat des Neighbour
		eventManager.remove_current_event()
		target = null

	if target == null:
		if area == home:
			# warning-ignore:unsafe_method_access
			area.enter_flat(self)


func _on_Hitbox_area_exited(area: Area2D) -> void:
	# Trash mitnehmen, wenn welcher vor der eigenen Wohnung liegt
	if area == home:
		var message = Message.new(3, "Neighbour on Flat", self)
		stateMachine.respond_to(message)
	._on_Hitbox_area_exited(area)


func activate_new_target() -> bool:
	target = eventManager.activate_new_event()
	if target:
		return true
	else:
		return false
