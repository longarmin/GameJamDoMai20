extends BewohnerBase
class_name Neighbour

# Declare member variables here.
const TIME_FACTOR := 20
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 30
const STANDARD_TIME_IDLE := 15

var bAllowDropOnHalde: bool = true
var bIsGoingHome: bool = false
var home: Wohnung
var target: Dump
var aQueueNeighbourEvents := []
var iCounter: int = 0

onready var evtCountdownTimer: Timer = $EvtCountdownTimer
onready var nameLabel: Label = $Label


class neighbour_event:
	var target: Dump
	var countdown_val: float = 0.0


func _ready() -> void:
	nameLabel.text = sName


func push_neighbour_event(targetEvent: Dump, countdown_val: float) -> void:
	var neighbourEvent = neighbour_event.new()
	neighbourEvent.target = targetEvent
	neighbourEvent.countdown_val = countdown_val
	aQueueNeighbourEvents.push_back(neighbourEvent)


func calculate_direction(current_direction: Vector2) -> Vector2:
	var fDir: float = 1
	if has_to_use_stairwell(position, target.position):
		if abs(STAIRWELLDOOR_POSX - position.x) < 10:
			emit_stairwell_message(position, target.position)
		if STAIRWELLDOOR_POSX != position.x:
			fDir = sign(STAIRWELLDOOR_POSX - position.x)
	else:
		fDir = sign(target.position.x - position.x)
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
	target = home
	sName = sNeighbourName
	fSpeed = fSpeedNew


func _on_Hitbox_area_entered(area: Area2D) -> void:
	._on_Hitbox_area_entered(area)
	if area is Dump && abs(target.position.x - area.position.x) < 5:
		var message = Message.new(2, "Neighbour on Dump", self)
		stateMachine.respond_to(message)

	# Check, ob Neighbour wieder in seine Flat zurueck soll:
	if area == target:
		# neues Ziel setzen: Flat des Neighbour
		target = home
		bIsGoingHome = true
	if bIsGoingHome:
		if area == home:
			bIsGoingHome = false
			# warning-ignore:unsafe_method_access
			area.enter_flat(self)
			evtCountdownTimer.start()


func _on_Hitbox_area_exited(area: Area2D) -> void:
	# Trash mitnehmen, wenn welcher vor der eigenen Wohnung liegt
	if area == home:
		var message = Message.new(3, "Neighbour on Flat", self)
		stateMachine.respond_to(message)
	._on_Hitbox_area_exited(area)


func _on_EvtCountdownTimer_timeout() -> void:
	if (
		stateMachine.current_state.name == "EnteringDoor"
		|| stateMachine.current_state.name == "ExitingDoor"
		|| stateMachine.current_state.name == "ChangingFloor"
	):
		evtCountdownTimer.wait_time = STANDARD_TIME_IDLE
		evtCountdownTimer.start()
	else:
		var temp = aQueueNeighbourEvents.pop_front()
		# Workaround: Bewohner wissen nicht wohin, wenn das Event waehrend des Fahrstuhls kommt
		if temp != null:
			target = temp.target
			# warning-ignore:unsafe_property_access
			evtCountdownTimer.wait_time = temp.countdown_val
			evtCountdownTimer.start()
		else:
			target = home
			bIsGoingHome = true
			evtCountdownTimer.wait_time = STANDARD_TIME_IDLE
			evtCountdownTimer.start()
