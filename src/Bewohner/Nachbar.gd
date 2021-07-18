extends Mieter
class_name Nachbar


# Declare member variables here. 
const TIME_FACTOR := 20
const HALDE := 1
const DANEBEN := 2
const WOHNUNG := 3
const STAIRWELLDOOR_POSX := 272
const MAX_Y_DELTA_ON_SAME_LEVEL := 30
const STANDARD_TIME_IDLE := 5

signal nb_goes_home(nbname)

var allow_drop_on_halde: bool = false
var child_exists: bool = false
var drop_time: float = 0.0
var drop_location: int = 0
var go_home: bool = false
var home_name = ""
var home_position : Vector2 = Vector2(0,0)
var nbname: String = ""
var wohnung := ""
var target := HALDE
var target_name = ""
var target_position : Vector2 = Vector2(0,0)
var queue_neighbour_events := []
var counter : int = 0

class neighbour_event:
	var target_name: String = ""
	var target_position: Vector2 = Vector2(0, 0)
	var countdown_val: float = 0.0
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_drop_event()
	$EvtCountdownTimer.wait_time = STANDARD_TIME_IDLE
	$EvtCountdownTimer.start()
	
func _process(delta: float) -> void:
	counter = counter + 1
	if counter > 30:
		print("time_left: " + str($EvtCountdownTimer.time_left))
		counter = 0
	if !carrying_trash && !go_home:
		collect_trash()

func push_neighbour_event(target_name:String, target_position:Vector2, countdown_val:float):
	var temp = neighbour_event.new()
	temp.target_name = target_name
	temp.target_position = target_position
	temp.countdown_val = countdown_val
	self.queue_neighbour_events.push_back(temp)
	
func calculate_direction(current_direction: Vector2) -> Vector2:
	var dir : float
	#t=target
	var t = target_position
	#i=instance
	var i = self.position
	var abs_delta_y = abs(t.y - i.y)
	if (abs_delta_y <= MAX_Y_DELTA_ON_SAME_LEVEL):
		dir = sign(t.x - i.x)
	else:
		dir = sign(STAIRWELLDOOR_POSX - i.x)
	dir = dir*abs(current_direction.x)
	return Vector2(dir, current_direction.y)
	
func change_floor() -> void:
	var DeltaY = self.target_position.y - self.position.y
	if on_stairs || ! on_door:
		return
	if  DeltaY > MAX_Y_DELTA_ON_SAME_LEVEL && self.position.y < 250:
		emit_signal("stairs_descending")
		timer_climbingStairs.start()
		self.position.y += 96
		self.hide()
	elif DeltaY < -MAX_Y_DELTA_ON_SAME_LEVEL && self.position.y > 150:
		emit_signal("stairs_ascending")
		timer_climbingStairs.start()
		self.position.y -= 96
		self.hide()
	elif abs(DeltaY) <= MAX_Y_DELTA_ON_SAME_LEVEL:
		pass
	
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
		
#weil Godot anscheinend (noch) keinen guten Konstruktor fuer scenes hat:
func instanciate(pos:=Vector2(0,0), home_name:="", target_name:=""):
	self.position = pos
	self.home_name = home_name
	self.target_name = target_name
	
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
	if area is Stairwell:
		on_door = true
		change_floor()
	elif area is Muellhalde:
		if allow_drop_on_halde:
			drop_trash()

	#Check, ob Nachbar wieder in seine Wohnung zurueck soll:
	if area.name == self.target_name:
		self.target_name = self.home_name
		self.target_position = self.home_position
		self.go_home = true
		
	#Hier bloß kein elif, da Wohnung auch von der Klasse Muellhalde ist
	if self.go_home:
		print("area.name=" + str(area.name) + " self.home_name=" + str(self.home_name))
		if str(area.name) == str(self.home_name):
			emit_signal("nb_goes_home", self.nbname)
	
func _on_EvtCountdownTimer_timeout() -> void:
	var temp = self.queue_neighbour_events.pop_front()
	if temp != null:
		self.go_home = false
		self.target_name = temp.target_name
		$EvtCountdownTimer.wait_time = temp.countdown_val
		$EvtCountdownTimer.start()
	else:
		self.target_name = self.home_name
		self.go_home = true
		$EvtCountdownTimer.wait_time = STANDARD_TIME_IDLE
		$EvtCountdownTimer.start()
		

		


func _on_Nachbar_nb_goes_home(nbname) -> void:
	print("Nachbar " + str(nbname) + " geht zurück in Wohnung")
	self.child_exists = false
	self.hide()
