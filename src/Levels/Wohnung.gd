extends Dump
class_name Wohnung

export(PackedScene) var Trash
export var fTrashCreationSpeed: float = 0.5

var fTrashInWohnung_Menge := 0.0
var aNeighbours: Array = []

onready var wohnungTrashTimer: Timer = $WohnungTrashTimer


func _ready() -> void:
	pass


func _process(_delta):
	if fTrashInWohnung_Menge > 1:
		create_trash()
	if aNeighbours.size() > 0 && (aTrashBags.size() > 0 || aNeighbours[0].sName == "Oma"):
		exit_flat(aNeighbours[0])


func force_create_trash():
	create_trash()


func create_trash():
	var trash: Trash = Trash.instance()
	if self.store_trash(trash):
		fTrashInWohnung_Menge = 0
		Events.emit_signal("trash_spawned", trash)


func _on_Timer_timeout():
	if aNeighbours.size() > 0 && aNeighbours[0].sName != "Oma":
		fTrashInWohnung_Menge += fTrashCreationSpeed
	wohnungTrashTimer.start(randi() % 10 + 3)


func enter_flat(neighbourEntering) -> void:
	var message = Message.new(6, "Neighbour enters flat", self)
	neighbourEntering.stateMachine.respond_to(message)
	aNeighbours.append(neighbourEntering)


func exit_flat(neighbourExiting) -> void:
	# Fuer den Fall, dass der Nachbar in seiner Wohnung das Spiel verliert.
	# Wie auch immer das moeglich ist...
	if neighbourExiting == null:
		return
	if neighbourExiting.target != self:
		if neighbourExiting.activate_new_target():
			aNeighbours.erase(neighbourExiting)
			var message = Message.new(7, "Neighbour exits flat", self)
			neighbourExiting.stateMachine.respond_to(message)


func force_exit():
	if aNeighbours.size() > 0:
		exit_flat(aNeighbours[0])


func setText(sName):
	$Label.text = sName
