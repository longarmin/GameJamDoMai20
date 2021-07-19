extends Node2D

var runtime: float = 1.0

func _ready() -> void:
	$Timer.start()

func _process(delta: float) -> void:
	pass


func _on_Timer_timeout() -> void:
	print("Timeout, runtime = " + str(self.runtime))
	self.runtime = self.runtime + 0.5
	$Timer.wait_time = self.runtime
	$Timer.start()
