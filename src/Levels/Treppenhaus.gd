extends Node2D


func _ready() -> void:
	assert(Events.connect("karma_changed", self, "_on_Oma_karmachange") == 0)
	assert(Events.connect("trash_spawned", self, "_on_trash_spawned") == 0)


func _on_trash_spawned(trash: Trash):
	add_child(trash)


func _on_Oma_karmachange(bewohner: BewohnerBase, iKarma: int) -> void:
	if iKarma == -6:
		print(bewohner.sName + " hat verloren.")
		Events.emit_signal("neighbour_lost", bewohner)
		if bewohner.sName == "Player":
			GlobalVars.sGameOverReason = "PlayerKarmaAtButtom"
			get_tree().change_scene("res://src/UI/GameOverLose.tscn")
			bewohner.queue_free()
			get_tree().paused = false
			return
		bewohner.queue_free()
	if iKarma == 6:
		if bewohner.sName == "Player":
			GlobalVars.uScoreTime = GlobalVars.elapsed
			GlobalVars.elapsed = 0
			get_tree().change_scene("res://src/UI/GameOverWin.tscn")
			bewohner.queue_free()
			get_tree().paused = false
			return
		print(bewohner.sName + " hat gewonnen!")
		GlobalVars.sGameOverReason = "OthersWin"
		get_tree().change_scene("res://src/UI/GameOverLose.tscn")
		bewohner.queue_free()
		get_tree().paused = false
		return
