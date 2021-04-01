extends Bewohner
class_name Player

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var carrying_trash: bool = false
var near_trash: Array
var carried_trash: Array

onready var collectTrashLabel: Label = $CollectTrash
onready var dropTrashLabel: Label = $DropTrash
onready var alaninLabel: Label = $AlaninLabel
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

signal trash_collected
signal trash_dropped


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _physics_process(_delta: float) -> void:
	playing_animation()


func _input(event):
	if event.is_action_pressed("action1"):
		collect_trash()
	if event.is_action_pressed("action2"):
		drop_trash()
	if event.is_action_pressed("ui_up"):
		change_floor()
	if event.is_action_pressed("ui_down"):
		change_floor()


func calculate_direction(_direction) -> Vector2:
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


func collect_trash():
	if near_trash.size() > 0:
		var trash = near_trash[0]
		trash.hide()
		carrying_trash = true
		carried_trash.push_back(trash)
		near_trash.erase(trash)
		speed -= NORMAL_SPEED / 10
		collectTrashLabel.hide()
		dropTrashLabel.show()
		emit_signal("trash_collected", carried_trash.size(), self.position)


func drop_trash():
	if carrying_trash:
		if Input.is_action_just_pressed("action2"):
			var trash: Muell = carried_trash.pop_back()
			if carried_trash.size() == 0:
				carrying_trash = false
				dropTrashLabel.hide()
			trash.position = self.position
			trash.show()
			speed += NORMAL_SPEED / 10
			emit_signal("trash_dropped", carried_trash.size(), self.position)


func playing_animation():
	if _velocity.x > 0:
		if carrying_trash:
			animationPlayer.play("walkingTrash")
		else:
			animationPlayer.play("walking")
	elif _velocity.x < 0:
		if carrying_trash:
			animationPlayer.play("walkingTrash")
		else:
			animationPlayer.play("walking")
	else:
		if carrying_trash:
			animationPlayer.play("defaultTrash")
		else:
			animationPlayer.play("default")


func _on_Muell_player_entered(trash: Muell) -> void:
	near_trash.push_back(trash)
	if carrying_trash == false:
		collectTrashLabel.show()


func _on_Muell_player_exited(trash: Muell) -> void:
	near_trash.erase(trash)
	collectTrashLabel.hide()


func _on_Alanin_body_entered(body):
	if body.name == "Alanin":
		alaninLabel.show()


func _on_Alanin_body_exited(body):
	if body.name == "Alanin":
		alaninLabel.hide()
