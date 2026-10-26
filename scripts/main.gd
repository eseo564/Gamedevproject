extends Node

var rooms = [
	preload("res://scenes/rooms/room1.tscn"),
	preload("res://scenes/rooms/room2.tscn"),
	preload("res://scenes/rooms/room3.tscn")
]

var current_room_index = 0


func _ready():
	$CanvasLayer/LeftArrow.pressed.connect(_on_left_arrow_pressed)
	$CanvasLayer/RightArrow.pressed.connect(_on_right_arrow_pressed)

	$CanvasLayer/LeftArrow.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	$CanvasLayer/RightArrow.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	load_room()


func load_room():
	# Remove current room
	for room in $CurrentRoom.get_children():
		room.queue_free()

	# Load new room
	var new_room = rooms[current_room_index].instantiate()
	$CurrentRoom.add_child(new_room)

	# Set up pointing cursor for this room
	setup_hover_cursors(new_room)


func setup_hover_cursors(room):
	var interactables = room.get_node("Interactables")

	for interactable in interactables.get_children():
		if interactable is Area2D:
			interactable.mouse_entered.connect(_on_interactable_hover)
			interactable.mouse_exited.connect(_on_interactable_exit)


func _on_interactable_hover():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_interactable_exit():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_right_arrow_pressed():
	current_room_index += 1

	if current_room_index >= rooms.size():
		current_room_index = 0

	load_room()


func _on_left_arrow_pressed():
	current_room_index -= 1

	if current_room_index < 0:
		current_room_index = rooms.size() - 1

	load_room()
	
	
