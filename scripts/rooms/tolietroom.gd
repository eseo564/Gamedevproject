extends Node2D

@onready var background = $Background
@onready var toilet = $Interactables/Toilet

var bg_start = preload("res://assets/backgrounds/toiletroom/toiletroom_start.png")
var bg_key_flushed = preload("res://assets/backgrounds/toiletroom/toiletroom_key_flushed.png")
var bg_key_collected = preload("res://assets/backgrounds/toiletroom/toiletroom_key_collected.png")


func _ready():
	toilet.input_event.connect(_on_toilet_clicked)
	update_room()


func _on_toilet_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_toilet()


func interact_with_toilet():
	if GameManager.key_acquired:
		return

	if GameManager.toilet_flushed:
		GameManager.key_acquired = true
		Inventory.add_item("key")
		update_room()
		return

	if Inventory.selected_item == "filled_water_bucket":
		GameManager.toilet_flushed = true
		Inventory.remove_item("filled_water_bucket")
		update_room()


func update_room():
	if GameManager.key_acquired:
		background.texture = bg_key_collected

	elif GameManager.toilet_flushed:
		background.texture = bg_key_flushed

	else:
		background.texture = bg_start
