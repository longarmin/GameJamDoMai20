extends Mieter
class_name Nachbar


# Declare member variables here. 
const TIME_FACTOR := 20
const HALDE := 1
const DANEBEN := 2

var drop_time: float = 0.0
var drop_location: int = 0
var allow_drop_on_halde: bool = false
var go_home: bool = false
var wohnung := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_drop_event()
	print(String(wohnung))
	
func _process(delta: float) -> void:
	if !carrying_trash && !go_home:
		collect_trash()
	
func collect_trash():
	if carried_trash.size() >= max_trashAmount:
		return
	var trash: Muell
	if on_muellhalde:
		trash = muellhalde.retrieve_muell()
	elif near_trash.size() > 0:
		trash = near_trash[0]
		trash.hide()
		trash.position.y = 0
		near_trash.erase(trash)
	if trash:
		carrying_trash = true
		carried_trash.push_back(trash)
		speed -= self.change_speed(NORMAL_SPEED / 4)
		emit_signal("trash_collected", carried_trash.size(), self.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	if self.speed == 0:
#		$AnimationPlayer.play("default")
#	elif self.speed != 0:
#		$AnimationPlayer.play("walking")
#func _physics_process(_delta: float) -> void:
#	if self.speed == 0:
#		$AnimationPlayer.play("default")
#	elif self.speed != 0:
#		$AnimationPlayer.play("walking")
#

#func _on_Area2D_area_entered(area: Area2D) -> void:
#	if area.class_name == Muellhalde:
#		area.store_muell(muell)
func drop_trash():
	if carrying_trash:
		var trash: Muell = carried_trash.pop_back()
		if on_muellhalde:
			if ! muellhalde.store_muell(trash):
				carried_trash.append(trash)
				return
		else:
			trash.position = self.position
			trash.position.y -= 7
			trash.show()
		if carried_trash.size() == 0:
			carrying_trash = false
			go_home = true
		speed += self.change_speed(NORMAL_SPEED / 4)
		emit_signal("trash_dropped", carried_trash.size(), self.position)

func set_drop_event():
	drop_time=randf()*TIME_FACTOR
	var temp = randf()
	if temp > 0.2:
		drop_location=HALDE
	else:
		drop_location=DANEBEN
	$DropTrashTimer.wait_time = drop_time
	$DropTrashTimer.start()

func _on_DropTrashTimer_timeout() -> void:
	if drop_location == DANEBEN:
		drop_trash()
	elif drop_location == HALDE:
		allow_drop_on_halde = true

func _on_HitBox_area_entered(area: Area2D) -> void:
	._on_HitBox_area_entered(area)
	print(area.name)
	if area is Stairwell:
		on_door = true
		change_floor()
	elif area is Muellhalde:
		if allow_drop_on_halde:
			drop_trash()
	elif str(area.name) == str(wohnung):
		#funktioniert noch nicht (Nachbar muss in Wohnung2 verschwinden):
		self.queue_free()
