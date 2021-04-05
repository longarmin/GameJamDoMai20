extends Area2D
class_name Muell

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#pass


func _on_Muell_area_entered(area: Area2D) -> void:
	if area.name == "Muell":
		var distanceOptionsX = [-30, -15, 15, 30]
		self.position.x += distanceOptionsX[randi() % 4]
