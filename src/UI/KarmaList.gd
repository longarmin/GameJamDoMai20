extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dKarmaList: Dictionary = {get_node("/root/Level/Player"): 0}
var list: String


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(Events.connect("neighbour_spawned", self, "_on_Neighbour_spawned") == 0)
	assert(Events.connect("karma_changed", self, "_on_Oma_karmachange") == 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Neighbour_spawned(spawnedNeighbour: Neighbour) -> void:
	dKarmaList[spawnedNeighbour] = 0
	write_list()


func _on_Oma_karmachange(bewohner: BewohnerBase, iKarma: int) -> void:
	dKarmaList[bewohner] = iKarma
	write_list()


func write_list() -> void:
	list = ""
	for karma in dKarmaList:
		list = list + karma.sName + ": " + str(dKarmaList[karma]) + "\n"
	list = list + str(get_node("/root/Level/Oma").target) + "\n"
	print(list)
	text = list
