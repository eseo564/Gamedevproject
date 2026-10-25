extends Node

var rooms = [
	preload("res://scenes/rooms/room1.tscn"),
	preload("res://scenes/rooms/room2.tscn"),
	preload("res://scenes/rooms/room3.tscn"),
	preload("res://scenes/rooms/tolietroom.tscn")
]

var current_room_index = 0


func _ready():
	$CanvasLayer/LeftArrow.pressed.connect(_on_left_arrow_pressed)
	$CanvasLayer/RightArrow.pressed.connect(_on_right_arrow_pressed)

	# TEMPORARY INVENTORY TEST
	Inventory.add_item("bucket")
	Inventory.add_item("matches")
	Inventory.add_item("cheese")
	load_room()


func load_room():
	# Remove the current room
	for room in $CurrentRoom.get_children():
		room.queue_free()

	# Add the new room
	var new_room = rooms[current_room_index].instantiate()
	$CurrentRoom.add_child(new_room)


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
