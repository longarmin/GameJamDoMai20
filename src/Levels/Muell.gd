extends Area2D
class_name Muell

func _ready() -> void:
	pass  # Replace with function body.

func _on_Muell_area_entered(area: Area2D) -> void:
	if area.name == "Muell":
		var distanceOptionsX = [-30, -15, 15, 30]
		self.position.x += distanceOptionsX[randi() % 4]
