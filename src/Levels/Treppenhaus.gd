extends Node2D

onready var sNachbar_resource = preload("res://src/Bewohner/Nachbar.tscn")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawning umgesetzt wie beschrieben in 
	#https://godotengine.org/qa/8025/how-to-add-a-child-in-a-specific-position:
#	$Wohnungstuer.connect("DoorCollision", $Oma, "_on_Door_Collision")
#	$Wohnungstuer2.connect("DoorCollision", $Oma, "_on_Door_Collision")
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Wohnungstuer_muell_created(trash: Muell):
	add_child(trash)
	

func _on_Wohnungstuer_nachbar_geht_raus(sNachbar1) -> void:
	add_child(sNachbar1)

func _on_Wohnungstuer2_nachbar_geht_raus(sNachbar2) -> void:
	var Nachbar_test = sNachbar_resource.instance()
	Nachbar_test.position = $Wohnungstuer2.position
	self.add_child(Nachbar_test)
	print_debug(str($Wohnungstuer2.position))
	print_debug(str(Nachbar_test.get_child(0)))
	print_debug(str(Nachbar_test.get_child(0).position))
	#sNachbar.get_child(0).position = $Wohnungstuer2.position
	print_debug(str(Nachbar_test.get_child(0).position))
	
	
	#$sNachbar2.position = $Wohnungstuer2.position
