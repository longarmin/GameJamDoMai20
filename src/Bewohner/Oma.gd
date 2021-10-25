class_name Oma
extends Bewohner

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und ueberwacht deren Taetigkeit.
# Omas Meinung von den Bewohnern aendert sich durch Handlungen der Personen.

# Definiere Variablen
var playerPositionX := 0.0
var aBodiesInHearingRange := []
var bRunningToPlayer := false
var aBodiesInViewRange := []
var bTippDrop := false
var bTippPickup := false
var sTargetPlayer: String
onready var dKarma: Dictionary = {get_node("../Player"): 0}
# Definiere onready Variablen fuer Typunterstuetzungs
# onready var speechBubble: Node2D = $SpeechBubble
onready var animationPlayer: AnimationPlayer = $Sprite/AnimationPlayer
onready var timer: Timer = $Timer


func _ready() -> void:
	assert(Events.connect("trash_picked", self, "_on_Player_trash_picked") == 0)
	assert(Events.connect("trash_dropped", self, "_on_Player_trash_dropped") == 0)
	assert(Events.connect("neighbour_spawned", self, "_on_Neighbour_spawned") == 0)
	assert(Events.connect("neighbour_passed_trash", self, "_on_Neighbour_passed_trash") == 0)


func _physics_process(_delta: float) -> void:
	pass


func calculate_direction(current_direction: Vector2) -> Vector2:
	if bRunningToPlayer:
		return current_direction
	else:
		return .calculate_direction(current_direction)


func change_floor() -> void:
	if bRunningToPlayer:
		return
	else:
		.change_floor()


func _on_Character_Detector_body_entered(body: BewohnerBase) -> void:
	playerPositionX = body.position.x
	aBodiesInHearingRange.append(body)


func _on_Character_Detector_body_exited(body: BewohnerBase) -> void:
	aBodiesInHearingRange.erase(body)
	if body.sName == sTargetPlayer:
		# Wenn der gesuchte Nachbar "verschwindet" dann soll die Oma nicht mehr hinterherlaufen
		# Sie behaelt aber ihre Geschwindigkeit bei, weil sie wuetend ist. (Aendern?)
		bRunningToPlayer = false
		animationPlayer.play("Oma_Laufend")


func _on_Character_Detector_NearField_body_entered(body: BewohnerBase) -> void:
	aBodiesInViewRange.append(body)


func _on_Character_Detector_NearField_body_exited(body: BewohnerBase) -> void:
	aBodiesInViewRange.erase(body)


func calc_speed(pos_player: Vector2):
	var rel_pos = self.position.x - pos_player.x
	speed = max(abs(rel_pos), NORMAL_SPEED)
	if rel_pos < 0:
		direction.x = 1
	else:
		direction.x = -1


func _on_Player_trash_dropped(bewohner: BewohnerBase, bOnDump: bool) -> void:
	if aBodiesInHearingRange.has(bewohner):
		if bOnDump:
			dKarma[bewohner] += 1
		else:
			dKarma[bewohner] -= 1
			calc_speed(bewohner.position)
			bRunningToPlayer = true
			sTargetPlayer = bewohner.sName
		Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])
	elif !bTippDrop && bewohner.sName == "Player":
		Events.emit_signal(
			"dialog_started",
			"Tipp",
			"Du warst clever und hast den Muell ausserhalb\n Omas Hoerbereich hingeschmissen."
		)
		bTippDrop = true


func _on_Player_trash_picked(bewohner: BewohnerBase) -> void:
	if aBodiesInViewRange.has(bewohner):
		dKarma[bewohner] += 1
		Events.emit_signal("karma_changed", bewohner, dKarma[bewohner])
	elif !bTippPickup && bewohner.sName == "Player":
		Events.emit_signal(
			"dialog_started",
			"Tipp",
			"Du warst nicht so klug und hast den Muell ausserhalb\nOmas Sichtweite aufgehoben."
		)
		bTippPickup = true


#Funktionsbeschreibung: Dieser Detektor bringt die Oma zum stehen um mit Player zu reden (schimpfen).
func _on_Player_Detector_body_entered(body: BewohnerBase) -> void:
	if bRunningToPlayer:
		if body.sName == sTargetPlayer:
			speed = 0
			animationPlayer.play("Oma_Stehend")
			var message = Message.new(5, "5", self)
# warning-ignore:unsafe_property_access
			body.stateMachine.respond_to(message)
			if sTargetPlayer == "Player":
				Events.emit_signal(
					"dialog_started",
					"Oma",
					"Herr Meier, so nicht! Sie koennen nicht einfach Ihren Muell\nim Treppenhaus deponieren, das merke ich mir."
				)
			timer.start(5)
			bRunningToPlayer = false


func _on_Timer_timeout() -> void:
	speed = NORMAL_SPEED
	#bRunningToPlayer = false
	animationPlayer.play("Oma_Laufend")


func _on_Neighbour_spawned(spawnedNeighbour: Neighbour) -> void:
	dKarma[spawnedNeighbour] = 0


func _on_Neighbour_passed_trash(passedNeighbour: BewohnerBase) -> void:
	if aBodiesInViewRange.has(passedNeighbour):
		dKarma[passedNeighbour] -= 1
		Events.emit_signal("karma_changed", passedNeighbour, dKarma[passedNeighbour])
