extends Muellhalde
export (PackedScene) var Muell

var muellInFlat_amount := 0.0

signal muell_created


func _process(_delta):
	if muellInFlat_amount > 1:
		var trash: Muell = Muell.instance()
		if self.store_muell(trash):
			muellInFlat_amount = 0
			emit_signal("muell_created", trash)


func _on_Timer_timeout():
	if randf() > 0.5:
		muellInFlat_amount += 0.25
