extends Bewohner
class_name Player

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var carrying_trash: bool = false
var near_trash: Array
var carried_trash: Array
var on_door: bool = false
var climbing_stairs: bool = false

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var collectTrashLabel: Label = $CollectTrash
onready var dropTrashLabel: Label = $DropTrash
onready var alaninLabel: Label = $AlaninLabel
onready var timer_climbingStairs: Timer = $timer_climbingStairs

signal trash_collected
signal trash_dropped
signal stairs_climbing
signal stairs_climbed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _physics_process(_delta: float) -> void:
	var direction := get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	change_floor()
	drop_trash()
	collect_trash()
	playing_animation()


func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var out := linear_velocity
	out.x = speed.x * direction.x
	if ! is_on_floor():
		out.y += gravity * get_physics_process_delta_time()
	else:
		out.y = 0
	return out


func change_floor() -> void:
	if climbing_stairs:
		return
	if on_door && Input.is_action_pressed("ui_up") && self.position.y > 150:
		self.position.y -= 96
		climbing_stairs = true
		emit_signal("stairs_climbing")
		timer_climbingStairs.start()
		self.hide()
	elif on_door && Input.is_action_pressed("ui_down") && self.position.y < 250:
		self.position.y += 96
		climbing_stairs = true
		emit_signal("stairs_climbing")
		timer_climbingStairs.start()
		self.hide()


func collect_trash():
	if near_trash.size() > 0 && Input.is_action_just_pressed("action1"):
		var trash = near_trash[0]
		trash.hide()
		carrying_trash = true
		carried_trash.push_back(trash)
		near_trash.erase(trash)
		speed.x -= 30
		collectTrashLabel.hide()
		dropTrashLabel.show()
		emit_signal("trash_collected", carried_trash.size())


func drop_trash():
	if carrying_trash:
		if Input.is_action_just_pressed("action2"):
			var trash: Muell = carried_trash.pop_back()
			if carried_trash.size() == 0:
				carrying_trash = false
				dropTrashLabel.hide()
			trash.position = self.position
			trash.show()
			speed.x += 30
			emit_signal("trash_dropped", carried_trash.size())


func playing_animation():
	if _velocity.x > 0:
		if carrying_trash:
			animated_sprite.play("walkingTrash")
		else:
			animated_sprite.play("walking")
		animated_sprite.flip_h = false
	elif _velocity.x < 0:
		if carrying_trash:
			animated_sprite.play("walkingTrash")
		else:
			animated_sprite.play("walking")
		animated_sprite.flip_h = true
	else:
		if carrying_trash:
			animated_sprite.play("defaultTrash")
		else:
			animated_sprite.play("default")


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


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area is Stairwell:
		on_door = true


func _on_HitBox_area_exited(area: Area2D) -> void:
	if area is Stairwell && ! climbing_stairs:
		on_door = false


func _on_timer_climbingStairs_timeout():
	climbing_stairs = false
	emit_signal("stairs_climbed")
	self.show()
