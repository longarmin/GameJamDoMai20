tool
extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer
export var next_scene: PackedScene

func _get_configuration_warning() -> String:
	return "The next scene property can't be empty!" if not next_scene else ""

func _on_Portal2D_body_entered(body: PhysicsBody2D) -> void:
	teleport()
		
func teleport() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)

