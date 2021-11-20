extends Node
class_name EventManager

export var bTargetDumps: bool = true
export var bTargetFlats: bool = false
export var bTargetBewohner: bool = false
export var iEventGeneratorTime: int = 5

var aQueue: Array = []
var current_event: AIEvent

onready var timer: Timer = $Timer
onready var eventGeneratorTimer: Timer = $EventGeneratorTimer
onready var aRandDump = get_tree().get_nodes_in_group("dumps")


func _ready():
	eventGeneratorTimer.wait_time = iEventGeneratorTime


func push_new_event(event: AIEvent) -> void:
	aQueue.push_back(event)


func remove_event(event: AIEvent) -> void:
	aQueue.erase(event)


func activate_new_event() -> Node2D:
	if aQueue.size() > 0:
		current_event = aQueue.pop_front()
		timer.start(current_event.iMax_Event_time)
		return current_event.target
	return null


func deactivate_current_event() -> void:
	aQueue.push_front(current_event)
	current_event = null


func remove_current_event() -> void:
	current_event = null


func _on_Timer_timeout() -> void:
	remove_current_event()


func _on_event_spawned(event: AIEvent, neighbour: Bewohner) -> void:
	if owner == neighbour:
		push_new_event(event)


# EventGenerator
# optionaler Generator implementieren?
func generate_neighbour_event() -> void:
	var randomTargets: Array
	if bTargetDumps:
		randomTargets.append(aRandDump[randi() % aRandDump.size()])
	if bTargetFlats:
		var aRandFlat = get_tree().get_nodes_in_group("flats")
		randomTargets.append(aRandFlat[randi() % aRandFlat.size()])
	if bTargetBewohner:
		var aRandBewohner = get_tree().get_nodes_in_group("Bewohner")
		randomTargets.append(aRandBewohner[randi() % aRandBewohner.size()])
	var event = AIEvent.new(randomTargets[randi() % randomTargets.size()], 10)
	push_new_event(event)


func _on_EventGeneratorTimer_timeout() -> void:
	generate_neighbour_event()
	eventGeneratorTimer.start(iEventGeneratorTime)
