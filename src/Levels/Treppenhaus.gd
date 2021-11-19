extends Node2D


func _ready() -> void:
	assert(Events.connect("karma_changed", self, "_on_Oma_karmachange") == 0)


func _on_trash_created(trash: Trash):
	add_child(trash)


func _on_Oma_karmachange(bewohner: BewohnerBase, iKarma: int) -> void:
	if iKarma == -6:
		print(bewohner.sName + " hat verloren.")
		if bewohner.sName == "Player":
			get_tree().quit()
		bewohner.queue_free()
	if iKarma == 6:
		print(bewohner.sName + " hat gewonnen!")
		get_tree().quit()
		bewohner.queue_free()
