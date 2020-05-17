extends Node2D
export (PackedScene) var Muell

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	$Wohnungstuer.connect("DoorCollision", $Oma, "_on_Door_Collision")
#	$Wohnungstuer2.connect("DoorCollision", $Oma, "_on_Door_Collision")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Timer_timeout() -> void:
	var trash:Node = Muell.instance()
	trash.position.x = $Player.position.x
	trash.position.y = $Player.position.y - 10
	trash.connect("player_entered", $Player, "_on_Muell_player_entered")
	trash.connect("player_exited", $Player, "_on_Muell_player_exited")
	add_child(trash)
