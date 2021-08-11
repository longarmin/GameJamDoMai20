extends BewohnerState
class_name Talking

var timer
var wait: int = 5


func respond_to(message: Message) -> Dictionary:
	if message.status == 1:
		return {"sTargetState": "Idle", "dParams": {}}
	return {}


func enter(dParams: Dictionary) -> void:
	if bewohner.aTrashBags:
		bewohner.animationPlayer.play("idleTrash")
	else:
		bewohner.animationPlayer.play("idle")
	if dParams.wait:
		wait = dParams.wait
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self, "_timeout")


func _timeout() -> void:
	timer.queue_free()
	var message = Message.new()
	message.status = 1
	message.content = "Timer stopped"
	message.emitter = "TalkingState"
	state_machine.respond_to(message)
