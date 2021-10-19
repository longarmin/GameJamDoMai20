extends Node2D

onready var aRandDump = get_tree().get_nodes_in_group("dumps")


func _ready() -> void:
	assert(Events.connect("karma_changed", self, "_on_Oma_karmachange") == 0)


func _on_trash_created(trash: Trash):
	add_child(trash)


func generate_neighbour_event(neighbour: Neighbour) -> void:
	var randomDump: Dump = aRandDump[randi() % aRandDump.size()]
	neighbour.push_neighbour_event(randomDump, 10)


func get_random_neighbour() -> Neighbour:
	var aNeighbours = get_tree().get_nodes_in_group("neighbours")
	var randomNeighbour = aNeighbours[randi() % aNeighbours.size()]
	return randomNeighbour


func _on_EventTimer_timeout() -> void:
	generate_neighbour_event(get_random_neighbour())


func _on_Oma_karmachange(bewohner: BewohnerBase, iKarma: int) -> void:
	if iKarma == -6:
		print(bewohner.sName + " hat verloren.")
		if bewohner.sName == "Player":
			get_tree().quit()
		bewohner.queue_free()
	if iKarma == 6:
		print(bewohner.sName + " hat gewonnen!")
		if bewohner.sName == "Player":
			get_tree().quit()
		bewohner.queue_free()
