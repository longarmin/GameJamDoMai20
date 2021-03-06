extends Area2D
class_name Muellhalde

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var muellBeutel := []
var object_type : String = "Muelldeponie"
export var maximumMuellAmount := 5

onready var animatonPlayer: AnimationPlayer = $Sprite/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	update_fuellstand()


func store_muell(muell: Muell) -> bool:
	if !is_full():
		muellBeutel.append(muell)
		update_fuellstand()
		return true
	else:
		return false


func retrieve_muell() -> Muell:
	var muell = muellBeutel.pop_back()
	update_fuellstand()
	return muell

func get_muellFuellstand() -> int:
	return muellBeutel.size()

func update_fuellstand() -> void:
	var fuellstand = get_muellFuellstand()
	match fuellstand:
		0:
			animatonPlayer.play("none")
		1:
			animatonPlayer.play("low")
		2, 3:
			animatonPlayer.play("mid")
		4, 5:
			animatonPlayer.play("high")
		_:
			animatonPlayer.play("none")


func is_full() -> bool:
	if muellBeutel.size() < maximumMuellAmount:
		return false
	else:
		return true
