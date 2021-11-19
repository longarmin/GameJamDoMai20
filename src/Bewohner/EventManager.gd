extends Node
class_name EventManager

var aQueue: Array = []
var current_event: AIEvent

onready var timer: Timer = $Timer
onready var eventGeneratorTimer: Timer = $EventGeneratorTimer
onready var aRandDump = get_tree().get_nodes_in_group("dumps")


func _ready():
	pass


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
	if get_parent() == neighbour:
		push_new_event(event)


# EventGenerator
# optionaler Generator implementieren?
func generate_neighbour_event() -> void:
	var randomDump: Dump = aRandDump[randi() % aRandDump.size()]
	var event = AIEvent.new(randomDump, 10)
	push_new_event(event)


func _on_EventGeneratorTimer_timeout() -> void:
	generate_neighbour_event()
	eventGeneratorTimer.start(randi() % 20 + 10)
