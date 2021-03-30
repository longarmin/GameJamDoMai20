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
onready var sprite: Sprite = $Sprite


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

# Methode 
func decide_Etagenwechsel() -> void:
	var random = randf()
	if random < 0.4 && self.position.y < 250:
		self.position.y += 96
	elif random > 0.6 && self.position.y > 150:
		self.position.y -= 96


func _on_Character_Detector_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		speed.x -= 25
		playerPositionX = body.position.x
		fBodyInViewRange = true


func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		speed.x += 25
		fBodyInViewRange = false


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area is Stairwell:
		decide_Etagenwechsel()
