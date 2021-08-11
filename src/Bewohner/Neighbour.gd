extends BewohnerBase
class_name Neighbour

# Declare member variables here. 
const TIME_FACTOR := 20
enum { HALDE, DANEBEN, WOHNUNG }
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 50
const STANDARD_TIME_IDLE := 10

var bAllowDropOnHalde: bool = true
var bHasChild: bool = false
var fDropTime: float = 0.0
var iDropLocation: int = 0
var bIsGoingHome: bool = false
var bHasToUseStairwell: bool
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
	var dir: float = current_direction.x
	# t=target
	var t = vTargetPosition
	# i=instance
	var i = position
	# Das muss noch in eine Funktion ausgegliedert
	var abs_delta_y = abs(t.y - i.y)
	if abs_delta_y <= MAX_Y_DELTA_ON_SAME_LEVEL:
		bHasToUseStairwell = false
		dir = sign(t.x - i.x)
	else:
		# Das muss noch in eine Funktion ausgegliedert werden
		bHasToUseStairwell = true
		if abs(STAIRWELLDOOR_POSX - position.x) < 1:
			var message = Message.new()
			message.status = 4
			if position.y > vTargetPosition.y:
				message.content = "up"
			else:
				message.content = "down"
			message.emitter = "Neighbour"
			stateMachine.respond_to(message)
		if STAIRWELLDOOR_POSX != i.x:
			dir = sign(STAIRWELLDOOR_POSX - i.x)
	dir = dir * abs(current_direction.x)
	return Vector2(dir, current_direction.y)


# weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
func instanciate(pos: Vector2, sHomeName: String, sTargetName: String, sNeighbourName: String) -> void:
	position = pos
	vHomePosition = pos
	sHome = sHomeName
	sTarget = sTargetName
	sNeighbour = sNeighbourName


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
	if area.position == vHomePosition:
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
		evtCountdownTimer.wait_time = temp.countdown_val
		evtCountdownTimer.start()
	else:
		sTarget = sHome
		bIsGoingHome = true
		evtCountdownTimer.wait_time = STANDARD_TIME_IDLE
		evtCountdownTimer.start()
