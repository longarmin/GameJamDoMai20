class_name Muell
extends Area2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal player_entered(node)
signal player_exited(node)

var playerNear:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#pass

func _on_Muell_body_entered(body: Node) -> void:
	if body.name == "Player":
		playerNear = true
		emit_signal("player_entered", self)

func _on_Muell_body_exited(body: Node) -> void:
	if body.name == "Player":
		playerNear = false
		emit_signal("player_exited", self)

func _on_Muell_area_entered(area: Area2D) -> void:
	if area.name == "Muell":
		var distanceOptionsX = [-30, -15, 15, 30]
		self.position.x += distanceOptionsX[randi() % 4]


