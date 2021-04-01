class_name Oma
extends BewohnerNPC
signal karmachange(iKarma)

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und überwacht deren Tätigkeit.
# Omas Meinung von den Bewohner ändert sich durch Handlungen der Personen.

# Definiere Variablen
var playerPositionX := 0.0
var fBodyInViewRange := false
var dKarma := {
	"Player":0,
	"Karl":0,
	"Rolgadina":0,
}

# Definiere onready Variablen fuer Typunterstuetzungs
onready var speechBubble: TextEdit = $SpeechBubble


func _physics_process(_delta: float) -> void:
	sprite_flip_direction()

# Dreht den Sprite von Oma um, wenn fBodyInViewRange wahr ist.
# Zeigt außerdem Textbox an.
func sprite_flip_direction():
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
			sprite.flip_h = false


func _on_Character_Detector_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		speed -= 25
		playerPositionX = body.position.x
		fBodyInViewRange = true


func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		speed += 25
		fBodyInViewRange = false


func _on_Player_trash_dropped(trashsize: int, pos_player:Vector2) -> void:
	if fBodyInViewRange:
		print("Oh mein Gott, Herr Meier hat Muell gedropt")
		dKarma["Player"] -= 1
		print("Position of event: " + str(pos_player))
		print("Karma of Player: " + str(dKarma["Player"]))
		emit_signal("karmachange", dKarma["Player"])
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

