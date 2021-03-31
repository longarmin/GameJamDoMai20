class_name Oma
extends BewohnerNPC

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und überwacht deren Tätigkeit.
# Omas Meinung von den Bewohner ändert sich durch Handlungen der Personen.

# Definiere private Variablen
var playerPositionX := 0.0
var fBodyInViewRange := false

# Definiere onready Variablen fuer Typunterstuetzungs
onready var speechBubble: TextEdit = $SpeechBubble


func _physics_process(_delta: float) -> void:
	pass

# Methode dreht den Sprite von Oma um, wenn fBodyInViewRange wahr ist.
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
