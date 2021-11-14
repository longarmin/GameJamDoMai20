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


func _ready() -> void:
	sName = "Oma"
	target = get_node("../Player")
	assert(Events.connect("trash_picked", self, "_on_Player_trash_picked") == 0)
	assert(Events.connect("trash_dropped", self, "_on_Player_trash_dropped") == 0)
	assert(Events.connect("neighbour_spawned", self, "_on_Neighbour_spawned") == 0)
	assert(Events.connect("neighbour_passed_trash", self, "_on_Neighbour_passed_trash") == 0)


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


func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("use_stairwell"):
		bIsOnDoor = false
		door = null


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("use_stairwell"):
		bIsOnDoor = true
		door = area


func calc_speed(pos_player: Vector2):
	var rel_pos = self.position.x - pos_player.x
	fSpeed = max(abs(rel_pos), NORMAL_SPEED)
	if rel_pos < 0:
		vDirection.x = 1
	else:
		vDirection.x = -1


# Karma Berechnung


func _on_Player_trash_dropped(bewohner: BewohnerBase, bOnDump: bool) -> void:
	if hear_radius.get_overlapping_bodies().has(bewohner):
		if bOnDump:
			dKarma[bewohner] += 1
		else:
			dKarma[bewohner] -= 1
			calc_speed(bewohner.position)
			bRunningToPlayer = true
			target = bewohner
			timer.start()
		Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])


func _on_Player_trash_picked(bewohner: BewohnerBase) -> void:
	if view_radius.get_overlapping_bodies().has(bewohner):
		dKarma[bewohner] += 1
		Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])


func _on_Neighbour_spawned(spawnedNeighbour: Neighbour) -> void:
	dKarma[spawnedNeighbour] = 0


func _on_Neighbour_passed_trash(passedNeighbour: BewohnerBase) -> void:
	if view_radius.get_overlapping_bodies().has(passedNeighbour):
		dKarma[passedNeighbour] -= 1
		Events.emit_signal("karma_changed", passedNeighbour, dKarma[passedNeighbour])


#Funktionsbeschreibung: Dieser Detektor bringt die Oma zum stehen um mit Player zu reden (schimpfen).
func _on_Player_Detector_body_entered(body: BewohnerBase) -> void:
	if bRunningToPlayer:
		if body == target:
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
