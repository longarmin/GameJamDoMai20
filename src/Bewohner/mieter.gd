extends Bewohner
class_name Mieter

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var carrying_trash: bool = false
var near_trash: Array
var carried_trash: Array
var on_dump := false
var dump: Dump
export var max_trashAmount: int = 5

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

signal trash_collected
signal trash_dropped
signal trash_pickable
signal trash_notPickable
signal trash_dropable
signal trash_notDropable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func _physics_process(_delta: float) -> void:
	playing_animation()


func playing_animation() -> void:
	if _velocity.x > 0:
		if carrying_trash:
			animationPlayer.play("walkingTrash")
		else:
			animationPlayer.play("walking")
	elif _velocity.x < 0:
		if carrying_trash:
			animationPlayer.play("walkingTrash")
		else:
			animationPlayer.play("walking")
	else:
		if carrying_trash:
			animationPlayer.play("defaultTrash")
		else:
			animationPlayer.play("default")


func _on_HitBox_area_entered(area: Area2D) -> void:
	._on_HitBox_area_entered(area)
	if area.has_method("store_trash"):
		on_dump = true
		dump = area
		if dump.get_trashFuellstand() != 0 && carried_trash.size() < max_trashAmount:
			emit_signal("trash_pickable")
			# print("trash_pickable")
		if dump.is_full():
			emit_signal("trash_notDropable")
			# print("trash_notDropable")
	elif area is Trash:
		speed -= self.change_speed(NORMAL_SPEED / 4)
		near_trash.push_back(area)
		if carried_trash.size() < max_trashAmount:
			emit_signal("trash_pickable")
			# print("trash_pickable")


func _on_HitBox_area_exited(area: Area2D) -> void:
	._on_HitBox_area_exited(area)
	if area.has_method("store_trash"):
		on_dump = false
		dump = null
		emit_signal("trash_notPickable")
		# print("trash_notPickable1")
		if carried_trash.size() > 0:
			emit_signal("trash_dropable")
			# print("trash_dropable")
	elif area is Trash:
		speed += self.change_speed(NORMAL_SPEED / 4)
		near_trash.erase(area)
		emit_signal("trash_notPickable")
		# print("trash_notPickable2")
