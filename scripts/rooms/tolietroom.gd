extends Node2D

@onready var background = $Background
@onready var toilet = $Interactables/Toilet

var bg_start = preload("res://assets/backgrounds/toiletroom/toiletroom_start.png")
var bg_key_flushed = preload("res://assets/backgrounds/toiletroom/toiletroom_key_flushed.png")
var bg_key_collected = preload("res://assets/backgrounds/toiletroom/toiletroom_key_collected.png")

@onready var flush_sfx = $FlushSfx

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
		await Dialogue.show_text("A key!")
		Inventory.add_item("key")
		update_room()
		return

	if Inventory.selected_item == "filled_water_bucket":
		GameManager.toilet_flushed = true
		Inventory.remove_item("filled_water_bucket")
		flush_sfx.play()
		update_room()
		await Dialogue.show_text("Something got flushed out!")
		return

	if Inventory.selected_item == "stick":
		await Dialogue.show_text("Argh, I can't reach it!")
		await Dialogue.show_text("The stick is too short!")
		return

	if Inventory.selected_item != "":
		await Dialogue.wrong_item()
		return

	await Dialogue.show_text("A dirty toilet... There's no way I'm using that")
	await Dialogue.show_text("There's something shining in there...")


func update_room():
	if GameManager.key_acquired:
		background.texture = bg_key_collected

	elif GameManager.toilet_flushed:
		background.texture = bg_key_flushed

	else:
		background.texture = bg_start
