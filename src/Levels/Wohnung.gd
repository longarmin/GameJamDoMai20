extends Dump
class_name Wohnung

export (PackedScene) var Trash
export (PackedScene) var Neighbour

var fTrashInWohnung_Menge := 0.0
var bNachbar_zuhause := false
var bNachbar_gehtraus := false
var aNeighbours: Array = []

signal trash_created(trashCreated)
signal nachbar_geht_raus(neighbourExited)

onready var bewohnerCreator: Timer = $create_bewohner


func _ready() -> void:
	self.object_type = "Wohnung"


func _process(_delta):
	if bNachbar_zuhause:
		if bNachbar_gehtraus:
			emit_signal("nachbar_geht_raus", self.name)
			bNachbar_zuhause = false
	if fTrashInWohnung_Menge > 1:
		create_trash()


func force_create_trash():
	create_trash()


func create_trash():
	var trash: Trash = Trash.instance()
	if self.store_trash(trash):
		fTrashInWohnung_Menge = 0
		emit_signal("trash_created", trash)


func _on_Timer_timeout():
	if randf() > 0.0:
		fTrashInWohnung_Menge += 0.25
	if bNachbar_zuhause:
		if randf() < .5:
			bNachbar_gehtraus = true


func enter_flat(neighbourEntering: Neighbour) -> void:
	var message = Message.new()
	message.status = 6
	message.content = "Neighbour enters flat"
	message.emitter = "Flat"
	neighbourEntering.stateMachine.respond_to(message)
	aNeighbours.append(neighbourEntering)


func exit_flat(neighbourExiting: Neighbour) -> void:
	print(neighbourExiting.sNeighbour + " showing up ...")
	aNeighbours.erase(neighbourExiting)
	var message = Message.new()
	message.status = 7
	message.content = "Neighbour exits flat"
	message.emitter = "Flat"
	neighbourExiting.stateMachine.respond_to(message)
	# warning-ignore:unsafe_property_access
	neighbourExiting.vTargetPosition = get_parent().get_node(neighbourExiting.sTarget).position
	neighbourExiting.bHasChild = true
	emit_signal("nachbar_geht_raus", neighbourExiting)
	print("... success!")


func _on_Wohnung_trash_created(_trash):
	if aNeighbours.size() > 0:
		exit_flat(aNeighbours[0])
