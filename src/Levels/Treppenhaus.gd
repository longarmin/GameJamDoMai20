extends Node2D

onready var neighboursResource = preload("res://src/Bewohner/Neighbour.tscn")

onready var wohnung3: Wohnung = $Wohnung3
onready var wohnung6: Wohnung = $Wohnung6
onready var wohnung7: Wohnung = $Wohnung7

onready var dictNavTable = {
	"Gertrude":
	[neighboursResource.instance(), wohnung3.position, "Wohnung3", "Dump3", "Getrude", wohnung3],
	"Franz":
	[neighboursResource.instance(), wohnung6.position, "Wohnung6", "Dump2", "Franz", wohnung6],
	"Lisa":
	[neighboursResource.instance(), wohnung7.position, "Wohnung7", "Dump3", "Lisa", wohnung7]
}
onready var NeighbourEvents = [
	{"name": "Gertrude", "countdown_val": 12, "target": "Dump2"},
	{"name": "Franz", "countdown_val": 24, "target": "Dump"},
	{"name": "Lisa", "countdown_val": 36, "target": "Dump3"},
]

# spawning umgesetzt wie beschrieben in 
# https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position:

onready var neighboursInstances = {}


func _ready() -> void:
	for name in dictNavTable:
		neighboursInstances[name] = dictNavTable[name][0]
		# weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
		neighboursInstances[name].instanciate(
			dictNavTable[name][1],
			dictNavTable[name][2],
			dictNavTable[name][3],
			dictNavTable[name][4]
		)
		add_child(neighboursInstances[name])
		dictNavTable[name][5].enter_flat(neighboursInstances[name])
	for i in NeighbourEvents:
		if i["name"] in neighboursInstances:
			neighboursInstances[i["name"]].push_neighbour_event(
				i["target"], get_node(i["target"]).position, i["countdown_val"]
			)
		else:
			pass


func _on_trash_created(trash: Trash):
	add_child(trash)
