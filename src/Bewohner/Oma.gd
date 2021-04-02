class_name Oma
extends BewohnerNPC
signal karmachange(iKarma)

# Script fuer Oma-NPC
# Oma bewegt sich durchs Haus, spricht Bewohner an und ueberwacht deren Taetigkeit.
# Omas Meinung von den Bewohner aendert sich durch Handlungen der Personen.

# Definiere Variablen
var playerPositionX := 0.0
var fBodyInViewRange := false
var bRunningToPlayer := false
var dKarma := {
	"Player": 0,
	"Karl": 0,
	"Rolgadina": 0,
}

# Definiere onready Variablen fuer Typunterstuetzungs
onready var speechBubble: TextEdit = $SpeechBubble
onready var hitbox: Area2D = $HitBox
onready var animationPlayer: AnimationPlayer = $Sprite/AnimationPlayer
onready var timer: Timer = $Timer


func _physics_process(_delta: float) -> void:
	#sprite_flip_direction()
	pass


func calculate_direction(current_direction: Vector2) -> Vector2:
	if bRunningToPlayer:
		return current_direction
	else:
		return .calculate_direction(current_direction)


# Dreht den Sprite von Oma um, wenn fBodyInViewRange wahr ist.
# Zeigt ausserdem Textbox an.
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
		playerPositionX = body.position.x
		fBodyInViewRange = true


func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		fBodyInViewRange = false


func calc_speed(pos_player: Vector2):
	var rel_pos = self.position.x - pos_player.x
	speed = abs(rel_pos)
	if rel_pos < 0:
		direction.x = 1
	else:
		direction.x = -1


# Wenn Spieler Trash auf derselben Etage droppt, auf der die Oma ist,
# dann sprintet Oma zu ihm. Dabei wird die Kollision mit dem Treppenhaus
# ausgestellt. Erst wenn die Oma in Reichweite des Spielers kommt,
# wird wieder umgestellt, damit sie nicht in eine andere Etage rennt.
# Siehe _on_Player_Detector_body_entered
func _on_Player_trash_dropped(_trashsize: int, pos_player: Vector2) -> void:
	if fBodyInViewRange:
		print("Oh mein Gott, Herr Meier hat Muell gedropt")
		dKarma["Player"] -= 1
		print("Position of event: " + str(pos_player))
		print("Karma of Player: " + str(dKarma["Player"]))
		emit_signal("karmachange", dKarma["Player"])
		calc_speed(pos_player)
		bRunningToPlayer = true
		hitbox.set_collision_mask_bit(4, false)
	else:
		print("Player war clever und hat den Muell ausserhalb Omas Sichtweite hingeschmissen")


func _on_Player_trash_collected(_trashsize: int, pos_player: Vector2) -> void:
	if fBodyInViewRange:
		print("Wie schoen, Herr Meier kuemmert sich um unser Treppenhaus")
		dKarma["Player"] += 1
		print("Position of event:" + str(pos_player))
		print("Karma of Player: " + str(dKarma["Player"]))
		emit_signal("karmachange", dKarma["Player"])
	else:
		print("Player war nicht so klug und hat Muell ausserhalb Omas Sichtweite aufgehoben")


func _on_Player_Detector_body_entered(body: Node) -> void:
	if body.name == 'Player':
		if bRunningToPlayer:
			speed = 0
			animationPlayer.play("Oma_Stehend")
			bRunningToPlayer = false
			hitbox.set_collision_mask_bit(4, true)
			timer.start(2)
		else:
			speechBubble.visible = true
			speed -= self.change_speed()

func _on_Player_Detector_body_exited(body):
	if body.name == 'Player':
		speechBubble.visible = false
		speed += self.change_speed()

func _on_Timer_timeout() -> void:
	speed = NORMAL_SPEED
	animationPlayer.play("Oma_Laufend")
	speechBubble.visible = false


