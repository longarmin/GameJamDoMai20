extends BewohnerNPC

var fTimeoffOnStairs := false

func _physics_process(delta: float) -> void:
	change_layer()
	
func change_layer():
	pass
#	if on_stairs:
#		pass
#	else:
#		self.set_collision_layer(1024)

func _on_Timer_timeout() -> void:
	pass # Replace with function body.


#func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
#	pass # Replace with function body.
#
#func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
#	pass # Replace with function body.
#
#
#func _on_Area2D2_body_entered(body: PhysicsBody2D) -> void:
#	pass # Replace with function body.
#
#
#func _on_Area2D2_body_exited(body: PhysicsBody2D) -> void:
#	pass # Replace with function body.
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
		print("body exited\n Current Layer: " + str(self.get_collision_layer()))
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
			print("body entered\n Random:" + str(random) + " Current Layer: " + str(self.get_collision_layer()))
			on_stairs = true