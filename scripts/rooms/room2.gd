extends Node2D

@onready var background = $Background
@onready var safe = $Interactables/Safe
@onready var wall_code = $Interactables/WallCode
@onready var water = $Interactables/Water
@onready var rat_hole = $Interactables/RatHole

var bg_start = preload("res://assets/backgrounds/room2/room2_start.png")
var bg_no_rat = preload("res://assets/backgrounds/room2/room2_no_rat_no_bucket.png")
var bg_bucket = preload("res://assets/backgrounds/room2/room2_bucket.png")
var bg_bucket_filled = preload("res://assets/backgrounds/room2/room2_bucket_filled.png")
var bg_bucket_filled_no_rat = preload("res://assets/backgrounds/room2/room2_bucket_filled_no_rat.png")
var bg_bucket_no_rat = preload("res://assets/backgrounds/room2/room2_bucket_no_rat.png")

var bg_safe_opened = preload("res://assets/backgrounds/room2/room2_safe_opened.png")
var bg_safe_opened_rat = preload("res://assets/backgrounds/room2/room2_ratvisible_safe_open.png")

var bg_uv_collected = preload("res://assets/backgrounds/room2/room2_UV_collected.png")
var bg_safe_opened_rat_uv = preload("res://assets/backgrounds/room2/room2_ratvisible_safe_open_UVLIGHT.png")

var bg_wall_code = preload("res://assets/backgrounds/room2/room2_wall_code.png")
var bg_wall_code_rat = preload("res://assets/backgrounds/room2/room2_wall_code_ratvisible.png")
 
@onready var mouse_sfx = $MouseSfx
var bite_flash: ColorRect
var room_origin = Vector2.ZERO


func _ready():
	safe.input_event.connect(_on_safe_clicked)
	wall_code.input_event.connect(_on_wall_code_clicked)
	water.input_event.connect(_on_water_clicked)
	rat_hole.input_event.connect(_on_rat_hole_clicked) 
	
	# Add Mouse Bite Effect
	room_origin = position

	var flash_layer = CanvasLayer.new()
	flash_layer.layer = 2
	add_child(flash_layer)

	bite_flash = ColorRect.new()
	bite_flash.color = Color(0.997, 0.0, 0.141, 0.0)
	bite_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash_layer.add_child(bite_flash)
	bite_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	check_bucket_fill()
	update_room()

func play_bite_effect():
	mouse_sfx.play()

	var flash_tween = create_tween()
	flash_tween.tween_property(bite_flash, "color:a", 0.4, 0.05)
	flash_tween.tween_property(bite_flash, "color:a", 0.0, 0.8)

	var shake_tween = create_tween()
	for i in range(8):
		var offset = Vector2(randf_range(-8, 8), randf_range(-8, 8))
		shake_tween.tween_property(self, "position", room_origin + offset, 0.04)
	shake_tween.tween_property(self, "position", room_origin, 0.04)
	await shake_tween.finished

func _on_safe_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_safe()


func _on_wall_code_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_wall_code()


func _on_water_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_water()


func _on_rat_hole_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_rat_hole()


func interact_with_safe():
	if GameManager.safe_opened:
		if not GameManager.uv_light_acquired:
			GameManager.uv_light_acquired = true
			await Dialogue.show_text("A UV Light...")
			Inventory.add_item("uv_light")
			update_room()
		return

	if Inventory.selected_item == "key":
		await Dialogue.show_text("Open sesame!")
		GameManager.safe_opened = true
		Inventory.remove_item("key")
		update_room()
		return

	if Inventory.selected_item != "":
		await Dialogue.wrong_item()
		return

	await Dialogue.show_text("Seems like I need a key to open this...")
	await Dialogue.show_text("What could be inside?")


func interact_with_wall_code():
	if GameManager.wall_code_discovered:
		return

	if Inventory.selected_item == "uv_light":
		GameManager.wall_code_discovered = true
		update_room()
		await Dialogue.show_text("A code! I wonder what it could be used for")
		return

	if Inventory.selected_item != "":
		await Dialogue.wrong_item()
		return

	await Dialogue.show_text("'Help'")
	await Dialogue.show_text("How many people were here before me?")
	await Dialogue.show_text("I don't want to think about it...")


func interact_with_water():
	if GameManager.bucket_filled:
		await Dialogue.show_text("There, it's filled!")
		Inventory.add_item("filled_water_bucket")
		GameManager.bucket_placed = false
		GameManager.bucket_filled = false
		update_room()
		return

	if GameManager.bucket_placed:
		return

	if Inventory.selected_item == "bucket":
		await Dialogue.show_text("This may take a while...")
		await Dialogue.show_text("I should look around for ways to get out")
		GameManager.bucket_placed = true
		GameManager.bucket_fill_start_time = Time.get_ticks_msec()
		Inventory.remove_item("bucket")
		update_room()
		return

	if Inventory.selected_item != "":
		await Dialogue.wrong_item()
		return

	await Dialogue.show_text("There's water dripping.")
	await Dialogue.show_text("The pipes aren't very well maintained.")

	if GameManager.bucket_placed:
		return

	if Inventory.selected_item == "bucket":
		GameManager.bucket_placed = true
		GameManager.bucket_fill_start_time = Time.get_ticks_msec()
		Inventory.remove_item("bucket")
		update_room()


func _process(_delta):
	if GameManager.bucket_placed and not GameManager.bucket_filled:
		var elapsed = Time.get_ticks_msec() - GameManager.bucket_fill_start_time

		if elapsed >= 5000:
			GameManager.bucket_filled = true
			update_room()


func check_bucket_fill():
	if GameManager.bucket_placed and not GameManager.bucket_filled:
		var elapsed = Time.get_ticks_msec() - GameManager.bucket_fill_start_time

		if elapsed >= 5000:
			GameManager.bucket_filled = true


func interact_with_rat_hole():
	if GameManager.rat_removed:
		return

	if Inventory.selected_item == "cheese":
		await Dialogue.show_text("Come out you pesky rat!")
		await Dialogue.show_text("I know you want this cheese!")
		GameManager.rat_removed = true
		Inventory.remove_item("cheese")
		update_room() 
		await Dialogue.show_text("There, let's see what's in here...")
		Inventory.add_item("padlock_dial")
		await Dialogue.show_text("A padlock dial?")
		await Dialogue.show_text("Now what would I use this for...")
		return

	if Inventory.selected_item != "":
		await Dialogue.wrong_item()
		return

	GameManager.rat_clicks += 1

	if GameManager.rat_clicks == 1:
		await Dialogue.show_text("There is a rat hiding in the hole...")
	elif GameManager.rat_clicks == 2:
		play_bite_effect()
		await Dialogue.show_text("Ouch! It bit me!")
		await Dialogue.show_text("Hopefully I can treat this once I get out.")
	else:
		await Dialogue.show_text("I don't want to put my hand near that again!")
		await Dialogue.show_text("Wouldn't want to risk getting infected.")
		await Dialogue.show_text("If I haven't already...")


func update_room():
	if GameManager.wall_code_discovered and not GameManager.rat_removed:
		background.texture = bg_wall_code_rat

	elif GameManager.wall_code_discovered:
		background.texture = bg_wall_code

	elif GameManager.uv_light_acquired and not GameManager.rat_removed:
		background.texture = bg_safe_opened_rat

	elif GameManager.uv_light_acquired:
		background.texture = bg_uv_collected

	elif GameManager.safe_opened and not GameManager.rat_removed:
		background.texture = bg_safe_opened_rat_uv

	elif GameManager.safe_opened:
		background.texture = bg_safe_opened

	elif GameManager.bucket_filled and GameManager.rat_removed:
		background.texture = bg_bucket_filled_no_rat

	elif GameManager.bucket_filled:
		background.texture = bg_bucket_filled

	elif GameManager.bucket_placed and GameManager.rat_removed:
		background.texture = bg_bucket_no_rat

	elif GameManager.bucket_placed:
		background.texture = bg_bucket

	elif GameManager.rat_removed:
		background.texture = bg_no_rat

	else:
		background.texture = bg_start
