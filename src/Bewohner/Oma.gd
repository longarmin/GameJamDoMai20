extends BewohnerNPC

var PlayerPositionX := 0.0
# var PlayerID := 0
var fBodyInViewRange := false

onready var speechBubble: TextEdit = $SpeechBubble
onready var sprite: Sprite = $Sprite

func _physics_process(_delta: float) -> void:
	pass

func sprite_flip_direction():
	if fBodyInViewRange:
		speechBubble.visible = true
		if (PlayerPositionX - self.position.x) < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		speechBubble.visible = false
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false	

func decide_Etagenwechsel()->void:
	var random = randf()
	if random < 0.4 && self.position.y < 250:
		self.position.y += 96
	elif random > 0.6 && self.position.y > 150:
		self.position.y -= 96

func _on_Character_Detector_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		speed.x -= 25
		PlayerPositionX = body.position.x
		fBodyInViewRange = true
			
		
func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		speed.x += 25
		fBodyInViewRange = false


func _on_HitBox_area_entered(area: Area2D) -> void:
	if (area is Stairwell):
		decide_Etagenwechsel()
