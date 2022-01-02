class_name AIEvent

var target: Node2D
var iMax_Event_time: int


func _init(eventTarget: Node2D, iMaxEventTime: int):
	target = eventTarget
	iMax_Event_time = iMaxEventTime
