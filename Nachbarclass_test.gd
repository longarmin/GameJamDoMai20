extends Node2D

class neighbour:
	var pos := Vector2(0,0)
	var home_name:String = ""
	var home_pos := Vector2(0,0)
	var target_name:String = ""
	var target_position := Vector2(0,0)

	func _init(pos=Vector2(0,0), home_name="", target_name=""):
		self.pos=pos
		self.home_name=home_name
		self.target_name=target_name
		
onready var dictNavTable = {
	"Gertrude":neighbour.new($Wohnung.position+Vector2(0, 10),"Wohnung","Muellhalde2"),
	"Franz":neighbour.new($Wohnung2.position+Vector2(0, 10),"Wohnung2","Muellhalde"),
	"Lisa":neighbour.new($Wohnung3.position+Vector2(0, 10),"Wohnung3","Wohnung3")
}
onready var NeighbourEvents = [
	{"name":"Gertrude", "countdown_val":12, "target":"Muellhalde2"},
	{"name":"Franz", "countdown_val":24, "target":"Muellhalde"},
	{"name":"Lisa", "countdown_val":36, "target":"Muellhalde2"},	
	{"name":"Lisa", "countdown_val":10, "target":"Muellhalde2"},	
	{"name":"Lisa", "countdown_val":15, "target":"Muellhalde"},	
]

onready var sNachbar_resource = preload("res://src/Bewohner/Nachbar.tscn")
onready var sNachbar_instances = {}

func _ready() -> void:
	for name in dictNavTable:
		sNachbar_instances[name] = sNachbar_resource.instance()
		#weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
		sNachbar_instances[name].instanciate(dictNavTable[name].pos, dictNavTable[name].home_name, dictNavTable[name].target_name)
	for i in NeighbourEvents:
		print(str(i["target"]) + str(i["countdown_val"]) + str(i["name"]) + str(get_node(i["target"]).position))
		sNachbar_instances[i["name"]].push_neighbour_event(i["target"], get_node(i["target"]).position, i["countdown_val"])
		
func _process(delta: float) -> void:
	check_for_spawning()

func check_for_spawning():
	for name in sNachbar_instances:
		if sNachbar_instances[name].target_name != sNachbar_instances[name].home_name:
			if (!sNachbar_instances[name].child_exists):
				_on_Wohnung_nachbar_geht_raus(sNachbar_instances[name], name)

func _on_Wohnung_nachbar_geht_raus(sNachbar, nbname) -> void:
	#	add_child(sNachbar1)
	print(str(nbname) + " adding as a child ...")
	self.add_child(sNachbar)
	sNachbar.show()
	sNachbar.target_position=get_node(sNachbar.target_name).position
	sNachbar.home_position=get_node(sNachbar.home_name).position
	sNachbar.nbname = str(nbname) 
	get_node(sNachbar.name).connect("nb_goes_home", self, "_on_Nachbar_nb_goes_home")
	sNachbar.child_exists = true
	print("... success!")

