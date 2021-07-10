extends Node2D
onready var dictNachbarn = {
	"Wohnungstuer2":{
		"Bewohner":"Karl",
		"Status":"Zuhause"
	},
	"Wohnungstuer6":{
		"Bewohner":"Rolgadina",
		"Status":"Zuhause"
	}
}


class neighbour:
	var pos := Vector2(0,0)
	var home_name:String=""
	var home_pos := Vector2(0,0)
	var target_name:String=""
	var target_position := Vector2(0,0)

	func _init(pos=Vector2(0,0), home_name="", target_name=""):
		self.pos=pos
		self.home_name=home_name
		self.target_name=target_name
		
onready var dictNavTable = {
#	"Gertrude":{
#		"home_name":"Wohnung6",
#		"target_name":"Muellhalde3"
#	},
#	"Franz":{
#		"home_name":"Wohnung2",
#		"target_name":"Wohnung2"		
#	}
	"Gertrude":neighbour.new($Wohnungstuer3.position,"Wohnung3","Muellhalde3"),
	"Franz":neighbour.new($Wohnungstuer6.position,"Wohnung6","Wohnung6"),
	"Lisa":neighbour.new($Wohnungstuer7.position,"Wohnung7","Wohnung7")
}

#spawning umgesetzt wie beschrieben in 
#https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position:
onready var sNachbar_resource = preload("res://src/Bewohner/Nachbar.tscn")
onready var sNachbar_instances = {}
onready var sNachbar_children = {}

func _ready() -> void:
	for name in dictNavTable:
		sNachbar_instances[name] = sNachbar_resource.instance()
		#weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
		sNachbar_instances[name].instanciate(dictNavTable[name].pos, dictNavTable[name].home_name, dictNavTable[name].target_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_for_spawning()

			

func check_for_spawning():
	var erase = []
	for name in sNachbar_instances:
		if dictNavTable[name].target_name != dictNavTable[name].home_name:
			print(str(name) + " adding as a child ...")
			self.add_child(sNachbar_instances[name])
			sNachbar_children[name] = sNachbar_instances[name]
			sNachbar_children[name].target_position=get_node(sNachbar_children[name].target_name).position
			erase.append(name)
			print("... success!")
	for name in erase:
		sNachbar_instances.erase(name)
	erase.clear()

func _on_Wohnungstuer_muell_created(trash: Muell):
	add_child(trash)	

func _on_Wohnungstuer_nachbar_geht_raus(sNachbar1) -> void:
	add_child(sNachbar1)

func _on_Wohnungstuer2_nachbar_geht_raus(sWohnung) -> void:
	$Wohnungstuer2.force_create_muell()
	var Nachbar_W2 = sNachbar_resource.instance()
	#besser wäre ein Konstruktor - wie geht das in gdscript?:
	Nachbar_W2.wohnung = sWohnung
	Nachbar_W2.position = get_node(sWohnung).position + Vector2(0,16)
	dictNachbarn[sWohnung].zuhause = false
	dictNachbarn[sWohnung].hatMuell = true
	self.add_child(Nachbar_W2)
	var file = File.new()
	file.open("res://characters.dat", File.WRITE)
	file.store_var(Nachbar_W2.get_child(0), true)
	file.close()
	print_debug(str(Nachbar_W2.get_child(0).position))



