extends Node2D
onready var dictNachbarn = {
	"Wohnung2":{
		"Bewohner":"Karl",
		"Status":"Zuhause"
	},
	"Wohnung6":{
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
	"Gertrude":neighbour.new($Wohnung3.position,"Wohnung3","Muellhalde3"),
	"Franz":neighbour.new($Wohnung6.position,"Wohnung6","Wohnung6"),
	"Lisa":neighbour.new($Wohnung7.position,"Wohnung7","Wohnung7")
}

#spawning umgesetzt wie beschrieben in 
#https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position:
onready var sNachbar_resource = preload("res://src/Bewohner/Nachbar.tscn")
onready var sNachbar_instances = {}

func _ready() -> void:
	for name in dictNavTable:
		sNachbar_instances[name] = sNachbar_resource.instance()
		#weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
		sNachbar_instances[name].instanciate(dictNavTable[name].pos, dictNavTable[name].home_name, dictNavTable[name].target_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_for_spawning()

func check_for_spawning():
	for name in sNachbar_instances:
		if sNachbar_instances[name].target_name != sNachbar_instances[name].home_name:
			if (!sNachbar_instances[name].child_exists):
				_on_Wohnung_nachbar_geht_raus(sNachbar_instances[name], name)
#				print(str(name) + " adding as a child ...")
#				self.add_child(sNachbar_instances[name])
#				sNachbar_instances[name].target_position=get_node(sNachbar_instances[name].target_name).position
#				sNachbar_instances[name].home_position=get_node(sNachbar_instances[name].home_name).position
#				sNachbar_instances[name].nbname = name 
#				get_node(sNachbar_instances[name].name).connect("nb_goes_home", self, "_on_Nachbar_nb_goes_home")
#				sNachbar_instances[name].child_exists = true
#				print("... success!")

func _on_Wohnung_muell_created(trash: Muell):
	add_child(trash)	

#to be deleted:
func _on_Wohnung_nachbar_geht_raus(sNachbar, nbname) -> void:
	#	add_child(sNachbar1)
	print(str(nbname) + " adding as a child ...")
	self.add_child(sNachbar)
	sNachbar.target_position=get_node(sNachbar.target_name).position
	sNachbar.home_position=get_node(sNachbar.home_name).position
	sNachbar.nbname = str(nbname) 
	get_node(sNachbar.name).connect("nb_goes_home", self, "_on_Nachbar_nb_goes_home")
	sNachbar.child_exists = true
	print("... success!")

#to be deleted:
func _on_Wohnung2_nachbar_geht_raus(sWohnung) -> void:
	pass
#	$Wohnung2.force_create_muell()
#	var Nachbar_W2 = sNachbar_resource.instance()
#	#besser wäre ein Konstruktor - wie geht das in gdscript?:
#	Nachbar_W2.wohnung = sWohnung
#	Nachbar_W2.position = get_node(sWohnung).position + Vector2(0,16)
#	dictNachbarn[sWohnung].zuhause = false
#	dictNachbarn[sWohnung].hatMuell = true
#	self.add_child(Nachbar_W2)
#	var file = File.new()
#	file.open("res://characters.dat", File.WRITE)
#	file.store_var(Nachbar_W2.get_child(0), true)
#	file.close()
#	print_debug(str(Nachbar_W2.get_child(0).position))

func _on_Nachbar_nb_goes_home(nbname) -> void:
	print("Nachbar " + str(nbname) + " geht zurück in Wohnung")
	sNachbar_instances[nbname].hide()
	sNachbar_instances[nbname].child_exists = false
