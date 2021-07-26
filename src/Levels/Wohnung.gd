extends Dump
export (PackedScene) var Trash

class_name Wohnung
#export (PackedScene) var Bewohner.Nachbar

var fTrashInWohnung_Menge := 0.0
var bNachbar_zuhause := false
var bNachbar_gehtraus := false
#var sNachbar = preload("res://src/Bewohner/Nachbar.tscn")

signal trash_created
signal nachbar_geht_raus


func _ready() -> void:
	#Kr�cke, um sicherzustellen, dass Bewohner erst die Wohnung
	#verl�sst, NACHDEM M�ll vor die T�r gestellt wurde, damit er
	#ihn aufsammelt
	$create_bewohner.start()
	self.object_type = "Wohnung"


func _process(_delta):
	if bNachbar_zuhause:
		if bNachbar_gehtraus:
			emit_signal("nachbar_geht_raus", "Wohnung2")
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


func _on_create_bewohner_timeout() -> void:
	bNachbar_zuhause = true
