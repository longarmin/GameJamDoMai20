# Boilerplate class to get full autocompletion and type checks for the `bewohner` when coding the bewohner's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name BewohnerState
extends State

# Typed reference to the bewohner node.
var bewohner: NPC


func _ready() -> void:
	# The states are children of the `Bewohner` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Bewohner` type.
	# If the `owner` is not a `Bewohner`, we'll get `null`.
	bewohner = owner as NPC
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Bewohner.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(bewohner != null)
