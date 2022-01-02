extends Node
class_name SpawnerNeighbour

# Es werden zunaechst zufaellige Nachbarn generiert.
# Ihnen werden Wohnungen und Namen zugewiesen.
# Abschliessend werden die Nachbarn mit den passenden Eigenschaften gespawnt.

onready var neighboursResource = preload("res://src/Bewohner/Neighbour.tscn")
# In der Gruppe Flats sollten nur leere Wohnung sein. Diese werden hier in das Array gespeichert.
onready var aFlats = get_tree().get_nodes_in_group("flatsEmpty")
# Alle Deponien sind in der Gruppe dumps.
onready var aDumps = get_tree().get_nodes_in_group("dumps")

var neighbourSpawnTable

var aNames = [
	"Gertrude",
	"Franz",
	"Lisa",
	"Kendrick",
	"Andreas",
	"Niko",
	"Blaze",
	"Dax",
	"Lucy",
	"Eira",
	"Antonia",
	"Justin",
	"Mae",
	"Isha",
	"Jarrod",
	"Anna",
	"Keith",
	"Odelia",
	"Riah",
	"Moselle",
	"Keldan",
	"Zacchaeus",
	"Eli",
	"Donna",
	"Augusta",
]

# spawning umgesetzt wie beschrieben in
# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position:


func _ready():
	yield(owner, "ready")
	randomize()
	aFlats.shuffle()
	aNames.shuffle()
	neighbourSpawnTable = [
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourName": aNames.pop_back()
		},
	]
	for neighbourSpawn in neighbourSpawnTable:
		spawn(neighbourSpawn)
	print("Done spawning")


#func spawnMiscellaneous()
func spawn(neighbourSpawn):
	neighbourSpawn["neighbourNode"].instanciate(
		neighbourSpawn["neighbourFlat"], neighbourSpawn["neighbourName"], rand_range(80, 120)
	)
	neighbourSpawn["neighbourFlat"].add_to_group("flats")
	neighbourSpawn["neighbourFlat"].remove_from_group("flatsEmpty")
	get_parent().add_child(neighbourSpawn["neighbourNode"])
	neighbourSpawn["neighbourNode"].add_to_group("neighbours")
	neighbourSpawn["neighbourNode"].add_to_group("bewohner")
	neighbourSpawn["neighbourFlat"].enter_flat(neighbourSpawn["neighbourNode"])
	neighbourSpawn["neighbourFlat"].setText(neighbourSpawn["neighbourName"])
	Events.emit_signal("neighbour_spawned", neighbourSpawn["neighbourNode"])
