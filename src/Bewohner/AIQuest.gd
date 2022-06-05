class_name AIQuest

var target: Node2D
var iMax_Quest_time: int


func _init(questTarget: Node2D, iMaxQuestTime: int):
	target = questTarget
	iMax_Quest_time = iMaxQuestTime
