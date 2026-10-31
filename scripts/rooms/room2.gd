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

func _ready():
	safe.input_event.connect(_on_safe_clicked)
	wall_code.input_event.connect(_on_wall_code_clicked)
	water.input_event.connect(_on_water_clicked)
	rat_hole.input_event.connect(_on_rat_hole_clicked)

	check_bucket_fill()
	update_room()


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
			Inventory.add_item("uv_light")
			update_room()
		return

	if Inventory.selected_item == "key":
		GameManager.safe_opened = true
		Inventory.remove_item("key")
		update_room()


func interact_with_wall_code():
	if GameManager.wall_code_discovered:
		return

	if Inventory.selected_item == "uv_light":
		GameManager.wall_code_discovered = true
		update_room()


func interact_with_water():
	if GameManager.bucket_filled:
		Inventory.add_item("filled_water_bucket")
		GameManager.bucket_placed = false
		GameManager.bucket_filled = false
		update_room()
		return

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
		GameManager.rat_removed = true
		Inventory.remove_item("cheese")
		Inventory.add_item("padlock_dial")
		update_room()


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
