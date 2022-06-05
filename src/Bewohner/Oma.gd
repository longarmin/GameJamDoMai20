class_name Oma
extends Bewohner

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und ueberwacht deren Taetigkeit.
# Omas Meinung von den Bewohnern aendert sich durch Handlungen der Personen.

# Definiere Variablen
const TIME_FACTOR := 20
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 30
const STANDARD_TIME_IDLE := 15

var bRunningToPlayer := false
var sTargetPlayer: String
var target: Node2D

onready var dKarma: Dictionary = {get_node("../Player"): 0}
onready var timer: Timer = $Timer
onready var hear_radius: Area2D = $Character_Detector_Hear
onready var view_radius: Area2D = $Character_Detector_View
onready var questManager: QuestManager = $QuestManager


func _ready() -> void:
	sName = "Oma"
	var startQuest = AIQuest.new(get_node("../Player"), 20)
	questManager.activate_quest(startQuest)
	home = get_tree().get_nodes_in_group("flatsOma")[0]
	home.add_to_group("flats")
	home.setText(sName)
	assert(Events.connect("trash_picked", self, "_on_Player_trash_picked") == 0)
	assert(Events.connect("trash_dropped", self, "_on_Player_trash_dropped") == 0)
	assert(Events.connect("neighbour_spawned", self, "_on_Neighbour_spawned") == 0)
	assert(Events.connect("neighbour_passed_trash", self, "_on_Neighbour_passed_trash") == 0)


func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("use_stairwell"):
		bIsOnDoor = false
		door = null


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("use_stairwell"):
		bIsOnDoor = true
		door = area
	if area.has_method("get_trashFuellstand") && area.get_trashFuellstand() > 0:
		for bewohner in get_tree().get_nodes_in_group("bewohner"):
			if bewohner.home == area:
				dKarma[bewohner] -= 1
				Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])
	# Check, ob Neighbour wieder in seine Flat zurueck soll:
	if questManager.current_quest:
		if area == questManager.current_quest.target:
			# neues Ziel setzen: Flat des Neighbour
			questManager.remove_current_quest()
			if questManager.aQueue.size() > 0:
				questManager.activate_new_quest()
	else:
		if area == home:
			# warning-ignore:unsafe_method_access
			area.enter_flat(self)


func _on_HitBox_body_entered(body: Node) -> void:
	if questManager.current_quest:
		if body == questManager.current_quest.target:
			# neues Ziel setzen: Flat des Neighbour
			questManager.remove_current_quest()
	else:
		if body == home:
			# warning-ignore:unsafe_method_access
			body.enter_flat(self)


func calc_speed(pos_player: Vector2):
	var rel_pos = self.position.x - pos_player.x
	fSpeed = max(abs(rel_pos), NORMAL_SPEED)
	if rel_pos < 0:
		vDirection.x = 1
	else:
		vDirection.x = -1


# Karma Berechnung


func _on_Player_trash_dropped(bewohner: BewohnerBase, bOnDump: bool) -> void:
	if hear_radius.monitoring && hear_radius.get_overlapping_bodies().has(bewohner):
		if bOnDump:
			dKarma[bewohner] += 1
		else:
			dKarma[bewohner] -= 1
			calc_speed(bewohner.position)
			bRunningToPlayer = true
			var newQuest = AIQuest.new(bewohner, 10)
			questManager.activate_quest(newQuest)
			timer.start()
		Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])


func _on_Player_trash_picked(bewohner: BewohnerBase) -> void:
	if view_radius.monitoring && view_radius.get_overlapping_bodies().has(bewohner):
		dKarma[bewohner] += 1
		Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])


func _on_Neighbour_spawned(spawnedNeighbour: Neighbour) -> void:
	dKarma[spawnedNeighbour] = 0


func _on_Neighbour_passed_trash(passedNeighbour: BewohnerBase) -> void:
	if view_radius.monitoring && view_radius.get_overlapping_bodies().has(passedNeighbour):
		dKarma[passedNeighbour] -= 1
		Events.emit_signal("karma_changed", passedNeighbour, dKarma[passedNeighbour])


#Funktionsbeschreibung: Dieser Detektor bringt die Oma zum stehen um mit Player zu reden (schimpfen).
func _on_Player_Detector_body_entered(body: BewohnerBase) -> void:
	if bRunningToPlayer:
		if body == questManager.current_quest.target:
			var messageOwnState = Message.new(5, "5", self)
# warning-ignore:unsafe_property_access
			stateMachine.respond_to(messageOwnState)
			var message = Message.new(5, "5", self)
# warning-ignore:unsafe_property_access
			body.stateMachine.respond_to(message)
			if sTargetPlayer == "Player":
				Events.emit_signal(
					"dialog_started",
					"Oma",
					"Herr Meier, so nicht! Sie koennen nicht einfach Ihren Muell\nim Treppenhaus deponieren, das merke ich mir."
				)
			bRunningToPlayer = false


func _on_Timer_timeout() -> void:
	fSpeed = NORMAL_SPEED
	bRunningToPlayer = false


func activate_new_target() -> bool:
	questManager.activate_new_quest()
	if questManager.current_quest:
		return true
	else:
		return false
