extends Dump
class_name Wohnung

export(PackedScene) var Trash

var fTrashInWohnung_Menge := 0.0
var aNeighbours: Array = []

signal trash_created(trashCreated)


func _ready() -> void:
	self.object_type = "Wohnung"


func _process(_delta):
	if fTrashInWohnung_Menge > 1:
		create_trash()
	if aNeighbours.size() > 0 && aTrashBags.size() > 0:
		exit_flat(aNeighbours[0])


func force_create_trash():
	create_trash()


func create_trash():
	var trash: Trash = Trash.instance()
	if self.store_trash(trash):
		fTrashInWohnung_Menge = 0
		emit_signal("trash_created", trash)


func _on_Timer_timeout():
	if randf() > 0.5 && aNeighbours.size() > 0:
		fTrashInWohnung_Menge += 0.25


func enter_flat(neighbourEntering) -> void:
	var message = Message.new()
	message.status = 6
	message.content = "Neighbour enters flat"
	message.emitter = "Flat"
	neighbourEntering.stateMachine.respond_to(message)
	aNeighbours.append(neighbourEntering)


func exit_flat(neighbourExiting) -> void:
	# Fuer den Fall, dass der Nachbar in seiner Wohnung das Spiel verliert.
	# Wie auch immer das moeglich ist...
	if neighbourExiting == null:
		return
	if neighbourExiting.target != self:
		aNeighbours.erase(neighbourExiting)
		var message = Message.new()
		message.status = 7
		message.content = "Neighbour exits flat"
		message.emitter = "Flat"
		neighbourExiting.stateMachine.respond_to(message)


func _on_Wohnung_trash_created(_trash):
	if aNeighbours.size() > 0:
		exit_flat(aNeighbours[0])
