extends Mieter
class_name Nachbar


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func collect_trash():
	if carried_trash.size() >= max_trashAmount:
		return
	var trash: Muell
	if on_muellhalde:
		trash = muellhalde.retrieve_muell()
	elif near_trash.size() > 0:
		trash = near_trash[0]
		trash.hide()
		trash.position.y = 0
		near_trash.erase(trash)
	if trash:
		carrying_trash = true
		carried_trash.push_back(trash)
		speed -= self.change_speed(NORMAL_SPEED / 4)
		emit_signal("trash_collected", carried_trash.size(), self.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	if self.speed == 0:
#		$AnimationPlayer.play("default")
#	elif self.speed != 0:
#		$AnimationPlayer.play("walking")
#func _physics_process(_delta: float) -> void:
#	if self.speed == 0:
#		$AnimationPlayer.play("default")
#	elif self.speed != 0:
#		$AnimationPlayer.play("walking")
#

#func _on_Area2D_area_entered(area: Area2D) -> void:
#	if area.class_name == Muellhalde:
#		area.store_muell(muell)
