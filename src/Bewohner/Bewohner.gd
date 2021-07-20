# Basisklasse fuer den Spieler, Oma und die anderen Bewohner

extends KinematicBody2D
class_name Bewohner

const FLOOR_NORMAL := Vector2.UP
const NORMAL_SPEED := 50.0
const GRAVITY := 3000

export var speed := NORMAL_SPEED
var _velocity := Vector2.ZERO
var direction := Vector2(1, 0)
var on_door := false
var on_stairs := false

# Jeder Bewohner muss mindestens ein Sprite und den Timer timer_climbingStairs haben
onready var sprite: Sprite = $Sprite
onready var timer_climbingStairs: Timer = $timer_climbingStairs

signal stairs_climbing
signal stairs_climbed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(true)
	var error_code = timer_climbingStairs.connect(
		"timeout", self, "_on_timer_climbingStairs_timeout"
	)
	if error_code != 0:
		print("Error: ", error_code)


func _physics_process(_delta: float) -> void:
	var velocity := self._velocity
	direction = self.calculate_direction(direction)
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	set_velo(velocity)
	flip_sprite()


func flip_sprite():
	if direction.x == 0:
		return
	elif direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func calculate_direction(current_direction: Vector2) -> Vector2:
	var new_direction := current_direction
	if new_direction.x == 0:
		print("new_direction.x = 0")
	var rando = randf()
	if rando < 0.001 || is_on_wall():
		new_direction = self.change_direction(current_direction)
	if abs(new_direction.x) < 1:
		print("new_direction.x = 0")
	return new_direction


func calculate_move_velocity(
	linear_velocity: Vector2, current_direction: Vector2, current_speed: float
) -> Vector2:
	var out := linear_velocity
	out.x = current_speed * current_direction.x
	if ! is_on_floor():
		out.y += GRAVITY * get_physics_process_delta_time()
	else:
		out.y = 0
	return out


func change_direction(current_direction: Vector2) -> Vector2:
	current_direction.x = current_direction.x * (-1.0)
	return current_direction


func change_floor() -> void:
	if on_stairs || ! on_door:
		return
	var random = randf()
	if random < 0.3 && self.position.y < 250:
		emit_signal("stairs_climbing")
		timer_climbingStairs.start()
		self.position.y += 96
		self.hide()
	elif random > 0.7 && self.position.y > 150:
		emit_signal("stairs_climbing")
		timer_climbingStairs.start()
		self.position.y -= 96
		self.hide()


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area is Stairwell:
		on_door = true
		change_floor()


func _on_HitBox_area_exited(area: Area2D) -> void:
	if area is Stairwell && ! on_stairs:
		on_door = false


func _on_timer_climbingStairs_timeout():
	on_stairs = false
	emit_signal("stairs_climbed")
	self.show()


func change_speed(decreasingAmount := NORMAL_SPEED / 2) -> float:
	if speed < decreasingAmount:
		return speed
	else:
		return decreasingAmount


func set_velo(velo: Vector2) -> void:
	self._velocity.y = velo.y
	if velo.x != self._velocity.x:
		self._velocity.x = velo.x
