extends Node2D

export (PackedScene) var Muell

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Timer_timeout() -> void:
	var trash:Area2D = Muell.instance()
	trash.position = $Player.position
	trash.connect("player_entered", $Player, "_on_Muell_player_entered")
	trash.connect("player_exited", $Player, "_on_Muell_player_exited")
	add_child(trash)
