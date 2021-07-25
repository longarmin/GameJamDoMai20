extends Mieter
class_name Player

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		collect_trash()
	if event.is_action_pressed("action2"):
		drop_trash()
	if event.is_action_pressed("ui_up"):
		change_floor()
	if event.is_action_pressed("ui_down"):
		change_floor()


func calculate_direction(_direction: Vector2) -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)


func change_floor() -> void:
	if on_stairs:
		return
	if on_door && Input.is_action_pressed("ui_up") && self.position.y > 150:
		self.position.y -= 96
		on_stairs = true
		emit_signal("stairs_climbing")
		timer_climbingStairs.start()
		self.hide()
	elif on_door && Input.is_action_pressed("ui_down") && self.position.y < 250:
		self.position.y += 96
		on_stairs = true
		emit_signal("stairs_climbing")
		timer_climbingStairs.start()
		self.hide()


func collect_trash() -> void:
	if carried_trash.size() >= max_trashAmount:
		return
	var trash: Trash
	if on_dump:
		trash = dump.retrieve_trash()
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


func drop_trash() -> void:
	if carrying_trash:
		if Input.is_action_just_pressed("action2"):
			var trash: Trash = carried_trash.pop_back()
			if on_dump:
				if ! dump.store_trash(trash):
					carried_trash.append(trash)
					return
			else:
				trash.position = self.position
				trash.position.y -= 7
				trash.show()
			if carried_trash.size() == 0:
				carrying_trash = false
			speed += self.change_speed(NORMAL_SPEED / 4)
			emit_signal("trash_dropped", carried_trash.size(), self.position)
