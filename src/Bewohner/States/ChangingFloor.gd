extends BewohnerState
class_name ChangingFloor

var timer
var door: Stairwell
var up: bool = false


func respond_to(message: Message) -> Dictionary:
	if message.status == 1:
		return {"sTargetState": "ExitingDoor", "dParams": {}}
	return {}


func enter(dParams: Dictionary) -> void:
	up = dParams.up
	door = bewohner.door
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, "_timeout")


func exit() -> void:
	bewohner.position = door.use_stairwell(bewohner.position, up)


func _timeout() -> void:
	timer.queue_free()
	var message = Message.new()
	message.status = 1
	message.content = "Timer stopped"
	message.emitter = "ChangingFloorState"
	state_machine.respond_to(message)
