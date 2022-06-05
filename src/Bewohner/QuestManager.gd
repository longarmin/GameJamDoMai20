extends Node
class_name QuestManager

var aQueue: Array
var current_quest: AIQuest

onready var timer: Timer = $Timer
onready var questGenerator: QuestGenerator = $QuestGenerator

func _ready():
	assert(Events.connect("neighbour_quest_requested", self, "_on_Quest_requested") == 0)


func push_new_quest(quest: AIQuest) -> void:
	if quest == null:
		return
	aQueue.push_back(quest)


func remove_quest(quest: AIQuest) -> void:
	aQueue.erase(quest)


func activate_new_quest() -> Node2D:
	if aQueue.size() > 0:
		if aQueue[0] == null:
			aQueue.pop_front()
			if aQueue.size() == 0:
				return null
		current_quest = aQueue.pop_front()
		timer.start(current_quest.iMax_Quest_time)
		return current_quest.target
	return null


func activate_quest(quest: AIQuest) -> void:
	deactivate_current_quest()
	current_quest = quest
	timer.start(current_quest.iMax_Quest_time)

func deactivate_current_quest() -> void:
	timer.stop()
	if current_quest:
		aQueue.push_front(current_quest)
	current_quest = null


func remove_current_quest() -> void:
	current_quest = null


func _on_Timer_timeout() -> void:
	remove_current_quest()


func _on_quest_spawned(quest: AIQuest, neighbour: Bewohner) -> void:
	if owner == neighbour:
		push_new_quest(quest)


func generate_neighbour_quest() -> void:
	var new_quest = questGenerator.generate_quest()
	push_new_quest(new_quest)


func _on_Quest_requested(neighbour: Bewohner):
	if neighbour == owner:
		generate_neighbour_quest()
