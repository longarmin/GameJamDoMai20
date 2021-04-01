class_name Oma
extends BewohnerNPC
signal karmachange(iKarma)

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und überwacht deren Tätigkeit.
# Omas Meinung von den Bewohner ändert sich durch Handlungen der Personen.

# Definiere Variablen
var playerPositionX := 0.0
var fBodyInViewRange := false
var bRunningToPlayer := false
var dKarma := {
	"Player":0,
	"Karl":0,
	"Rolgadina":0,
}

# Definiere onready Variablen fuer Typunterstuetzungs
onready var speechBubble: TextEdit = $SpeechBubble


func _physics_process(_delta: float) -> void:
	#sprite_flip_direction()
	pass


func calculate_direction(current_direction: Vector2) -> Vector2:
	if bRunningToPlayer:
		return current_direction
	else:
		return .calculate_direction(current_direction)
		

# Dreht den Sprite von Oma um, wenn fBodyInViewRange wahr ist.
# Zeigt außerdem Textbox an.
""" func sprite_flip_direction():
	if fBodyInViewRange:
		speechBubble.visible = true
		if (playerPositionX - self.position.x) < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		speechBubble.visible = false
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false """


func _on_Character_Detector_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		#speed = 0
		playerPositionX = body.position.x
		fBodyInViewRange = true


func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		#speed = NORMAL_SPEED
		fBodyInViewRange = false


func calc_speed(pos_player: Vector2):
	var rel_pos = (self.position.x - pos_player.x)
	speed = abs(rel_pos)
	if rel_pos < 0:
		direction.x = 1
	else:
		direction.x = -1 
	
	# sprite_flip_direction()



func _on_Player_trash_dropped(trashsize: int, pos_player:Vector2) -> void:
	if fBodyInViewRange:

		print("Oh mein Gott, Herr Meier hat Muell gedropt")
		dKarma["Player"] -= 1
		print("Position of event: " + str(pos_player))
		print("Karma of Player: " + str(dKarma["Player"]))
		emit_signal("karmachange", dKarma["Player"])
		calc_speed(pos_player)
		bRunningToPlayer = true
	else:
		print("Player war clever und hat den Muell ausserhalb Omas Sichtweite hingeschmissen")


func _on_Player_trash_collected(trashsize: int, pos_player:Vector2) -> void:
	if fBodyInViewRange:
		print("Wie schoen, Herr Meier kuemmert sich um unser Treppenhaus")
		dKarma["Player"] += 1
		print("Position of event:" + str(pos_player))
		print("Karma of Player: " + str(dKarma["Player"]))
		emit_signal("karmachange", dKarma["Player"])
	else:
		print("Player war nicht so klug und hat Muell ausserhalb Omas Sichtweite aufgehoben")



func _on_Player_Detector_body_entered(body: Node) -> void:
	if bRunningToPlayer:
		if body.name == 'Player':
			speed = 0
			$Sprite/AnimationPlayer.play("Oma_Stehend")
			bRunningToPlayer = false
			$Timer.start(2)

func _on_Timer_timeout() -> void:
	speed = NORMAL_SPEED
