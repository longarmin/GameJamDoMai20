extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal collectedTrash

var playerNear:bool = false
var playerHasTrash:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	collect_trash()
	$Label.set_text(str(playerNear))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#pass

func _on_Muell_body_entered(body: Node) -> void:
	if body.name == "Player":
		playerNear = true
		

func collect_trash():
	if Input.is_action_just_pressed("ui_accept") && playerNear:
		emit_signal("collectedTrash", self)
		self.hide()

func _on_Muell_body_exited(body: Node) -> void:
	if body.name == "Player":
		playerNear = false
