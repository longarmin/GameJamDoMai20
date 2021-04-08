extends Control
class_name SpeechBubble

onready var text_node: RichTextLabel = $Anchor/RichTextLabel
onready var timer: Timer = $Timer
onready var tween: Tween = $Tween

const char_time = 0.03
const margin_offset = 4


func _ready() -> void:
	visible = false


func set_text(text, wait_time = 3):
	visible = true

	timer.wait_time = wait_time
	timer.stop()

	text_node.bbcode_text = text

	# Duration
	var duration = text_node.text.length() * char_time

	# Set the size of the speech bubble
	var text_size = text_node.get_font("normal_font").get_string_size(text_node.text)
	text_node.margin_right = text_size.x + margin_offset
	#text_bg.margin_right = text_size.x + margin_offset

	# Animation
	tween.remove_all()
	tween.interpolate_property(text_node, "percent_visible", 0, 1, duration)
	#tween.interpolate_property(text_bg, "margin_right", 0, text_size.x + margin_offset, duration)
	#tween.interpolate_property($Anchor, "position", Vector2.ZERO, Vector2(-text_size.x/2, 0), duration)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	timer.start()


func _on_Timer_timeout() -> void:
	visible = false
