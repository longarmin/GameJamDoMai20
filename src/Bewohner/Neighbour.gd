extends BewohnerBase
class_name Neighbour

# Declare member variables here.
const TIME_FACTOR := 20
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 30
const STANDARD_TIME_IDLE := 15

var bAllowDropOnHalde: bool = true

onready var nameLabel: Label = $Label
onready var eventManager: EventManager = $EventManager


func _ready() -> void:
	nameLabel.text = sName


# weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
func instanciate(homeNew: Wohnung, sNeighbourName: String, fSpeedNew: float = fSpeed) -> void:
	position = homeNew.position + Vector2(0, 20)
	home = homeNew
	sName = sNeighbourName
	fSpeed = fSpeedNew


func _on_Hitbox_area_entered(area: Area2D) -> void:
	._on_Hitbox_area_entered(area)
	if eventManager.current_event != null:
		if area is Dump && abs(eventManager.current_event.target.position.x - area.position.x) < 5:
			var message = Message.new(2, "Neighbour on Dump", self)
			stateMachine.respond_to(message)

		# Check, ob Neighbour wieder in seine Flat zurueck soll:
		if area == eventManager.current_event.target:
			# neues Ziel setzen: Flat des Neighbour
			eventManager.remove_current_event()

	else: #if target equals 0
		if area == home:
			# warning-ignore:unsafe_method_access
			area.enter_flat(self)


func _on_Hitbox_area_exited(area: Area2D) -> void:
	# Trash mitnehmen, wenn welcher vor der eigenen Wohnung liegt
	if area == home:
		var message = Message.new(3, "Neighbour on Flat", self)
		stateMachine.respond_to(message)
	._on_Hitbox_area_exited(area)


func activate_new_target() -> bool:
	eventManager.activate_new_event()
	if eventManager.current_event:
		return true
	else:
		return false
