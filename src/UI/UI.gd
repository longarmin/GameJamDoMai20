extends CanvasLayer

onready var trashBox: TrashBoxContainer = $GridContainer/TrashBoxContainer
onready var karmaBox: KarmaBoxContainer = $GridContainer/KarmaBoxContainer
onready var buttonBox: ButtonBoxContainer = $GridContainer/ButtonBoxContainer
onready var speechBubble: SpeechBubble = $SpeechBubble


func _ready() -> void:
	assert(Events.connect("dialog_started", self, "_on_Oma_dialogue") == 0)
	assert(Events.connect("karma_changed", self, "_on_Oma_karmachange") == 0)
	assert(Events.connect("trash_picked", self, "_on_Player_trash_picked") == 0)
	assert(Events.connect("trash_dropped", self, "_on_Player_trash_dropped") == 0)


func _on_Player_trash_picked(bewohner: BewohnerBase) -> void:
	if bewohner.name == "Player":
		trashBox.update_trash(bewohner.aTrashBags.size())
		buttonBox.update_trash_dropable(true)


func _on_Player_trash_dropped(bewohner: BewohnerBase) -> void:
	if bewohner.name == "Player":
		trashBox.update_trash(bewohner.aTrashBags.size())
		if bewohner.aTrashBags.size() == 0:
			buttonBox.update_trash_dropable(false)


func _on_Oma_karmachange(iKarma) -> void:
	karmaBox.update_karma(iKarma)


func _on_Oma_dialogue(sCharacter, sText) -> void:
	speechBubble.set_text("[color=red]" + sCharacter + ": [/color]" + sText)


func _on_Player_trash_left(bewohner: BewohnerBase):
	if bewohner.name == "Player":
		if bewohner.aTrashBags.size() > 0:
			return
		else:
			buttonBox.update_trash_dropable(false)


func _on_Player_trash_pickable():
	buttonBox.update_trash_pickable(true)


func _on_Player_trash_notPickable():
	buttonBox.update_trash_pickable(false)


func _on_Player_trash_dropable():
	buttonBox.update_trash_dropable(true)


func _on_Player_trash_notDropable():
	buttonBox.update_trash_dropable(false)
