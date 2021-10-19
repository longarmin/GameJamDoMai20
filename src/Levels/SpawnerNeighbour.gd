extends Node
class_name SpawnerNeighbour

# Es werden zunaechst zufaellige Nachbarn generiert.
# Ihnen werden Wohnungen zugewiesen.

onready var neighboursResource = preload("res://src/Bewohner/Neighbour.tscn")
# In der Gruppe Flats sollten nur leere Wohnung sein. Diese werden hier in das Array gespeichert.
onready var aFlats = get_tree().get_nodes_in_group("flatsEmpty")
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
			"neighbourDump": aDumps[randi() % aDumps.size()],
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourDump": aDumps[randi() % aDumps.size()],
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourDump": aDumps[randi() % aDumps.size()],
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourDump": aDumps[randi() % aDumps.size()],
			"neighbourName": aNames.pop_back()
		},
		{
			"neighbourNode": neighboursResource.instance(),
			"neighbourFlat": aFlats.pop_back(),
			"neighbourDump": aDumps[randi() % aDumps.size()],
			"neighbourName": aNames.pop_back()
		},
	]
	for neighbourSpawn in neighbourSpawnTable:
		spawn(neighbourSpawn)


func spawn(neighbourSpawn):
	neighbourSpawn["neighbourNode"].instanciate(
		neighbourSpawn["neighbourFlat"], neighbourSpawn["neighbourName"], rand_range(80, 120)
	)
	neighbourSpawn["neighbourFlat"].add_to_group("flats")
	neighbourSpawn["neighbourFlat"].remove_from_group("flatsEmpty")
	get_parent().add_child(neighbourSpawn["neighbourNode"])
	neighbourSpawn["neighbourNode"].add_to_group("neighbours")
	neighbourSpawn["neighbourFlat"].enter_flat(neighbourSpawn["neighbourNode"])
	Events.emit_signal("neighbour_spawned", neighbourSpawn["neighbourNode"])
