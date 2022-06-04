extends KinematicBody2D
class_name Bewohner

const FLOOR_NORMAL := Vector2.UP
const NORMAL_SPEED := 50.0
const GRAVITY := 3000

export var fSpeed := NORMAL_SPEED
export var iMaxTrashAmount := 5 # Müsste das nicht in BewohnerBase?

var vVelocity := Vector2.ZERO
var vDirection := Vector2(1, 0)
var aTrashBags: Array # Oma hat keine Trashbags
var sName: String
var bIsOnDoor := false
var door: Stairwell
var home: Wohnung

onready var sprite: Sprite = $Sprite
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var stateMachine: StateMachine = $StateMachine
onready var inputManager: InputManager = $InputManager


func _ready():
	pass


func change_speed(fAmount := NORMAL_SPEED / 5) -> float:
	if fSpeed < fAmount:
		return 0.0
	else:
		return fAmount
