extends BewohnerNPC
class_name Nachbar


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	if self.speed == 0:
#		$AnimationPlayer.play("default")
#	elif self.speed != 0:
#		$AnimationPlayer.play("walking")
func _physics_process(_delta: float) -> void:
	if self.speed == 0:
		$AnimationPlayer.play("default")
	elif self.speed != 0:
		$AnimationPlayer.play("walking")


#func _on_Area2D_area_entered(area: Area2D) -> void:
#	if area.class_name == Muellhalde:
#		area.store_muell(muell)
