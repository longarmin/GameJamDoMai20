extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal collectedTrash

var playerNear:bool = false
var playerHasTrash:bool = false
var newTrash:bool = true
var is_collectible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	collect_trash()
	$Label.set_text(str(is_collectible))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#pass

func _on_Muell_body_entered(body: Node) -> void:
	if body.name == "Player":
		playerNear = true

func collect_trash():
	if Input.is_action_just_pressed("action1") && playerNear && is_collectible:
		self.hide()
		newTrash = true
		emit_signal("collectedTrash", self)

func _on_Muell_body_exited(body: Node) -> void:
	if body.name == "Player":
		playerNear = false


func _on_Muell_area_entered(area: Area2D) -> void:
	if newTrash:
		var distanceOptions = [-30, 30]
		self.position.x += distanceOptions[randi() % 2]


func _on_Timer_timeout() -> void:
	newTrash = false
	
func startTimer() -> void:
	$Timer.start()

func _on_CollectTimer_timeout() -> void:
	is_collectible = true
