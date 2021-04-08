extends TextureRect
class_name KarmaBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var karma_00 = preload("res://assets/karmaBar1.png")
var karma_01 = preload("res://assets/karmaBar2.png")
var karma_02 = preload("res://assets/karmaBar3.png")
var karma_03 = preload("res://assets/karmaBar4.png")
var karma_04 = preload("res://assets/karmaBar5.png")
var karma_05 = preload("res://assets/karmaBar6.png")
var karma_06 = preload("res://assets/karmaBar7.png")
var karma_07 = preload("res://assets/karmaBar8.png")
var karma_08 = preload("res://assets/karmaBar9.png")
var karma_09 = preload("res://assets/karmaBar10.png")
var karma_10 = preload("res://assets/karmaBar11.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Kann nur von -5 bis 5 Karma anzeigen
func update_karma(value: int):
	match value:
		-5:
			texture = karma_00
		-4:
			texture = karma_01
		-3:
			texture = karma_02
		-2:
			texture = karma_03
		-1:
			texture = karma_04
		0:
			texture = karma_05
		1:
			texture = karma_06
		2:
			texture = karma_07
		3:
			texture = karma_08
		4:
			texture = karma_09
		5:
			texture = karma_10
		_:
			texture = karma_05
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
