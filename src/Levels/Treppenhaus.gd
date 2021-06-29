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

#spawning umgesetzt wie beschrieben in 
#https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position:
onready var sNachbar_resource = preload("res://src/Bewohner/Nachbar.tscn")

func _ready() -> void:
	print(String(dictNachbarn.get("Wohnungstuer2")))
#	$Wohnungstuer.connect("DoorCollision", $Oma, "_on_Door_Collision")
#	$Wohnungstuer2.connect("DoorCollision", $Oma, "_on_Door_Collision")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Wohnungstuer_muell_created(trash: Muell):
	add_child(trash)
	

func _on_Wohnungstuer_nachbar_geht_raus(sNachbar1) -> void:
	add_child(sNachbar1)

func _on_Wohnungstuer2_nachbar_geht_raus(sWohnung) -> void:
	$Wohnungstuer2.force_create_muell()
	var Nachbar_W2 = sNachbar_resource.instance()
	Nachbar_W2.position = get_node(sWohnung).position + Vector2(0,16)
#	Nachbar_W2.collect_trash()
	dictNachbarn[sWohnung].zuhause = false
	dictNachbarn[sWohnung].hatMuell = true
	self.add_child(Nachbar_W2)
	var file = File.new()
	file.open("res://characters.dat", File.WRITE)
	file.store_var(Nachbar_W2.get_child(0), true)
	file.close()
	print_debug(str(Nachbar_W2.get_child(0).position))



