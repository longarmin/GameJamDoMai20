extends KinematicBody2D
class_name Bewohner

const FLOOR_NORMAL:= Vector2.UP

# warning-ignore:unused_class_variable
export var speed := Vector2(150.0, 1000.0)
# warning-ignore:unused_class_variable
export var gravity := 3000.0
# warning-ignore:unused_class_variable
var _velocity := Vector2.ZERO

# warning-ignore:unused_class_variable
var popularity: = 0

#func _physics_process(delta: float) -> void:
#	_velocity.y += gravity * delta
