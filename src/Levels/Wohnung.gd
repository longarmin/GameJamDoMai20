extends Muellhalde
export (PackedScene) var Muell
#export (PackedScene) var Bewohner.Nachbar

var fMuellInWohnung_Menge := 0.0
var bNachbar_zuhause := false
var bNachbar_gehtraus := false
#var sNachbar = preload("res://src/Bewohner/Nachbar.tscn")

signal muell_created
signal nachbar_geht_raus

func _ready() -> void:
	#Krücke, um sicherzustellen, dass Bewohner erst die Wohnung
	#verlässt, NACHDEM Müll vor die Tür gestellt wurde, damit er
	#ihn aufsammelt
	$create_bewohner.start()
	self.object_type = "Wohnung"

func _process(_delta):
	if bNachbar_zuhause:
		if bNachbar_gehtraus:
			emit_signal("nachbar_geht_raus", "Wohnung2")
			bNachbar_zuhause = false
	if fMuellInWohnung_Menge > 1:
		var trash: Muell = Muell.instance()
		if self.store_muell(trash):
			fMuellInWohnung_Menge = 0
			emit_signal("muell_created", trash)

func force_create_muell():
	var trash: Muell = Muell.instance()
	if self.store_muell(trash):
			emit_signal("muell_created", trash)

func _on_Timer_timeout():
	if randf() > 0.0:
		fMuellInWohnung_Menge += 0.25
	if bNachbar_zuhause:
		if randf() < .5:
			bNachbar_gehtraus = true


func _on_create_bewohner_timeout() -> void:
	bNachbar_zuhause = true
