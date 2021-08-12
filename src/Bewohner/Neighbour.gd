extends BewohnerBase
class_name Neighbour

# Declare member variables here. 
const TIME_FACTOR := 20
enum { HALDE, DANEBEN, WOHNUNG }
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 50
const STANDARD_TIME_IDLE := 10

var bAllowDropOnHalde: bool = true
var fDropTime: float = 0.0
var iDropLocation: int = 0
var bIsGoingHome: bool = false
var vHomePosition: Vector2
var sNeighbour: String
var sHome: String
var sTarget: String
var target = HALDE
var vTargetPosition: Vector2
var aQueueNeighbourEvents := []
var iCounter: int = 0

onready var evtCountdownTimer: Timer = $EvtCountdownTimer
onready var nameLabel: Label = $Label


class neighbour_event:
	var target_name: String = ""
	var target_position: Vector2 = Vector2(0, 0)
	var countdown_val: float = 0.0


func _ready() -> void:
	nameLabel.text = sNeighbour


func push_neighbour_event(target_name: String, target_position: Vector2, countdown_val: float) -> void:
	var temp = neighbour_event.new()
	temp.target_name = target_name
	temp.target_position = target_position
	temp.countdown_val = countdown_val
	aQueueNeighbourEvents.push_back(temp)


func calculate_direction(current_direction: Vector2) -> Vector2:
	var fDir: float = 1
	if has_to_use_stairwell(position, vTargetPosition):
		if abs(STAIRWELLDOOR_POSX - position.x) < 1:
			emit_stairwell_message(position, vTargetPosition)
		if STAIRWELLDOOR_POSX != position.x:
			fDir = sign(STAIRWELLDOOR_POSX - position.x)
	else:
		fDir = sign(vTargetPosition.x - position.x)
	return Vector2(fDir, current_direction.y)


func has_to_use_stairwell(vPos: Vector2, vTargetPos: Vector2) -> bool:
	var abs_delta_y = abs(vPos.y - vTargetPos.y)
	if abs_delta_y <= MAX_Y_DELTA_ON_SAME_LEVEL:
		return false
	else:
		return true


func emit_stairwell_message(vPos: Vector2, vTargetPos: Vector2) -> void:
	var message = Message.new()
	message.status = 4
	if vPos.y > vTargetPos.y:
		message.params["up"] = true
	else:
		message.params["up"] = false
	if abs(vPos.y - vTargetPos.y) > 150:
		message.params["double"] = true
	else:
		message.params["double"] = false
	message.emitter = "Neighbour"
	stateMachine.respond_to(message)


# weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
func instanciate(
	pos: Vector2,
	sHomeName: String,
	sTargetName: String,
	sNeighbourName: String,
	fSpeedNew: float = fSpeed
) -> void:
	position = pos
	vHomePosition = pos
	sHome = sHomeName
	sTarget = sTargetName
	sNeighbour = sNeighbourName
	fSpeed = fSpeedNew


func _on_Hitbox_area_entered(area: Area2D) -> void:
	._on_Hitbox_area_entered(area)
	if area is Dump && abs(vTargetPosition.x - area.position.x) < 20:
		var message = Message.new()
		message.status = 2
		message.content = "Neighbour on Dump"
		message.emitter = "Neighbour"
		stateMachine.respond_to(message)

	# Check, ob Neighbour wieder in seine Flat zurueck soll:
	if area.name == sTarget:
		# neues Ziel setzen: Flat des Neighbour
		sTarget = sHome
		vTargetPosition = vHomePosition
		bIsGoingHome = true
	if bIsGoingHome:
		if area.name == sHome:
			bIsGoingHome = false
# warning-ignore:unsafe_method_access
			area.enter_flat(self)
			evtCountdownTimer.start()


func _on_Hitbox_area_exited(area: Area2D) -> void:
	# Trash mitnehmen, wenn welcher vor der eigenen Wohnung liegt
	if area.position == vHomePosition - Vector2(0, 20):
		var message = Message.new()
		message.status = 3
		message.content = "Neighbour on Flat"
		message.emitter = "Neighbour"
		stateMachine.respond_to(message)
	._on_Hitbox_area_exited(area)


func _on_EvtCountdownTimer_timeout() -> void:
	var temp = aQueueNeighbourEvents.pop_front()
	if temp != null:
		sTarget = temp.target_name
# warning-ignore:unsafe_property_access
		vTargetPosition = get_parent().get_node(sTarget).position
		evtCountdownTimer.wait_time = temp.countdown_val
		evtCountdownTimer.start()
	else:
		sTarget = sHome
		vTargetPosition = vHomePosition
		bIsGoingHome = true
		evtCountdownTimer.wait_time = STANDARD_TIME_IDLE
		evtCountdownTimer.start()
