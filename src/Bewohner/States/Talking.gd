extends BewohnerState
class_name Talking

var timer
var wait: int = 5


func respond_to(message: Message) -> Response:
	if message.iStatus == 1:
		sTargetState = "Idle"
		return Response.new(sTargetState, dParams)
	else:
		return null


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
	var message = Message.new(1, "Timer stopped", self)
	state_machine.respond_to(message)
