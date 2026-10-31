extends Node2D

@onready var background = $Background
@onready var door = $Interactables/Door
@onready var toolbox = $Interactables/Toolbox
@onready var sewer = $Interactables/Sewer

var bg_start = preload("res://assets/backgrounds/room3/room3_start.png")
var bg_padlock_complete = preload("res://assets/backgrounds/room3/room3_padlock_complete.png")
var bg_toolbox_opened = preload("res://assets/backgrounds/room3/room3_toolbox_opened.png")
var bg_crowbar_collected = preload("res://assets/backgrounds/room3/room3_crowbar_collected.png")
var bg_sewers_opened = preload("res://assets/backgrounds/room3/room3_sewers_opened.png")


func _ready():
	door.input_event.connect(_on_door_clicked)
	toolbox.input_event.connect(_on_toolbox_clicked)
	sewer.input_event.connect(_on_sewer_clicked)

	update_room()


func _on_door_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_door()


func _on_toolbox_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_toolbox()


func _on_sewer_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_sewer()


func interact_with_door():
	pass


func interact_with_toolbox():
	if GameManager.toolbox_opened:
		if not GameManager.crowbar_acquired:
			GameManager.crowbar_acquired = true
			Inventory.add_item("crowbar")
			update_room()
		return

	if GameManager.padlock_dial_attached:
		get_tree().current_scene.show_padlock()
		return

	if Inventory.selected_item == "padlock_dial":
		GameManager.padlock_dial_attached = true
		Inventory.remove_item("padlock_dial")
		update_room()


func interact_with_sewer():
	if GameManager.sewer_opened:
		get_tree().change_scene_to_file("res://scenes/win.tscn")
		return

	if Inventory.selected_item == "crowbar":
		GameManager.sewer_opened = true
		Inventory.remove_item("crowbar")
		update_room()


func update_room():
	if GameManager.sewer_opened:
		background.texture = bg_sewers_opened

	elif GameManager.crowbar_acquired:
		background.texture = bg_crowbar_collected

	elif GameManager.toolbox_opened:
		background.texture = bg_toolbox_opened

	elif GameManager.padlock_dial_attached:
		background.texture = bg_padlock_complete

	else:
		background.texture = bg_start
