extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP
const NORMAL_SPEED := 50.0
const GRAVITY := 3000
const SNAP := Vector2.DOWN

export var speed := NORMAL_SPEED
var _velocity := Vector2.ZERO
var direction := Vector2(1, 0)
