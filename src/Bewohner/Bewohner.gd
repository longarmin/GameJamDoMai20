extends KinematicBody2D
class_name Bewohner

const FLOOR_NORMAL:= Vector2.UP

export var speed: = Vector2(150.0, 1000.0)
export var gravity: = 3000.0
var _velocity:= Vector2.ZERO
var on_stairs: bool = false

var popularity: = 0

#func _physics_process(delta: float) -> void:
#	_velocity.y += gravity * delta
