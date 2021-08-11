class_name Oma
extends Bewohner

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und ueberwacht deren Taetigkeit.
# Omas Meinung von den Bewohnern aendert sich durch Handlungen der Personen.

# Definiere Variablen
var playerPositionX := 0.0
var bBodyInHearingRange := false
var bRunningToPlayer := false
var bBodyInViewRange := false
var dKarma := {"Player": 0, "Franz": 0, "Gertrude": 0, "Lisa": 0}
var bTippDrop := false
var bTippPickup := false
# Definiere onready Variablen fuer Typunterstuetzungs
# onready var speechBubble: Node2D = $SpeechBubble
onready var animationPlayer: AnimationPlayer = $Sprite/AnimationPlayer
onready var timer: Timer = $Timer


func _ready() -> void:
	assert(Events.connect("trash_picked", self, "_on_Player_trash_picked") == 0)
	assert(Events.connect("trash_dropped", self, "_on_Player_trash_dropped") == 0)


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


func _on_Character_Detector_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		#speed = 0
		playerPositionX = body.position.x
		bBodyInHearingRange = true


func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		#speed = NORMAL_SPEED
		bBodyInHearingRange = false


func _on_Character_Detector_NearField_body_entered(body: Node) -> void:
	if body.name == 'Player':
		bBodyInViewRange = true


func _on_Character_Detector_NearField_body_exited(body: Node) -> void:
	if body.name == 'Player':
		bBodyInViewRange = false


func calc_speed(pos_player: Vector2):
	var rel_pos = self.position.x - pos_player.x
	speed = abs(rel_pos)
	if rel_pos < 0:
		direction.x = 1
	else:
		direction.x = -1


func _on_Player_trash_dropped(bewohner: BewohnerBase) -> void:
	if bBodyInHearingRange:
		dKarma["Player"] -= 1
		Events.emit_signal("karma_changed", dKarma["Player"])
		calc_speed(bewohner.position)
		bRunningToPlayer = true
	elif ! bTippDrop && bewohner.name == "Player":
		Events.emit_signal(
			"dialog_started",
			"Tipp",
			"Du warst clever und hast den Muell ausserhalb\n Omas Hoerbereich hingeschmissen."
		)
		bTippDrop = true


func _on_Player_trash_picked(bewohner: BewohnerBase) -> void:
	if bBodyInViewRange:
		#print("Wie schoen, Herr Meier kuemmert sich um unser Treppenhaus")
		dKarma["Player"] += 1
		#print("Position of event:" + str(pos_player))
		#print("Karma of Player: " + str(dKarma["Player"]))
		Events.emit_signal("karma_changed", dKarma["Player"])
	elif ! bTippPickup && bewohner.name == "Player":
		Events.emit_signal(
			"dialog_started",
			"Tipp",
			"Du warst nicht so klug und hast den Muell ausserhalb\nOmas Sichtweite aufgehoben."
		)
		bTippPickup = true


#Funktionsbeschreibung: Dieser Detektor bringt die Oma zum stehen um mit Player zu reden (schimpfen).
func _on_Player_Detector_body_entered(body: Node) -> void:
	if bRunningToPlayer:
		if body.name == 'Player':
			speed = 0
			animationPlayer.play("Oma_Stehend")
			var message = Message.new()
			message.status = 5
			message.content = "5"
			message.emitter = "Oma"
# warning-ignore:unsafe_property_access
			body.stateMachine.respond_to(message)
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
