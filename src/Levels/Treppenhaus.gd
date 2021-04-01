extends Node2D
export (PackedScene) var Muell

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	$Wohnungstuer.connect("DoorCollision", $Oma, "_on_Door_Collision")
#	$Wohnungstuer2.connect("DoorCollision", $Oma, "_on_Door_Collision")
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Wohnungstuer_muell_created(trash: Muell):
	add_child(trash)
