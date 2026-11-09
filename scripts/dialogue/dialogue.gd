extends CanvasLayer

signal finished

@onready var box = $TextureRect
@onready var label = $TextureRect/Label

const REVEAL_SPEED = 0.05  # seconds per letter, lower = faster

var waiting_for_click = false
var revealing = false


func _ready():
	box.hide()


func show_text(text: String):
	waiting_for_click = false
	label.text = text              # Set the full text immediately
	label.visible_characters = 0   # Hide it all to start
	box.show()
	await get_tree().process_frame  # skips the click that opened the box
	await _type_text(text)
	waiting_for_click = true
	await finished


func _type_text(text: String):
	revealing = true

	# Loop through the total character count from left to right
	for i in range(1, text.length() + 1):
		if not revealing:
			break  # player clicked to skip
		label.visible_characters = i
		await get_tree().create_timer(REVEAL_SPEED).timeout

	label.visible_ratio = 1.0  # Instantly show all text if skipped
	revealing = false


func _input(event):
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return

	if revealing:
		get_viewport().set_input_as_handled()
		revealing = false  # first click finishes the animation
	elif waiting_for_click:
		get_viewport().set_input_as_handled()
		waiting_for_click = false
		box.hide()
		finished.emit()
