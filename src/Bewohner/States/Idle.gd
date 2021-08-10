extends BewohnerState
class_name Idle


func update_physics(_delta: float) -> void:
	if bewohner.calculate_direction(bewohner.vNPCDirection).x != 0:
		var message = Message.new()
		message.status = 1
		message.content = "Geschwindigkeit ungleich 0"
		message.emitter = "IdleState"
		state_machine.respond_to(message)

# In Player-Klasse verschieben, die dann die Message an die State-Machine weiterleitet
# Player Klasse soll Input handeln, bei NPCs sendet die KI die Messages
func handle_input(_event) -> void:
	if Input.is_action_pressed("action2"):
		var message = Message.new()
		message.status = 2
		message.content = "Actionbutton 2 gedrueckt"
		message.emitter = "IdleState"
		state_machine.respond_to(message)
	if Input.is_action_pressed("action1"):
		var message = Message.new()
		message.status = 3
		message.content = "Actionbutton 1 gedrueckt"
		message.emitter = "IdleState"
		state_machine.respond_to(message)
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
		var message = Message.new()
		message.status = 4
		if Input.is_action_just_pressed("ui_up"):
			message.content = "up"
		else:
			message.content = "down"
		message.emitter = "IdleState"
		state_machine.respond_to(message)


func respond_to(message: Message) -> Dictionary:
	match message.status:
		1:
			return {"sTargetState": "Running", "dParams": {}}
		2:
			return {"sTargetState": "Dropping", "dParams": {}}
		3:
			return {"sTargetState": "Picking", "dParams": {}}
		4:
			var up: bool = false
			if message.content == "up":
				up = true
			return {"sTargetState": "EnteringDoor", "dParams": {"up": up}}
		_:
			return {"sTargetState": "Idle", "dParams": {}}


func enter(_params):
	bewohner.animationPlayer.play("idle")


func exit():
	pass
