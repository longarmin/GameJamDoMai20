extends Area2D
class_name Trash


func _ready() -> void:
	pass  # Replace with function body.


func _on_Trash_area_entered(area: Area2D) -> void:
	if area.name == "Trash":
		var distanceOptionsX = [-30, -15, 15, 30]
		self.position.x += distanceOptionsX[randi() % 4]


func is_pickable() -> bool:
	return true


func pick_up() -> Trash:
	self.hide()
	self.position.y = 0
	return self
