extends CanvasLayer

onready var trashBox: TrashBoxContainer = $GridContainer/TrashBoxContainer
onready var karmaBox: KarmaBoxContainer = $GridContainer/KarmaBoxContainer
onready var buttonBox: ButtonBoxContainer = $GridContainer/ButtonBoxContainer
onready var speechBubble: SpeechBubble = $SpeechBubble

func _ready() -> void:
	pass  # Replace with function body.

func _on_Player_trash_collected(trash_amount: int, _pos_player: Vector2) -> void:
	trashBox.update_trash(trash_amount)
	buttonBox.update_trash_dropable(true)


func _on_Player_trash_dropped(trash_amount: int, _pos_player: Vector2) -> void:
	trashBox.update_trash(trash_amount)
	if trash_amount == 0:
		buttonBox.update_trash_dropable(false)


func _on_Oma_karmachange(iKarma) -> void:
	karmaBox.update_karma(iKarma)


func _on_Oma_dialogue(sCharacter, sText) -> void:
	speechBubble.set_text("[color=red]" + sCharacter + ": [/color]" + sText)


func _on_Player_trash_left(player: Player):
	if player.carried_trash.size() > 0:
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
