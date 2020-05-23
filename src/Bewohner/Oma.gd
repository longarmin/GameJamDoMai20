extends BewohnerNPC

var fTimeoffOnStairs := false
var PlayerPositionX := 0.0
var PlayerID := 0
var fBodyInViewRange := false

func _physics_process(delta: float) -> void:
	pass

func sprite_flip_direction():
	if fBodyInViewRange:
		$SpeechBubble.visible = true
		if (PlayerPositionX - self.position.x) < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	else:
		$SpeechBubble.visible = false
		if direction.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false	
	

func _on_Timer_timeout() -> void:
	pass # Replace with function body.

func _on_Area2D_body_entered(body: Node) -> void:
	Decide_Etagenwechsel(body)

func _on_Area2D_body_exited(body: Node) -> void:
	if body == self:
		self.set_collision_layer(1024)
		on_stairs = false

func _on_Area2D2_body_entered(body: Node) -> void:
		Decide_Etagenwechsel(body)

func _on_Area2D2_body_exited(body: Node) -> void:
	if body == self:
		self.set_collision_layer(1024)
		on_stairs = false

func _on_Timer2_timeout() -> void:
	fTimeoffOnStairs = false

func Decide_Etagenwechsel(body: Node)->void:
		if body == self:		
			var random = randf()
			if random < 0.5:
				self.set_collision_layer(1024)
			else:
				self.set_collision_layer(2048)
			on_stairs = true

func _on_Character_Detector_body_entered(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		print('Player in visual range of Oma\n')
		speed.x = 0
		$Sprite/AnimationPlayer.set_active(false)
		$Sprite.frame = 0
		PlayerPositionX = body.position.x
		fBodyInViewRange = true
			
		
func _on_Character_Detector_body_exited(body: PhysicsBody2D) -> void:
	if body.name == 'Player':
		print('Player out of Oma\'s visual range')
		speed.x = 150
		$Sprite/AnimationPlayer.set_active(true)
		fBodyInViewRange = false